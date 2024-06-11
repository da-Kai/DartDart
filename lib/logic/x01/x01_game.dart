import 'package:dart_dart/logic/common/commands.dart';
import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/x01_commands.dart';
import 'package:dart_dart/logic/x01/x01_common.dart';
import 'package:dart_dart/logic/x01/x01_settings.dart';

enum InputType { board, field }

/// Represents a single Game
class GameController {
  final GameSettings settings;
  late final PlayerData playerData;

  late GameRound gameRound;
  final CommandStack commands = CommandStack();

  GameController(List<String> playerNames, this.settings) {
    playerData = PlayerData(playerNames, settings.points);
    reset();
  }

  PlayerTurn get curTurn => gameRound.current;

  bool get isMultiPlayer => playerData.isMultiPlayer;

  Player get curPly => playerData.currentPlayer;

  Player get winner => playerData.winner!;

  bool get hasEnded => playerData.done;

  void setCurrentPlayer(Player player, {PlayerTurn? turn}) {
    playerData.currentPlayer = player;
    gameRound.current = turn ?? PlayerTurn(settings, player.score);
  }

  bool get hasGameFinished => playerData.done;

  void reset() {
    playerData.reset();
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
