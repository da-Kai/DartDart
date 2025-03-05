import 'package:dart_dart/logic/common/commands.dart';
import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/common.dart';
import 'package:dart_dart/logic/x01/game.dart';
import 'package:dart_dart/logic/x01/player.dart';

/// Single Throw by a player.
class Throw extends Command {
  final TurnBuilder round;
  final Hit hit;
  final int pos;

  Throw(this.round, this.hit, this.pos);

  @override
  void execute() {
    round.thrown(hit, pos: pos);
  }

  @override
  void undo() {
    round.undo(pos);
  }
}

/// End round and prepare next player.
///
/// Should only follow an [Throw] command.
class Switch extends Command {
  final Player nextPly;
  final Player curPly;
  final X01Turn turn;

  final PlayerData data;
  final X01GameData gameData;
  final TurnBuilder turnBuilder;

  Switch._(this.data, this.gameData, this.turnBuilder, this.turn, this.curPly, this.nextPly);

  static Switch from(PlayerData data, X01GameData gameData, TurnBuilder turnBuilder, {Player? ply, Player? next}) {
    var curPly = ply ?? data.current;
    var nexPly = next ?? data.next;
    return Switch._(data, gameData, turnBuilder, turnBuilder.build(), curPly, nexPly);
  }

  @override
  void execute() {
    /// Apply Score if Valid.
    gameData.pushTurn(curPly.name, turn);
    data.rotateForward();

    var nextPlyLastTurn = gameData.lastPlayerTurn(nextPly.name);
    turnBuilder.setupTurnFor(nextPlyLastTurn);
  }

  @override
  void undo() {
    /// Reset Score.
    data.rotateBackwards();
    gameData.popTurn(curPly.name);

    turnBuilder.resetTo(turn);
  }
}

/// Set the last Player as a winner, and move to winners List.
///
/// Should be executed after a [Switch] command.
class EndLeg extends Command {
  final Player winner;
  final X01Turn turn;

  final PlayerData data;
  final X01GameData gameData;
  final TurnBuilder turnBuilder;

  EndLeg._(this.data, this.gameData, this.turnBuilder, this.turn, this.winner);

  static EndLeg from(PlayerData data, X01GameData gameData, TurnBuilder turnBuilder, {Player? ply}) {
    var winner = ply ?? data.current;
    return EndLeg._(data, gameData, turnBuilder, turnBuilder.build(), winner);
  }

  @override
  void execute() {
    gameData.pushTurn(winner.name, turn);
    data.rotateForward();
    gameData.setLegWinner(winner);
    gameData.pushLeg();

    turnBuilder.reset();
  }

  @override
  void undo() {
    gameData.popLeg();
    gameData.setLegWinner(null);
    data.rotateBackwards();
    gameData.popTurn(winner.name);

    turnBuilder.resetTo(turn);
  }
}

class EndSet extends Command {
  final Player winner;
  final X01Turn turn;

  final PlayerData data;
  final X01GameData gameData;
  final TurnBuilder turnBuilder;

  EndSet._(this.data, this.gameData, this.turnBuilder, this.turn, this.winner);

  static EndSet from(PlayerData data, X01GameData gameData, TurnBuilder turnBuilder, {Player? ply}) {
    var winner = ply ?? data.current;
    return EndSet._(data, gameData, turnBuilder, turnBuilder.build(), winner);
  }

  @override
  void execute() {
    gameData.pushTurn(winner.name, turn);
    data.rotateForward();
    gameData.setLegWinner(winner);
    gameData.setSetWinner(winner);
    gameData.pushSet();

    turnBuilder.reset();
  }

  @override
  void undo() {
    gameData.popSet();
    gameData.setSetWinner(null);
    gameData.setSetWinner(null);
    data.rotateBackwards();
    gameData.popTurn(winner.name);

    turnBuilder.resetTo(turn);
  }
}
