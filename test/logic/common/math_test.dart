import 'package:dart_dart/logic/common/math.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test Math', () {
    test('Test NumCheck', () {
      int a = 1;
      double b = -4;
      num c = 0;

      expect(numCheck(a), NumCheck.positive);
      expect(numCheck(b), NumCheck.negative);
      expect(numCheck(c), NumCheck.zero);
    });
    test('Test NumCheck', () {
      int a = 1;
      double b = -4;
      num c = 1;

      expect(numCompare(a, b), NumCompare.greater);
      expect(numCompare(b, c), NumCompare.lower);
      expect(numCompare(a, c), NumCompare.equal);
    });
  });
}