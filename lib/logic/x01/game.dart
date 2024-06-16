import 'package:dart_dart/logic/common/commands.dart';
import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/checkout.dart';
import 'package:dart_dart/logic/x01/commands.dart';
import 'package:dart_dart/logic/x01/common.dart';
import 'package:dart_dart/logic/x01/settings.dart';

enum InputType { board, field }

/// Represents a single Game
class GameController {
  final GameSettings settings;
  late final PlayerData playerData;

  late GameRound gameRound;
  final CommandStack commands = CommandStack();

  GameController(List<String> playerNames, this.settings) {
    playerData = PlayerData.get(playerNames, settings.points);
    reset();
  }

  Checkout get checkout {
    if(curTurn.valid) {
      final out = settings.gameOut;
      final score = gameRound.current.score;
      final remain = gameRound.current.remain;
      return calcCheckout(out, score, dartsRemain: remain);
    } else {
      return Checkout();
    }
  }

  PlayerTurn get curTurn => gameRound.current;

  bool get isMultiPlayer => playerData.isMultiPlayer;

  Player get curPly => playerData.currentPlayer;

  Player get winner => playerData.winner!;

  bool get hasGameEnded => playerData.playerCount == 0;

  void setCurrentPlayer(Player player, {PlayerTurn? turn}) {
    playerData.setCurrentPlayer(player);
    gameRound.current = turn ?? PlayerTurn(settings, player.score);
  }

  void reset() {
    playerData.reset();
    gameRound = GameRound(settings);
    commands.clear();
  }

  void onThrow(Hit hit) {
    var action = Throw(gameRound, hit, curTurn.count);
    commands.execute(action);
  }

  void next() {
    bool isWin = curTurn.isCheckout;

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
