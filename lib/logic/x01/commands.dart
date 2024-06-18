import 'package:dart_dart/logic/common/commands.dart';
import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/common.dart';

/// Single Throw by a player.
class Throw implements Command {
  @override
  Command? next;
  @override
  Command? previous;

  final GameRound round;
  final Hit hit;
  final int pos;

  Throw(this.round, this.hit, this.pos);

  @override
  void execute() {
    round.current.thrown(hit, pos: pos);
  }

  @override
  void undo() {
    round.current.undo(pos: pos);
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
    var next = data.isMultiPlayer ? data.next : data.currentPlayer;
    return Switch(data, round, round.current, data.currentPlayer, next);
  }

  @override
  void execute() {
    /// Apply Score if Valid.
    data.currentPlayer.turnHistory.add(round);
    data.rotateForward();
    game.setupTurnFor(nextPly);
  }

  @override
  void undo() {
    /// Reset Score.
    curPly.turnHistory.remove(round);
    data.rotateBackwards();
    game.setupTurn(round);
  }
}

/// Set the last Player as a winner, and move to winners List.
///
/// Should be executed after a [Switch] command.
class EndLeg implements Command {
  @override
  Command? next;
  @override
  Command? previous;

  final PlayerData player;
  final LegAndSetData data;
  late final Player legWinner;

  late Map<String, int> _leg;
  late List<String> _player;

  EndLeg(this.data, this.player) {
    legWinner = player.currentPlayer;
  }

  @override
  void execute() {
    data.addLeg(legWinner.name);
    _leg = data.resetLegs();
    _player = player.reset();
  }

  @override
  void undo() {
    data.removeLeg(legWinner.name);
    data.setLegs(_leg);
    player.organize(_player);
  }
}

class EndSet implements Command {
  @override
  Command? next;
  @override
  Command? previous;

  EndSet();

  @override
  void execute() {

  }

  @override
  void undo() {

  }
}