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

  int _turnCount = 0;
  int _turnTotal = 0;
  Turn? _turnMin;
  Turn? _turnMax;
  int _sixtyPlusCnt = 0;
  int _oneTwentyPlusCnt = 0;
  int _oneEightyCnt = 0;

  PlayerGameStats(this.isWinner, this.player);

  void _checkMinMax(Turn t) {
    if (_turnMax == null && _turnMin == null) {
      _turnMax = t;
      _turnMin = t;
      return;
    }
    if (_turnMin!.sum() > t.sum()) {
      _turnMin = t;
    }
    if (_turnMax!.sum() < t.sum()) {
      _turnMax = t;
    }
  }

  void _checkTurn(Turn turn) {
    _checkMinMax(turn);
    _turnTotal += turn.sum();
    _turnCount ++;

    if(turn.first != Hit.miss) {
      _hitPerField.update(turn.first, (value) => value++, ifAbsent: () => 1);
    }
    if(turn.second != Hit.miss) {
      _hitPerField.update(turn.second, (value) => value++, ifAbsent: () => 1);
    }
    if(turn.third != Hit.miss) {
      _hitPerField.update(turn.third, (value) => value++, ifAbsent: () => 1);
    }
  }

  void applyTurn(Turn turn) {
    _checkTurn(turn);

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
    return _turnTotal / _turnCount;
  }

  Hit get mostHit {
    if ( _hitPerField.entries.isEmpty ) {
      return Hit.miss;
    }

    var max = _hitPerField.entries.first;
    for (var entry in _hitPerField.entries) {
      if (entry.value > max.value) {
        max = entry;
      }
    }
    return max.key;
  }

  int get minPoints {
    return _turnMin != null ? _turnMin!.sum() : 0;
  }

  int get maxPoints {
    return _turnMax != null ? _turnMax!.sum() : 0;
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