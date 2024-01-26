import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/x01_settings.dart';

enum InputType { board, field }

class Player {
  final String name;
  int score;

  Player(this.name, this.score);

  bool get done {
    return score == 0;
  }
}

class Round {
  final Player player;
  final Throws throws;
  late final int startPoints;

  Round(this.player, this.throws) {
    startPoints = player.score;
  }

  int get subtractedScore {
    return startPoints - sum;
  }

  int get sum {
    return throws.sum();
  }
}

class ActiveRound {
  final GameSettings settings;
  late final Round round;

  ActiveRound(this.settings, Player player, {Round? roundData}) {
    if (roundData == null) {
      round = Round(player, Throws());
    } else {
      round = roundData;
    }
  }

  Player get player {
    return round.player;
  }

  Throws get throws {
    return round.throws;
  }

  int get startPoints {
    return round.startPoints;
  }

  bool get isLegal {
    if (throws.count == 0) {
      return true;
    }
    if (startPoints == settings.points) {
      return settings.gameIn.fits(throws.first);
    }
    if (round.subtractedScore == 0) {
      return settings.gameOut.fits(throws.last);
    }
    return round.subtractedScore > 0 && settings.gameOut.possible(round.subtractedScore);
  }

  int get updatedScore {
    //In
    if (player.score == settings.points) {
      if (!settings.gameIn.fits(throws.first)) {
        return player.score;
      }
    }
    //Out
    if (round.subtractedScore < 0) return player.score;
    if (round.subtractedScore == 0) {
      if (settings.gameOut.fits(throws.last)) {
        player.score = 0;
        return player.score;
      }
    }
    if (!settings.gameOut.possible(round.subtractedScore)) return player.score;
    return round.subtractedScore;
  }

  bool get hasEnded {
    return throws.done() || !isLegal || updatedScore == 0;
  }

  String get text {
    return '$updatedScore';
  }

  bool get playerFinished {
    return updatedScore == 0;
  }

  Round apply() {
    player.score = updatedScore;
    return round;
  }
}

class GameData {
  final GameSettings settings;

  late ActiveRound currentRound;

  List<Player> otherPlayer = [];
  List<Player> finishedPlayer = [];

  List<Round> history = [];

  GameData(this.settings) {
    var currentPlayer = Player('ERROR', -1);
    if (settings.players.isNotEmpty) {
      otherPlayer = settings.players.map((ply) => Player(ply, settings.game.val)).toList();
      currentPlayer = otherPlayer.removeAt(0);
    }
    currentRound = ActiveRound(settings, currentPlayer);
  }

  bool get isSinglePlayer {
    return otherPlayer.isEmpty && finishedPlayer.isEmpty;
  }

  bool get isMultiPlayer {
    return !isSinglePlayer;
  }

  bool hasGameFinished() {
    if (isSinglePlayer) {
      return currentRound.playerFinished;
    } else {
      return otherPlayer.isEmpty;
    }
  }

  Player? get winner {
    if (finishedPlayer.isEmpty) return null;
    return finishedPlayer.first;
  }

  void reset() {
    finishedPlayer = [];
    otherPlayer = settings.players.map((ply) => Player(ply, settings.game.val)).toList();
    currentRound = ActiveRound(settings, otherPlayer.removeAt(0));
  }

  void next() {
    history.add(currentRound.apply());

    var next = currentRound.player;
    if (otherPlayer.isNotEmpty) {
      next = otherPlayer.removeAt(0);

      if (currentRound.playerFinished) {
        finishedPlayer.add(currentRound.player);
      } else {
        otherPlayer.add(currentRound.player);
      }
    }

    currentRound = ActiveRound(settings, next);
  }

  void undo() {
    if (!currentRound.throws.undo()) {
      Round undoData = history.removeLast();
      Player last = currentRound.player;
      if (isMultiPlayer) {
        var current = currentRound.player;
        last = otherPlayer.removeLast();
        otherPlayer.insert(0, current);
      }
      currentRound = ActiveRound(settings, last, roundData: undoData);
    }
  }

  bool get canUndo {
    return currentRound.throws.count > 0 || history.isNotEmpty;
  }
}
