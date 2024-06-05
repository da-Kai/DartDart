import 'package:dart_dart/logic/common/commands.dart';
import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/x01_commands.dart';
import 'package:dart_dart/logic/x01/x01_common.dart';
import 'package:dart_dart/logic/x01/x01_settings.dart';

enum InputType { board, field }

/// Represents a single Game
class GameController {
  final GameSettings settings;
  late PlayerData playerData;
  late GameRound gameRound;

  final CommandStack commands = CommandStack();

  GameController(this.settings) {
    reset();
  }

  PlayerTurn get curTurn => gameRound.current;

  bool get isMultiPlayer => playerData.isMultiPlayer;

  Player get curPly => playerData.currentPlayer;

  Player get winner => playerData.finishedPlayer.first;

  bool get hasEnded => playerData.otherPlayer.isEmpty;

  void setCurrentPlayer(Player player, {PlayerTurn? turn}) {
    playerData.currentPlayer = player;
    gameRound.current = turn ?? PlayerTurn(settings, player.score);
  }

  bool isLegal() {
    if (curTurn.count == 0) {
      return true;
    }
    if (curPly.score == settings.points) {
      return settings.isValid(curPly.score, curTurn.first);
    } else if (curPly.score == curTurn.sum()) {
      return settings.isValid(curPly.score, curTurn.last!);
    } else if (curTurn.sum() < curPly.score) {
      return true;
    }

    return false;
  }

  bool hasGameFinished() {
    if (playerData.isSinglePlayer) {
      return playerData.currentPlayer.score == 0;
    } else {
      return playerData.otherPlayer.isEmpty;
    }
  }

  void reset() {
    playerData = PlayerData(settings.players, settings.points);
    gameRound = GameRound(settings);
    commands.clear();
  }

  void onThrow(Hit hit) {
    var action = Throw(gameRound.current, hit, curTurn.count);
    commands.execute(action);
  }

  void next() {
    bool isWin = curTurn.isWin;

    commands.execute(Switch.from(playerData, gameRound));

    if (isWin) {
      commands.execute(Award(playerData));
    }
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
}
