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
    int val = startScore;
    for (int i = 0; i < count; i++) {
      var hit = get(i)!;
      if (settings.isInvalid(val, hit)) {
        return false;
      }
      val -= hit.value;
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
abstract class PlayerData {
  PlayerData._();

  Player get currentPlayer;
  /// count of players still in the game (excluding current Player)
  int get playerCount;
  Player? get winner;

  void reset();

  bool get isSinglePlayer;
  bool get isMultiPlayer;
  /// get next Player in line
  Player get next;
  /// set current player
  void setCurrentPlayer(Player player);
  /// add player to the back of the line
  void pushPlayerBack(Player player);
  /// add player to the front of the line
  void pushPlayerFront(Player player);
  /// remove player from the front of the line
  Player? popPlayerFront();
  /// remove player from the back of the line
  Player? popPlayerBack();
  /// award player to winner
  void addWinner(Player player);
  /// remove last winner from list
  Player? popWinner();

  Iterable<T> mapPlayer<T>(T Function(Player) toElement);
  Iterable<T> mapWinner<T>(T Function(Player) toElement);

  static PlayerData get(List<String> player, int goal) {
    if(player.length == 1) {
      return _SinglePlayerData(player.first, goal);
    } else {
      return _MultiPlayerData(player, goal);
    }
  }
}

class _MultiPlayerData implements PlayerData {
  final List<String> _players;
  final int goal;

  final List<Player> _otherPlayer = [];
  final List<Player> _finishedPlayer = [];

  @override
  Player currentPlayer = Player('ERROR', -1);

  _MultiPlayerData(this._players, this.goal) {
    reset();
  }

  @override
  void reset() {
    _otherPlayer.clear();
    _finishedPlayer.clear();

    if (_players.isNotEmpty) {
      _otherPlayer.addAll(_players.map((ply) => Player(ply, goal)));
      currentPlayer = popPlayerFront()!;
    }
  }

  bool get done => _otherPlayer.isEmpty && _finishedPlayer.isNotEmpty;

  @override
  bool get isSinglePlayer => false;
  @override
  bool get isMultiPlayer => true;

  @override
  Player? get winner {
    if (_finishedPlayer.isEmpty) return null;
    return _finishedPlayer.first;
  }

  @override
  int get playerCount => _otherPlayer.length;

  bool remove(Player player) {
    return _otherPlayer.remove(player);
  }

  @override
  Player get next => _otherPlayer.first;

  @override
  void setCurrentPlayer(Player player) {
    currentPlayer = player;
  }

  @override
  void pushPlayerBack(Player player) {
    _otherPlayer.add(player);
  }

  @override
  void pushPlayerFront(Player player) {
    _otherPlayer.insert(0, player);
  }

  @override
  Player? popPlayerFront() {
    if (_otherPlayer.isEmpty) return null;
    return _otherPlayer.removeAt(0);
  }

  @override
  Player? popPlayerBack() {
    if (_otherPlayer.isEmpty) return null;
    return _otherPlayer.removeAt(_otherPlayer.length - 1);
  }

  @override
  void addWinner(Player player) {
    _finishedPlayer.add(player);
  }

  @override
  Player? popWinner() {
    return _finishedPlayer.isEmpty ? null : _finishedPlayer.removeLast();
  }

  @override
  Iterable<T> mapPlayer<T>(T Function(Player) toElement) {
    return _otherPlayer.map(toElement);
  }

  @override
  Iterable<T> mapWinner<T>(T Function(Player) toElement) {
    return _finishedPlayer.map(toElement);
  }
}

class _SinglePlayerData implements PlayerData {
  final String _playerName;
  final int goal;

  @override
  late Player currentPlayer;
  bool done = false;

  _SinglePlayerData(this._playerName, this.goal) {
    reset();
  }

  @override
  void reset() {
    currentPlayer = Player(_playerName, goal);
  }

  @override
  bool get isSinglePlayer => true;
  @override
  bool get isMultiPlayer => false;

  @override
  Player? get winner {
    return done ? currentPlayer : null;
  }

  @override
  int get playerCount => done ? 0 : 1;

  bool remove(Player player) {
    return false;
  }

  @override
  Player get next => currentPlayer;

  @override
  void setCurrentPlayer(Player player) {
    return;
  }

  @override
  void pushPlayerBack(Player player) {
    return;
  }

  @override
  void pushPlayerFront(Player player) {
    return;
  }

  @override
  Player? popPlayerFront() {
    return currentPlayer;
  }

  @override
  Player? popPlayerBack() {
    return currentPlayer;
  }

  @override
  void addWinner(Player player) {
    if (player == currentPlayer) {
      done = true;
    }
  }

  @override
  Player? popWinner() {
    if (done) {
      done = false;
      return currentPlayer;
    } else {
      return null;
    }
  }

  @override
  Iterable<T> mapPlayer<T>(T Function(Player) toElement) {
    return [currentPlayer].map(toElement);
  }

  @override
  Iterable<T> mapWinner<T>(T Function(Player) toElement) {
    return done ? [currentPlayer].map(toElement) : [];
  }
}