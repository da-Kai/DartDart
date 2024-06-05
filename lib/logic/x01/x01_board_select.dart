import 'dart:math';
import 'dart:ui';

import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/common/coordinate.dart';

class GameMath {
  GameMath._();

  static double _getDistance(Coordinate coo) {
    return sqrt(pow(coo.x.abs(), 2) + pow(coo.y.abs(), 2));
  }

  static double _getAngle(double dist, Coordinate coo) {
    var radiant = acos(coo.y / dist);
    var degree = radiant * (180 / pi);
    return coo.x > 0 ? 360 - degree : degree;
  }

  /// Returns Coordinates normalized to 100:-100 with the
  /// center as 0:0 coordinates.
  static Coordinate norm(Size size, Offset offset) {
    var nx = (offset.dx / (size.width / 2)) - 1;
    var ny = (offset.dy / (size.height / 2)) - 1;
    return Coordinate(nx * 100.0, ny * 100.0);
  }

  static (double, double) vectorData(Coordinate coo) {
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
