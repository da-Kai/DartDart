import 'dart:collection';

import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/settings.dart';

class PlayerTurn extends Turn {
  final GameSettings settings;
  final int startScore;

  PlayerTurn(this.settings, this.startScore,
      {super.first = Hit.skipped,
        super.second = Hit.skipped,
        super.third = Hit.skipped});

  static PlayerTurn from(GameSettings settings) {
    return PlayerTurn(settings, settings.points);
  }

  @override
  bool done() {
    return count == 3 || isCheckout || overthrown;
  }

  bool get overthrown => startScore < sum();

  bool get valid {
    int val = startScore;
    for (int i = 0; i < count; i++) {
      var hit = get(i)!;
      if (settings.isInvalid(val, hit)) {
        return false;
      }
      val -= hit.value;
      if (val == 0 && settings.isValidFinisher(hit)) {
        return true;
      }
    }
    return true;
  }

  int get score {
    final updated = startScore - sum();
    if (valid) {
      return updated <= 0 ? 0 : updated;
    } else {
      return startScore;
    }
  }

  bool get isCheckout {
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

class LegAndSetData {

  late final List<String> _setHistory;

  late final Map<String, int> _playerLegs;
  late final Map<String, int> _playerSets;

  LegAndSetData(List<String> player) {
    _playerLegs = HashMap.fromIterable(player, key: (p) => p, value: (p) => 0);
    _playerSets = HashMap.fromIterable(player, key: (p) => p, value: (p) => 0);
  }

  int _calcLeg(String player, int add, int other) {
      return _playerLegs.update(player, (i) => i+add, ifAbsent: () => other);
  }

  /// Add one to the given players legs and return its current Legs.
  int addLeg(String player) {
    return _calcLeg(player, 1, 1);
  }

  int removeLeg(String player) {
    return _calcLeg(player, -1, 0);
  }

  int addSet(String player) {
    return _playerSets.update(player, (i) => i++, ifAbsent: () => 1);
  }

  Map<String, int> resetLegs() {
    var curLegs = Map<String, int>.from(_playerLegs);
    _playerLegs.clear();
    return curLegs;
  }

  void setLegs(Map<String, int> legs) {
    _playerLegs.updateAll((key, _) => legs[key] ?? 0);
  }

  int getSets(String player) {
    return _playerSets[player] ?? 0;
  }

  String getLeader() {
    List<int> values = _playerSets.values.toList()..sort((a, b) => a - b);
    return _playerSets.entries.where((e) => e.value == values.first).first.key;
  }

}

/// Contains player data.
abstract class PlayerData {
  PlayerData._();

  Player get currentPlayer;

  /// count of players still in the game (excluding current Player)
  int get playerCount;

  /// Reset the players and return their current order
  List<String> reset();

  bool get isSinglePlayer;

  bool get isMultiPlayer;

  /// get next Player in line
  Player get next;

  /// set current player
  void setCurrentPlayer(Player player);

  void rotateForward();

  void rotateBackwards();

  /// get player from the front of the line
  Player peekPlayerFront();

  /// get player from the back of the line
  Player peekPlayerBack();

  Iterable<T> mapPlayer<T>(T Function(Player) toElement);

  static PlayerData get(List<String> player, int goal) {
    if (player.length == 1) {
      return _SinglePlayerData(player.first, goal);
    } else {
      return _MultiPlayerData(player, goal);
    }
  }

  Player find(String name);

  void organize(List<String> player);
}

class _MultiPlayerData implements PlayerData {
  final List<String> _players;
  final int goal;

  final List<Player> _playerList = [];

  _MultiPlayerData(this._players, this.goal) {
    reset();
  }

  @override
  List<String> reset() {
    var cur = _playerList.map((p) => p.name).toList();
    cur.insert(0, currentPlayer.name);

    _playerList.clear();
    if (_players.isNotEmpty) {
      _playerList.addAll(_players.map((ply) => Player(ply, goal)));
    }

    return cur;
  }

  @override
  Player get currentPlayer => peekPlayerFront();

  @override
  bool get isSinglePlayer => false;

  @override
  bool get isMultiPlayer => true;

  @override
  int get playerCount => _playerList.length;

  bool remove(Player player) {
    return _playerList.remove(player);
  }

  @override
  Player get next => _playerList.first;

  @override
  void setCurrentPlayer(Player player) {
    if(!_playerList.contains(player)) {
      throw Exception('Player "${player.name}" is not part of the Game!');
    }
    while(currentPlayer != player) {
      rotateForward();
    }
  }

  @override
  void rotateForward() {
    var ply = _playerList.removeAt(0);
    _playerList.add(ply);
  }

  @override
  void rotateBackwards() {
    var ply = _playerList.removeLast();
    _playerList.insert(0, ply);
  }

  @override
  Player peekPlayerFront() {
    return _playerList.first;
  }

  @override
  Player peekPlayerBack() {
    return _playerList.last;
  }

  @override
  Iterable<T> mapPlayer<T>(T Function(Player) toElement) {
    return _playerList.map(toElement);
  }

  @override
  void organize(List<String> player) {
    if(player.length != _playerList.length) {
      throw Exception("Player list is not of same Length! can't organize.");
    }
    for(var name in player) {
      var ply = find(name);
      _playerList.remove(ply);
      _playerList.add(ply);
    }
  }

  @override
  Player find(String name) {
    return _playerList.firstWhere((p) => p.name == name);
  }
}

class _SinglePlayerData implements PlayerData {
  final String _playerName;
  final int goal;

  @override
  late Player currentPlayer;

  _SinglePlayerData(this._playerName, this.goal) {
    reset();
  }

  @override
  List<String> reset() {
    currentPlayer = Player(_playerName, goal);
    return [_playerName];
  }

  @override
  bool get isSinglePlayer => true;

  @override
  bool get isMultiPlayer => false;

  @override
  int get playerCount => 1;

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
  void rotateForward() {
    return;
  }

  @override
  void rotateBackwards() {
    return;
  }

  @override
  Player peekPlayerFront() {
    return currentPlayer;
  }

  @override
  Player peekPlayerBack() {
    return currentPlayer;
  }

  @override
  Iterable<T> mapPlayer<T>(T Function(Player) toElement) {
    return [currentPlayer].map(toElement);
  }

  @override
  void organize(List<String> player) {
    return;
  }

  @override
  Player find(String name) {
    if(name != currentPlayer.name) {
      throw Exception('Player name unknown!');
    }
    return currentPlayer;
  }
}
