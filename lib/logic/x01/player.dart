import 'package:dart_dart/logic/common/list_utils.dart';
import 'package:dart_dart/logic/x01/common.dart';

/// Contains player data.
abstract class PlayerData {
  PlayerData._();

  /// count of players still in the game (excluding current Player)
  int get playerCount;

  /// Reset the players
  void reset();

  bool get isSinglePlayer;

  bool get isMultiPlayer;

  Player get current;

  /// get next Player in line
  Player get next;

  /// get last Player in line
  Player get last;

  void rotateForward();

  void rotateBackwards();

  Iterable<T> mapPlayer<T>(T Function(Player) toElement, {int skip = 0});

  void forEach(void Function(Player) action);

  static PlayerData get(List<String> playernames) {
    List<Player> player = playernames.map((name) => Player(name)).toList();
    if (player.length == 1) {
      return _SinglePlayerData(player.first);
    } else {
      return _MultiPlayerData(player);
    }
  }

  Player find(String name);

  void organize(List<String> player, String current);

  List<String> reorder(int Function(Player, Player) order);

  List<Player> asList();
}

class _MultiPlayerData implements PlayerData {
  final List<Player> _playerList;

  int _currentPlayer = 0;

  _MultiPlayerData(this._playerList) {
    reset();
  }

  @override
  void reset() {
    _currentPlayer = 0;
  }

  int _getIndex(int delta) {
    if(_playerList.isEmpty) return _currentPlayer;
    return (_currentPlayer+delta) % _playerList.length;
  }

  Player _byDelta(int delta) {
    return _playerList[_getIndex(delta)];
  }

  @override
  Player get current => _byDelta(0);

  @override
  Player get next => _byDelta(1);

  @override
  Player get last => _byDelta(-1);

  @override
  bool get isSinglePlayer => false;

  @override
  bool get isMultiPlayer => true;

  @override
  int get playerCount => _playerList.length;

  @override
  void rotateForward() {
    _currentPlayer = _getIndex(1);
  }

  @override
  void rotateBackwards() {
    _currentPlayer = _getIndex(-1);
  }

  @override
  Iterable<T> mapPlayer<T>(T Function(Player) toElement, {int skip = 0}) {
    return IndexIterable(_playerList, _currentPlayer).map(toElement).skip(skip);
  }

  @override
  void organize(List<String> player, String curPly) {
    if (player.length != _playerList.length) {
      throw Exception("Player list is not of same Length! can't organize.");
    }
    for (var name in player) {
      var ply = find(name);
      _playerList.remove(ply);
      _playerList.add(ply);
    }
    _currentPlayer = 0;
    while (curPly == current.name) {
      _currentPlayer++;
    }
  }

  @override
  List<String> reorder(int Function(Player, Player) order) {
    var current = _playerList.map((p) => p.name).toList();
    _playerList.sort(order);
    return current;
  }

  @override
  Player find(String name) {
    return _playerList.firstWhere((p) => p.name == name);
  }

  @override
  void forEach(void Function(Player) action) {
    _playerList.forEach(action);
  }

  @override
  List<Player> asList() {
    return _playerList;
  }
}

class _SinglePlayerData implements PlayerData {
  @override
  final Player current;

  _SinglePlayerData(this.current) {
    reset();
  }

  @override
  void reset() {}

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
  Player get next => current;

  @override
  Player get last => current;

  @override
  void rotateForward() {
    return;
  }

  @override
  void rotateBackwards() {
    return;
  }

  @override
  Iterable<T> mapPlayer<T>(T Function(Player) toElement, {int skip = 0}) {
    List<Player> player = skip == 0 ? [current] : [];
    return player.map(toElement);
  }

  @override
  void organize(List<String> player, String current) {
    return;
  }

  @override
  Player find(String name) {
    if (name != current.name) {
      throw Exception('Player name unknown!');
    }
    return current;
  }

  @override
  void forEach(void Function(Player) action) => action(current);

  @override
  List<String> reorder(int Function(Player, Player) order) {
    return [current.name];
  }

  @override
  List<Player> asList() {
    return [current];
  }
}
