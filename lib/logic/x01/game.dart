import 'package:dart_dart/logic/common/commands.dart';
import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/checkout.dart';
import 'package:dart_dart/logic/x01/commands.dart';
import 'package:dart_dart/logic/x01/common.dart';
import 'package:dart_dart/logic/x01/player.dart';
import 'package:dart_dart/logic/x01/settings.dart';
import 'package:dart_dart/logic/x01/statistics.dart';

enum InputType { board, field }

class X01GamePoints {
  int _sets = 0;
  int _legs = 0;

  int get legs => _legs;

  int get sets => _sets;

  X01GamePoints({int sets = 0, int legs = 0}) {
    _sets = sets;
    _legs = legs;
  }

  X01GamePoints incrementSets() {
    _sets++;
    return this;
  }

  X01GamePoints setLegs(int legs) {
    _legs = legs;
    return this;
  }

  bool lowerThan(X01GamePoints points) {
    if (_sets < points._sets) {
      return true;
    } else if (_sets == points._sets) {
      return _legs < points._legs;
    } else {
      return false;
    }
  }
}

class X01GameData {
  final List<GameSet> _sets = [GameSet(0)];
  late final int initialScore;

  X01GameData(GameSettings settings) {
    initialScore = settings.points;
  }

  int legsWonInTotal(Player? ply) {
    if (ply == null) return 0;
    int legs = 0;
    for (var set in _sets) {
      legs += set.legsWon(ply.name);
    }
    return legs;
  }

  int _setsWonInTotal(String? ply) {
    if (ply == null) return 0;
    return _sets.where((set) => set.winnerId() == ply).length;
  }

  (int, int) points(String? ply) {
    if (ply == null) return (0, 0);
    int sets = _setsWonInTotal(ply);
    int legs = currentSet.legsWon(ply);
    return (sets, legs);
  }

  int score(String ply) {
    return currentLeg.currentScoreFor(ply) ?? initialScore;
  }

  String? leaderId() {
    final perPlayerPoints = _perPlayerPoints();
    if (perPlayerPoints.isEmpty) return null;

    return perPlayerPoints.entries
        .reduce((currentLeader, nextEntry) =>
            currentLeader.value.lowerThan(nextEntry.value)
                ? nextEntry
                : currentLeader)
        .key;
  }

  Map<String, X01GamePoints> _perPlayerPoints() {
    Map<String, X01GamePoints> perPlayerWins = {};
    for (var set in _sets) {
      if (set.isDone()) {
        final String player = set.winnerId()!;
        perPlayerWins.update(
          player,
          (points) => points.incrementSets(),
          ifAbsent: () => X01GamePoints(sets: 1),
        );
      }
    }
    for (var entry in currentSet.legsWonPerPlayer().entries) {
      final String player = entry.key;
      perPlayerWins.update(
        player,
        (points) => points.setLegs(entry.value),
        ifAbsent: () => X01GamePoints(legs: entry.value),
      );
    }
    return perPlayerWins;
  }

  void reset() {
    _sets.clear();
    pushSet();
  }

  int totalTurnCount(Player player) {
    int total = 0;
    for (GameSet set in _sets) {
      total += set.totalTurnCount(player.name);
    }
    return total;
  }

  void pushSet({GameSet? set}) {
    _sets.add(set ?? GameSet(_sets.length));
  }

  X01Turn? lastPlayerTurn(String player) {
    return currentSet.currentLeg.lastPlayerTurn(player);
  }

  GameLeg get currentLeg => currentSet.currentLeg;

  GameSet get currentSet => _sets.last;

  void popSet() => _sets.removeLast();

  void pushLeg({GameLeg? leg}) => _sets.last.pushLeg(leg: leg);

  void popLeg() => _sets.last.popLeg();

  void pushTurn(String player, X01Turn turn) =>
      currentLeg.pushTurn(player, turn);

  void popTurn(String player) => currentLeg.popTurn(player);

  void revokeLegWinner() => currentLeg.revokeWinner();

  void revokeSetWinner() => currentSet.revokeWinner();

  void setLegWinner(Player player) => currentLeg.setWinner(player.name);

  void setSetWinner(Player player) => currentSet.setWinner(player.name);
}

/// Represents a single Game
class GameController {
  final GameSettings settings;
  final CommandStack commands = CommandStack();

  late final X01GameData gameData;
  late final PlayerData playerData;
  late final TurnBuilder turnBuilder;
  late final List<String> _playerNames;

  GameController(this.settings) {
    _playerNames = settings.player;
    turnBuilder = TurnBuilder(settings);
    playerData = PlayerData.get(_playerNames);
    gameData = X01GameData(settings);
  }

  String get curPoints {
    if (settings.isFirstWins) {
      return '';
    }
    var setsLegs = gameData.points(curPly.name);
    if (settings.isLegsOnly) {
      return '(${setsLegs.$2})';
    } else {
      return '(${setsLegs.$1}-${setsLegs.$2})';
    }
  }

  void reset() {
    gameData.reset();
    turnBuilder.reset();
    playerData.reset();
    commands.clear();
  }

