import 'package:flutter_test/flutter_test.dart' as testing;

import 'package:dart_dart/logic/constant/fields.dart';

void main() {
  testing.group('Test HitNumbers', () {
    testing.test('Test HitNumber.bySegment', () {
      var values = [1, 18, 4, 13, 6, 10, 15, 2, 17, 3, 19, 7, 16, 8, 11, 14, 9, 12, 5, 20];

      for(int i = 0; i < values.length; i++ ) {
        var isValue = HitNumber.bySegment(i).value;
        var expected = values[i];
        testing.expect(isValue, expected);
      }

      var bullseye = 25;
      testing.expect(HitNumber.bySegment(20).value, bullseye);

      testing.expect(HitNumber.bySegment(-1).value, 0);
      testing.expect(HitNumber.bySegment(21).value, 0);
    });

    testing.test('Test Hit multiplier', () {
      var twenty = const Hit(HitNumber.twenty, HitMultiplier.single);
      var doubleTwenty = const Hit(HitNumber.twenty, HitMultiplier.double);
      var tripleTwenty = const Hit(HitNumber.twenty, HitMultiplier.triple);

      testing.expect(twenty.value, 20);
      testing.expect(doubleTwenty.value, 40);
      testing.expect(tripleTwenty.value, 60);
    });

    testing.test('Test Throws', () {
      var throws = Throws();

      testing.expect(throws.done(), false);
      testing.expect(throws.count, 0);
      testing.expect(throws.sum(), 0);

      var hit = const Hit(HitNumber.twenty, HitMultiplier.triple);
      throws.thrown(hit);

      testing.expect(throws.done(), false);
      testing.expect(throws.count, 1);
      testing.expect(throws.sum(), hit.value);
    });
  });
}