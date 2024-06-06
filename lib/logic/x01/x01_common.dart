import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/x01_settings.dart';

class PlayerTurn extends Turn {
  final GameSettings settings;
  final int startScore;

  PlayerTurn(this.settings, this.startScore, {super.first = Hit.skipped, super.second = Hit.skipped, super.third = Hit.skipped});

  static PlayerTurn from(GameSettings settings) {
    return PlayerTurn(settings, settings.points);
  }

  @override
  bool done() {
    return count == 3 || isWin;
  }

  bool get valid {
    for (int i = 0; i < count; i++) {
      int val = startScore - sum(until: i - 1);
      if (!settings.isValid(val, get(i)!)) {
        return false;
      }
    }
    return true;
  }

  int get score {
    return valid ? startScore - sum() : startScore;
  }

  bool get isWin {
    return score == 0;
  }
}

/// Simple Player
class Player {
  final String name;
  final int startScore;
  final List<PlayerTurn> turnHistory = [];

  Player(this.name, this.startScore);

  int get score {
    return turnHistory.isEmpty ? startScore : turnHistory.last.score;
  }

  bool get done {
    return score == 0;
  }
}

/// Container for the active Turn
class GameRound {
  final GameSettings _settings;
  late PlayerTurn current;

  GameRound(this._settings) {
    current = PlayerTurn.from(_settings);
  }

  void setupTurn(PlayerTurn round) {
    current = round;
  }

  void setupTurnFor(Player player) {
    current = PlayerTurn(_settings, player.score);
  }
}

/// Contains player data.
class PlayerData {
  final List<String> _players;
  final int goal;

  final List<Player> _otherPlayer = [];
  final List<Player> _finishedPlayer = [];

  Player currentPlayer = Player('ERROR', -1);

  PlayerData(this._players, this.goal) {
    reset();
  }

  void reset() {
    _otherPlayer.clear();
    _finishedPlayer.clear();

    if (_players.isNotEmpty) {
      _otherPlayer.addAll(_players.map((ply) => Player(ply, goal)));
      currentPlayer = popPlayerFront()!;
    }
  }

  bool get done => _otherPlayer.isEmpty && _finishedPlayer.isNotEmpty;

  bool get isSinglePlayer => _otherPlayer.isEmpty && _finishedPlayer.isEmpty;

  bool get isMultiPlayer => !isSinglePlayer;

  Player? get winner {
    if (_finishedPlayer.isEmpty) return null;
    return _finishedPlayer.first;
  }

  bool remove(Player player) {
    return _otherPlayer.remove(player);
  }

  Player get next => _otherPlayer.first;

  void setCurrentPlayer(Player player) {
    currentPlayer = player;
  }

  void pushPlayerBack(Player player) {
    _otherPlayer.add(player);
  }

  void pushPlayerFront(Player player) {
    _otherPlayer.insert(0, player);
  }

  Player? popPlayerFront() {
    if (_otherPlayer.isEmpty) return null;
    return _otherPlayer.removeAt(0);
  }

  Player? popPlayerBack() {
    if (_otherPlayer.isEmpty) return null;
    return _otherPlayer.removeAt(_otherPlayer.length - 1);
  }

  void addWinner(Player player) {
    _finishedPlayer.add(player);
  }

  Player? popWinner() {
    return _finishedPlayer.isEmpty ? null : _finishedPlayer.removeLast();
  }

  Iterable<T> mapPlayer<T>(T Function(Player) toElement) {
    return _otherPlayer.map(toElement);
  }

  Iterable<T> mapWinner<T>(T Function(Player) toElement) {
    return _finishedPlayer.map(toElement);
  }
}
