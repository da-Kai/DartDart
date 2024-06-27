import 'package:dart_dart/logic/common/commands.dart';
import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/common.dart';
import 'package:dart_dart/logic/x01/player.dart';

/// Single Throw by a player.
class Throw extends Command {
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

/// End round and prepare next player.
///
/// Should only follow an [Throw] command.
class Switch extends Command {
  final Player nextPly;
  final Player curPly;
  final PlayerTurn round;
  final int leg;

  final PlayerData data;
  final GameRound game;

  Switch._(this.data, this.game, this.round, this.curPly, this.nextPly, this.leg);

  static Switch from(PlayerData data, GameRound round, {Player? ply, Player? next}) {
    var curPly = ply ?? data.current;
    var nexPly = next ?? data.next;
    return Switch._(data, round, round.current, curPly, nexPly, round.currentLeg);
  }

  @override
  void execute() {
    /// Apply Score if Valid.
    data.current.pushTurn(leg, round);
    data.rotateForward();
    game.setupTurnFor(nextPly);
  }

  @override
  void undo() {
    /// Reset Score.
    curPly.popTurn(leg);
    data.rotateBackwards();
    game.setupTurn(round);
  }
}

/// Set the last Player as a winner, and move to winners List.
///
/// Should be executed after a [Switch] command.
class EndLeg extends Command {
  final Player winner;
  final PlayerTurn round;
  final int leg;

  final PlayerData data;
  final GameRound game;

  late List<String> _player;

  EndLeg._(this.data, this.game, this.round, this.winner, this.leg);

  static EndLeg from(PlayerData data, GameRound round, {Player? ply}) {
    var winner = ply ?? data.current;
    return EndLeg._(data, round, round.current, winner, round.currentLeg);
  }

  int order(Player a, Player b) {
    return a.handicap.compareTo(b.handicap);
  }

  @override
  void execute() {
    data.current.pushTurn(leg, round);
    data.forEach((ply) {
      ply.points.pushLeg(ply == winner);
    });
    _player = data.reorder(order);
    game.currentLeg++;

    game.setupTurnFor(data.current);
  }

  @override
  void undo() {
    game.currentLeg--;
    data.organize(_player, winner.name);
    data.forEach((ply) {
      ply.points.undo();
    });
    winner.popTurn(leg);

    game.setupTurn(round);
  }
}

class EndSet extends Command {
  final Player winner;
  final PlayerTurn round;
  final int leg;

  final PlayerData data;
  final GameRound game;

  late List<String> _player;

  EndSet._(this.data, this.game, this.round, this.winner, this.leg);

  static EndSet from(PlayerData data, GameRound round, {Player? ply, Player? next}) {
    var winner = ply ?? data.current;
    return EndSet._(data, round, round.current, winner, round.currentLeg);
  }

  int order(Player a, Player b) {
    return a.handicap.compareTo(b.handicap);
  }

  @override
  void execute() {
    data.current.pushTurn(leg, round);
    data.forEach((ply) {
      ply.points.pushLeg(ply == winner);
      ply.points.pushSet(ply == winner);
    });
    _player = data.reorder(order);
    game.currentLeg++;

    game.setupTurnFor(data.current);
  }

  @override
  void undo() {
    game.currentLeg--;
    data.organize(_player, winner.name);
    data.forEach((ply) {
      ply.points.undo();
      ply.points.undo();
    });
    winner.popTurn(leg);

    game.setupTurn(round);
  }
}
