import 'dart:math';
import 'dart:ui';

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