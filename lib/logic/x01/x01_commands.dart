import 'package:dart_dart/logic/common/common.dart';
import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/x01_common.dart';

/// Single Throw by a player.
class Throw implements Command {
  @override
  Command? next;
  @override
  Command? previous;

  final PlayerRound round;
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
  final PlayerRound round;

  final PlayerData data;
  final GameRound game;

  Switch(this.data, this.game, this.round, this.curPly, this.nextPly);

  static Switch from(PlayerData data, GameRound round) {
    return Switch(data, round, round.current, data.currentPlayer, data.otherPlayer.first);
  }

  @override
  void execute() {
    /// Apply Score if Valid.
    data.currentPlayer.rounds.add(round);
    data.pushPlayerBack(curPly);
    data.otherPlayer.remove(nextPly);
    data.setCurrentPlayer(nextPly);
    game.setRoundFor(nextPly);
  }

  @override
  void undo() {
    /// Reset Score.
    data.otherPlayer.remove(curPly);
    data.pushPlayerFront(nextPly);

    curPly.rounds.remove(round);
    game.setRound(round);

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
    var ply = data.otherPlayer.removeLast();
    data.finishedPlayer.add(ply);
  }

  @override
  void undo() {
    var win = data.finishedPlayer.removeLast();
    data.otherPlayer.add(win);
  }
}