  Checkout get checkout {
    if (turnBuilder.valid) {
      final out = settings.gameOut;
      final score = turnBuilder.score;
      final remain = turnBuilder.remain;
      return calcCheckout(out, score, dartsRemain: remain);
    } else {
      return Checkout();
    }
  }

  (int, int) get leaderPoints => gameData.points(totalLeader?.name);

  (int, int) get curPlyPoints => gameData.points(curPly.name);

  bool get isMultiPlayer => playerData.isMultiPlayer;

  Player get curPly => playerData.current;

  Player? get totalLeader {
    var leaderName = gameData.leaderId();
    return playerData.find(leaderName ?? _playerNames.first);
  }

  Player? get setLeader {
    var leaderName = gameData.currentLeg.leader();
    return playerData.find(leaderName ?? _playerNames.first);
  }

  Player? get winner {
    var name = gameData.leaderId();
    if (name == null) return null;
    var points = gameData.points(name);
    if (points.$1 >= settings.sets) {
      return playerData.find(name);
    }
    return null;
  }

  bool get hasGameEnded => winner != null;

  bool get willGameEnd {
    if (!turnBuilder.isCheckout) {
      return false;
    }
    final points = gameData.points(curPly.name);
    return points.$2 + 1 == settings.legs && points.$1 + 1 == settings.sets;
  }

  void onThrow(Hit hit) {
    if (turnBuilder.done) return;
    var action = Throw(turnBuilder, hit, turnBuilder.count);
    commands.execute(action);
  }

  void next() {
    final command = _nextCommand();
    commands.execute(command);
  }

  Command _nextCommand() {
    if (!turnBuilder.isCheckout) {
      return Switch.from(playerData, gameData, turnBuilder);
    }
    final playerPoints = gameData.points(curPly.name);

    if (playerPoints.$2 + 1 == settings.legs) {
      if (playerPoints.$1 + 1 == settings.sets) {
        return EndGame.from(playerData, gameData, turnBuilder);
      }
      return EndSet.from(playerData, gameData, turnBuilder);
    }
    return EndLeg.from(playerData, gameData, turnBuilder);
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
    final nextIsGameEnd = commands.current?.next is EndGame;
    return commands.canRedo && !nextIsGameEnd;
  }

  GameStats getStats() {
    return GameStats(gameData._sets, winner!.name, _playerNames, settings.game);
  }
}

/// Container for the active Turn
class TurnBuilder {
  final GameSettings _settings;

  late Turn _currentTurn;
  X01Turn? _previous;
  late TurnCheck _curCheck = TurnCheck.instance();

  TurnBuilder(this._settings) {
    reset();
  }

  int get _initScore {
    return _previous == null ? _settings.game.val : _previous!.getScore();
  }

  int get startScore {
    return _previous == null ? _settings.points : _previous!.getScore();
  }

  bool get done =>
      _currentTurn.count == 3 || isCheckout || invalid || overthrown;

  bool get overthrown {
    final sum = _currentTurn.sum();
    return startScore < sum || (startScore == sum && !isCheckout);
  }

  bool get valid => _curCheck.isValid;

  bool get invalid => !valid;

  int get score {
    final updated = startScore - _currentTurn.sum();
    if (valid) {
      return updated <= 0 ? 0 : updated;
    } else {
      return startScore;
    }
  }

  bool get isCheckout {
    return _curCheck.isCheckOut;
  }

  int get remain => _currentTurn.remain;

  int get count => _currentTurn.count;

  Hit get first => _currentTurn.first;

  Hit get second => _currentTurn.second;

  Hit get third => _currentTurn.third;

  //Private
  void _updateCheck() {
    _curCheck = _settings.check(_initScore, _currentTurn);
  }

  void _setTo(Turn turn, X01Turn? previous) {
    _currentTurn = turn;
    _previous = previous;
    _updateCheck();
  }

  //Public
  void thrown(Hit hit, {int? pos}) {
    _currentTurn.thrown(hit, pos: pos ?? count);
    _updateCheck();
  }

  void undo(int pos) {
    _currentTurn.undo(pos: pos);
    _updateCheck();
  }

  void setupTurn(Turn turn, X01Turn? previous) {
    _setTo(turn, previous);
  }

  void setupTurnFor(X01Turn? previous) {
    _setTo(Turn(), previous);
  }

  void reset() {
    _setTo(Turn(), null);
  }

  void resetTo(X01Turn turn) {
    var nextTurn =
        Turn(first: turn.first, second: turn.second, third: turn.third);
    X01Turn? nextPrevious;
    if (turn is GameTurn) {
      nextPrevious = turn.previous;
    }
    _setTo(nextTurn, nextPrevious);
  }

  X01Turn build() {
    if (_previous == null) {
      return InitTurn(
          first: _currentTurn.first,
          second: _currentTurn.second,
          third: _currentTurn.third,
          check: _curCheck,
          initScore: _settings.game.val);
    } else {
      return GameTurn(
        first: _currentTurn.first,
        second: _currentTurn.second,
        third: _currentTurn.third,
        check: _curCheck,
        previous: _previous!,
      );
    }
  }
}
