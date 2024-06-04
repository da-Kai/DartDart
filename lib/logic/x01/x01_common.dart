import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/x01_settings.dart';

class PlayerRound {
  final GameSettings settings;
  final int startScore;

  Hit first;
  Hit second;
  Hit third;

  PlayerRound(this.settings, this.startScore, {this.first = Hit.skipped, this.second = Hit.skipped, this.third = Hit.skipped});

  static PlayerRound from(GameSettings settings) {
    return PlayerRound(settings, settings.points);
  }

  Hit? get last {
    return get(count - 1);
  }

  Hit? get(int pos) {
    switch (pos) {
      case 0:
        return first;
      case 1:
        return second;
      case 2:
        return third;
      default:
        return null;
    }
  }

  /// Add Hit to throws and return the position.
  ///
  /// If no position is given, the next one is chosen.
  int thrown(Hit hit, {int? pos}) {
    switch (pos ?? count) {
      case 0:
        first = hit;
        return 0;
      case 1:
        second = hit;
        return 1;
      case 2:
        third = hit;
        return 2;
      default:
        return -1;
    }
  }

  /// Undo a Hit and return, if anything changed.
  ///
  /// If no position is given, the last one is chosen.
  bool undo({int? pos}) {
    switch (pos ?? count) {
      case 0:
        first = Hit.skipped;
        return true;
      case 1:
        second = Hit.skipped;
        return true;
      case 2:
        third = Hit.skipped;
        return true;
    }
    return false;
  }

  /// Get the number of hits.
  int get count {
    if (third != Hit.skipped) return 3;
    if (second != Hit.skipped) return 2;
    if (first != Hit.skipped) return 1;
    return 0;
  }

  /// Get the total sum of throws
  int sum({int until = 2}) {
    int sum = 0;
    if (until >= 0) sum += first.value;
    if (until >= 1) sum += second.value;
    if (until >= 2) sum += third.value;
    return sum;
  }

  /// Return if all hits are taken.
  bool done() {
    return count == 3 || score == 0;
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
  final List<PlayerRound> rounds = [];

  Player(this.name, this.startScore);

  int get score {
    return rounds.isEmpty ? startScore : rounds.last.score;
  }

  bool get done {
    return score == 0;
  }
}

///
class GameRound {
  final GameSettings settings;
  late PlayerRound current;

  GameRound(this.settings) {
    current = PlayerRound.from(settings);
  }

  void setRound(PlayerRound round) {
    current = round;
  }

  void setRoundFor(Player player) {
    current = PlayerRound(settings, player.score);
  }
}

/// Contains player data.
class PlayerData {
  final List<Player> otherPlayer = [];
  final List<Player> finishedPlayer = [];

  Player currentPlayer = Player('ERROR', -1);

  PlayerData(List<String> players, int goal) {
    if (players.isNotEmpty) {
      otherPlayer.addAll(players.map((ply) => Player(ply, goal)));
      var ply = popPlayerFront();
      if (ply is Player) {
        currentPlayer = ply;
      } else {
        throw ArgumentError.notNull('currentPlayer');
      }
    }
  }

  bool get isSinglePlayer {
    return otherPlayer.isEmpty && finishedPlayer.isEmpty;
  }

  bool get isMultiPlayer {
    return !isSinglePlayer;
  }

  Player? get winner {
    if (finishedPlayer.isEmpty) return null;
    return finishedPlayer.first;
  }

  void setCurrentPlayer(Player player) {
    currentPlayer = player;
  }

  void pushPlayerBack(Player player) {
    otherPlayer.add(player);
  }

  void pushPlayerFront(Player player) {
    otherPlayer.insert(0, player);
  }

  Player? popPlayerFront() {
    if (otherPlayer.isEmpty) return null;
    return otherPlayer.removeAt(0);
  }

  Player? popPlayerBack() {
    if (otherPlayer.isEmpty) return null;
    return otherPlayer.removeAt(otherPlayer.length - 1);
  }
}
