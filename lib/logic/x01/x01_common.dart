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
  final GameSettings settings;
  late PlayerTurn current;

  GameRound(this.settings) {
    current = PlayerTurn.from(settings);
  }

  void setupTurn(PlayerTurn round) {
    current = round;
  }

  void setupTurnFor(Player player) {
    current = PlayerTurn(settings, player.score);
  }
}

/// Contains player data.
class PlayerData {
  final List<String> players;
  final int goal;

  final List<Player> otherPlayer = [];
  final List<Player> finishedPlayer = [];

  Player currentPlayer = Player('ERROR', -1);

  PlayerData(this.players, this.goal) {
    reset();
  }

  void reset() {
    otherPlayer.clear();
    finishedPlayer.clear();

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
