import 'package:dart_dart/logic/common/commands.dart';
import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/x01_common.dart';

/// Single Throw by a player.
class Throw implements Command {
  @override
  Command? next;
  @override
  Command? previous;

  final PlayerTurn round;
  final Hit hit;
  final int pos;

  Throw(this.round, this.hit, this.pos);

  @override
  void execute() {
    round.thrown(hit, pos: pos);
  }

  @override
  void undo() {
    round.undo(pos: pos);
  }
}

/// End round and switch player.
///
/// Should only follow an [Throw] command.
class Switch implements Command {
  @override
  Command? next;
  @override
  Command? previous;

  final Player nextPly;
  final Player curPly;
  final PlayerTurn round;

  final PlayerData data;
  final GameRound game;

  Switch(this.data, this.game, this.round, this.curPly, this.nextPly);

  static Switch from(PlayerData data, GameRound round) {
    return Switch(data, round, round.current, data.currentPlayer, data.next);
  }

  @override
  void execute() {
    /// Apply Score if Valid.
    data.currentPlayer.turnHistory.add(round);
    data.pushPlayerBack(curPly);
    data.remove(nextPly);
    data.setCurrentPlayer(nextPly);
    game.setupTurnFor(nextPly);
  }

  @override
  void undo() {
    /// Reset Score.
    data.remove(curPly);
    data.pushPlayerFront(nextPly);

    curPly.turnHistory.remove(round);
    game.setupTurn(round);

    data.setCurrentPlayer(curPly);
  }
}

/// Set the last Player as a winner, and move to winners List.
///
/// Should be executed after a [Switch] command.
class Award implements Command {
  @override
  Command? next;
  @override
  Command? previous;

  PlayerData data;

  Award(this.data);

  @override
  void execute() {
    var ply = data.popPlayerBack()!;
    data.addWinner(ply);
  }

  @override
  void undo() {
    var win = data.popWinner()!;
    data.pushPlayerBack(win);
  }
}
