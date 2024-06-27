import 'package:dart_dart/logic/common/commands.dart';
import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/checkout.dart';
import 'package:dart_dart/logic/x01/commands.dart';
import 'package:dart_dart/logic/x01/common.dart';
import 'package:dart_dart/logic/x01/player.dart';
import 'package:dart_dart/logic/x01/settings.dart';

enum InputType { board, field }

/// Represents a single Game
class GameController {
  final GameSettings settings;
  late final PlayerData playerData;

  late final GameRound gameRound;
  final CommandStack commands = CommandStack();

  GameController(List<String> playerNames, this.settings) {
    Player plyFunc(name) => Player(name, settings.points, () => gameRound.currentLeg);
    gameRound = GameRound(settings);
    playerData = PlayerData.get(playerNames, plyFunc);
    reset();
  }

  Checkout get checkout {
    if (curTurn.valid) {
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

  Player get curPly => playerData.current;

  Player? get leader {
    Player? leader;
    playerData.forEach((ply) {
      if (leader == null) {
        leader = ply;
      } else {
        if (leader!.points < ply.points) {
          leader = ply;
        }
      }
    });
    return leader;
  }

  Player? get winner {
    var lead = leader;
    return (lead != null && lead.points.sets == settings.sets) ? lead : null;
  }

  bool get hasGameEnded => winner != null;

  void reset() {
    playerData.reset();
    gameRound.reset();
    commands.clear();
  }

  void onThrow(Hit hit) {
    if(curTurn.done) return;
    var action = Throw(gameRound, hit, curTurn.count);
    commands.execute(action);
  }

  void next() {
    final checkout = curTurn.isCheckout;

    late Command cmd;
    if (checkout) {
      cmd = EndLeg.from(playerData, gameRound);
    } else {
      cmd = Switch.from(playerData, gameRound);
    }
    commands.execute(cmd);
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
