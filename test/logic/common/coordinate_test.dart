import 'package:dart_dart/logic/common/coordinate.dart';
import 'package:flutter_test/flutter_test.dart';

void expectNot(dynamic actual, dynamic matcher) {
  expect(actual != matcher, true);
}

void main() {
  test('Test Commands', () {
    var cord1 = const Coordinate(10, 20);
    var cord2 = const Coordinate(10, 20);
    var cord3 = const Coordinate(-10, -20);

    expect(cord1.toString(), 'x(10.0)\ny(20.0)');

    expect(cord1, cord2);
    expectNot(cord2, cord3);
    expect(cord1.hashCode, cord2.hashCode);
    expectNot(cord1.hashCode, cord3.hashCode);
  });
}
