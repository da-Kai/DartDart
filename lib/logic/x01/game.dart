import 'package:dart_dart/logic/common/commands.dart';
import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/checkout.dart';
import 'package:dart_dart/logic/x01/commands.dart';
import 'package:dart_dart/logic/x01/common.dart';
import 'package:dart_dart/logic/x01/player.dart';
import 'package:dart_dart/logic/x01/settings.dart';

enum InputType { board, field }

/// Represents a single Game
class GameController {
  final List<String> _playerNames;
  final GameSettings settings;
  late final PlayerData playerData;

  late final GameRound gameRound;
  final CommandStack commands = CommandStack();

  GameController(this._playerNames, this.settings) {
    Player plyFunc(name) => Player(name, settings.points, () => gameRound.currentLeg);
    gameRound = GameRound(settings);
    playerData = PlayerData.get(_playerNames, plyFunc);
    reset();
  }

  String get curPoints {
    if(settings.isFirstWins) {
      return '';
    } else if(settings.isLegsOnly) {
      return '(${curPly.points.currentLegs})';
    } else {
      return '(${curPly.points.sets}-${curPly.points.currentLegs})';
    }
  }

  void reset() {
    gameRound.reset();
    playerData.reset();
    commands.clear();
  }

  Checkout get checkout {
    if (curTurn.valid) {
      final out = settings.gameOut;
      final score = gameRound.current.score;
      final remain = gameRound.current.remain;
      return calcCheckout(out, score, dartsRemain: remain);
    } else {
      return Checkout();
    }
  }

  PlayerTurn get curTurn => gameRound.current;

  bool get isMultiPlayer => playerData.isMultiPlayer;

  Player get curPly => playerData.current;

  Player? get leader {
    Player? leader;
    playerData.forEach((ply) {
      if (leader == null) {
        leader = ply;
      } else {
        if (leader!.points < ply.points) {
          leader = ply;
        }
      }
    });
    return leader;
  }

  Player? get winner {
    var lead = leader;
    return (lead != null && lead.points.sets == settings.sets) ? lead : null;
  }

  bool get hasGameEnded => winner != null;

  void onThrow(Hit hit) {
    if(curTurn.done) return;
    var action = Throw(gameRound, hit, curTurn.count);
    commands.execute(action);
  }

  void next() {
    if(!curTurn.isCheckout) {
      commands.execute(Switch.from(playerData, gameRound));
      return;
    }

    if(curPly.points.currentLegs+1 < settings.legs) {
      commands.execute(EndLeg.from(playerData, gameRound));
      return;
    }

    commands.execute(EndSet.from(playerData, gameRound));
  }

  void undo() {
    commands.undo();
  }

  void redo() {
    commands.redo();
  }

  bool get canUndo {
    return commands.canUndo;
  }

  bool get canRedo {
    return commands.canRedo;
  }

  GameStats getStats() {
    return GameStats(commands, _playerNames, winner!.name);
  }
}

class ProgressPerLeg {
  final int set;
  final int leg;
  final Map<String, List<Turn>> turnsPerPlayer = {};

  ProgressPerLeg(this.set, this.leg);

  void applyTurn(String player, Turn turn) {
    turnsPerPlayer.putIfAbsent(player, () => []);
    turnsPerPlayer[player]!.add(turn);
  }
}

class GameStats {
  final CommandStack commands;
  final Map<String, PlayerGameStats> playerStats = {};
  final List<ProgressPerLeg> progress = [];

  GameStats(this.commands, List<String> players, String winner) {
    for (var ply in players) {
      playerStats.putIfAbsent(ply, () => PlayerGameStats(ply == winner, ply));
    }
    progress.add(ProgressPerLeg(0, 0));

    Command? cur = commands.first!;
    String player = players.first;
    Turn turn = Turn();

    do {
      if (cur is Throw) {
        turn.set(cur.pos, cur.hit);
      } else if (cur is Switch) {
        playerStats[player]!.applyTurn(turn);
        progress.last.applyTurn(player, turn);
        turn = Turn();

        player = cur.nextPly.name;
      } else if (cur is EndLeg) {
        playerStats[player]!.applyTurn(turn);
        progress.last.applyTurn(player, turn);
        turn = Turn();

        String next = cur.nextPly();
        player = players.firstWhere((ply) => ply == next);
        progress.add(ProgressPerLeg(progress.last.set, progress.last.leg + 1));
      } else if (cur is EndSet) {
        playerStats[player]!.applyTurn(turn);
        progress.last.applyTurn(player, turn);
        turn = Turn();

        var next = cur.nextPly();
        player = players.firstWhere((ply) => ply == next);
        progress.add(ProgressPerLeg(progress.last.set + 1, 0));
      }

      cur = cur!.next;
    } while(cur != null);
  }
}

class PlayerGameStats {
  final bool isWinner;
  final String player;
  final Map<Hit, int> _hitPerField = {};

  int _hitCount = 0;
  int _hitTotal = 0;
  Hit _hitMin = Hit.skipped;
  Hit _hitMax = Hit.skipped;
  int _sixtyPlusCnt = 0;
  int _oneTwentyPlusCnt = 0;
  int _oneEightyCnt = 0;

  PlayerGameStats(this.isWinner, this.player);

  void _checkMinMax(Hit hit) {
    if (_hitCount == 0) {
      _hitMin = _hitMax = hit;
    } else if (_hitMin.value > hit.value) {
      _hitMin = hit;
    } else if (_hitMax.value < hit.value) {
      _hitMax = hit;
    }
  }

  void _checkTurn(Hit hit) {
    if (hit != Hit.skipped) {
      _checkMinMax(hit);
      _hitTotal += hit.value;
      _hitCount ++;
      _hitPerField.update(hit, (value) => value++, ifAbsent: () => 1);
    }
  }

  void applyTurn(Turn turn) {
    _checkTurn(turn.first);
    _checkTurn(turn.second);
    _checkTurn(turn.third);

    var sum = turn.sum();
    if (sum >= 60) {
      _sixtyPlusCnt++;
      if (sum >= 120) {
        _oneTwentyPlusCnt++;
        if (sum == 180) _oneEightyCnt++;
      }
    }
  }

  double get avgScore {
    return _hitTotal / _hitCount;
  }

  Hit get mostHit {
    return _hitPerField.entries
        .reduce((current, next) => current.value > next.value ? current : next)
        .key;
  }

  int get minPoints {
    return _hitMin.value;
  }

  int get maxPoints {
    return _hitMax.value;
  }

  int get sixtyPlusCnt {
    return _sixtyPlusCnt;
  }

  int get oneTwentyPlusCnt {
    return _oneTwentyPlusCnt;
  }

  int get oneEightyCnt {
    return _oneEightyCnt;
  }
}