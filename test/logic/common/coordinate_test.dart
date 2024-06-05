import 'package:dart_dart/logic/common/coordinate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test Commands', () {
    double x = 10;
    double y = 20;

    var cords = Coordinate(x, y);

    expect(cords.toString(), 'x($x)\ny($y)');
  });
}
