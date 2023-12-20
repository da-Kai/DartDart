import 'dart:math';
import 'dart:ui';

import 'package:dart_dart/constants/fields.dart';
import 'package:dart_dart/game/x01/settings.dart';

class Player {
  String name;
  int points;

  Player(this.name, this.points);

  bool get done {
    return points == 0;
  }
}

class GameData {
  GameSettings settings;
  late Player currentPlayer;

  List<Player> otherPlayer = [];
  List<Player> finishedPlayer = [];

  Throws curThrows = Throws();

  GameData(this.settings) {
    otherPlayer = settings.players.map((ply) => Player(ply, settings.game.val)).toList();
    currentPlayer = otherPlayer.removeAt(0);
  }

  void reset() {
    finishedPlayer=[];
    otherPlayer = settings.players.map((ply) => Player(ply, settings.game.val)).toList();
    currentPlayer = otherPlayer.removeAt(0);
    curThrows = Throws();
  }

  void next() {
    curThrows = Throws();

    if (otherPlayer.isNotEmpty) {
      var next = otherPlayer.removeAt(0);

      if (currentPlayer.done) {
        finishedPlayer.add(currentPlayer);
      } else {
        otherPlayer.add(currentPlayer);
      }

      currentPlayer = next;
    }
  }

  bool get isSinglePlayer {
    return otherPlayer.isEmpty && finishedPlayer.isEmpty;
  }

  bool get isMultiPlayer {
    return !isSinglePlayer;
  }

  int get updatedPoints {
    return currentPlayer.points - curThrows.sum();
  }

  bool get stillLegal {
    if (curThrows.count == 0) {
      return true;
    }
    if (currentPlayer.points == settings.points) {
      return settings.gameIn.fits(curThrows.first);
    }
    if (updatedPoints == 0) {
      return settings.gameOut.fits(curThrows.last);
    }
    return updatedPoints > 0 && settings.gameOut.possible(updatedPoints);
  }

  void curPlyApply(Throws throws) {
    //In
    if (currentPlayer.points == settings.points) {
      if (!settings.gameIn.fits(throws.first)) {
        return;
      }
    }

    //Out
    if (updatedPoints < 0) return;
    if (updatedPoints == 0) {
      if (settings.gameOut.fits(throws.last)) {
        currentPlayer.points = 0;
        return;
      }
    }

    if (!settings.gameOut.possible(updatedPoints)) return;

    currentPlayer.points = updatedPoints;
  }

  bool turnDone() {
    return curThrows.done() || !stillLegal || updatedPoints == 0;
  }

  bool gameFinished() {
    if (isSinglePlayer) {
      return currentPlayer.done;
    } else {
      return otherPlayer.isEmpty;
    }
  }

  String currentPlayerUpdateText() {
    if (!stillLegal) {
      return '${currentPlayer.points}';
    } else {
      var sum = currentPlayer.points - curThrows.sum();
      return '$sum';
    }
  }
}

class Coordinates {
  double x;
  double y;

  Coordinates(this.x, this.y);

  @override
  String toString() {
    return 'x($x)\ny($y)';
  }
}

class GameMath {
  GameMath._();

  static double _getDistance(Coordinates coo) {
    return sqrt(pow(coo.x.abs(), 2) + pow(coo.y.abs(), 2));
  }

  static double _getAngle(double dist, Coordinates coo) {
    var radiant = acos(coo.y / dist);
    var degree = radiant * (180 / pi);
    return coo.x > 0 ? 360 - degree : degree;
  }

  /// Returns Coordinates normalized to 100:-100 with the
  /// center as 0:0 coordinates.
  static Coordinates norm(Size size, Offset offset) {
    var nx = (offset.dx / (size.width / 2)) - 1;
    var ny = (offset.dy / (size.height / 2)) - 1;
    return Coordinates(nx * 100.0, ny * 100.0);
  }

  static (double, double) vectorData(Coordinates coo) {
    var distance = _getDistance(coo);
    var angle = _getAngle(distance, coo);
    return (distance, angle);
  }
}

class FieldCalc {
  FieldCalc._();

  static Hit getField({required double angle, required double distance}) {
    //Miss
    if (distance >= 89.0) {
      return Hit.miss;
    }

    //BullsEye
    if (distance <= 7.1) {
      return const Hit(HitNumber.bullsEye, HitMultiplier.double);
    }
    if (distance <= 16.0) {
      return const Hit(HitNumber.bullsEye, HitMultiplier.single);
    }

    HitMultiplier multiplier = HitMultiplier.single;
    if (distance > 27.0 && distance < 46.0) {
      multiplier = HitMultiplier.triple;
    } else if (distance > 69.0 && distance < 89.0) {
      multiplier = HitMultiplier.double;
    }

    // normalize to 1(at angle 189)
    angle = (angle >= 189) ? (angle - 189) : ((360 - 189) + angle);

    int section = (angle / 18.0).floor();
    HitNumber value = HitNumber.bySegment(section);
    return Hit(value, multiplier);
  }
}