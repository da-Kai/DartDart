import 'package:dart_dart/logic/constant/fields.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test HitNumbers', () {
    test('Test HitNumber.bySegment', () {
      var values = [1, 18, 4, 13, 6, 10, 15, 2, 17, 3, 19, 7, 16, 8, 11, 14, 9, 12, 5, 20];

      for(int i = 0; i < values.length; i++ ) {
        var isValue = HitNumber.bySegment(i).value;
        var expected = values[i];
        expect(isValue, expected);
      }

      var bullseye = 25;
      expect(HitNumber.bySegment(20).value, bullseye);

      expect(HitNumber.bySegment(-1).value, 0);
      expect(HitNumber.bySegment(21).value, 0);

      expect(HitNumber.bySegment(null), HitNumber.unthrown);
    });

    test('Test Hit multiplier', () {
      var twenty = Hit.get(HitNumber.twenty, HitMultiplier.single);
      var doubleTwenty = Hit.get(HitNumber.twenty, HitMultiplier.double);
      var tripleTwenty = Hit.get(HitNumber.twenty, HitMultiplier.triple);

      expect(twenty.value, 20);
      expect(doubleTwenty.value, 40);
      expect(tripleTwenty.value, 60);
    });

    test('Test Throws', () {
      var turn = Turn();

      expect(turn.done(), false);
      expect(turn.count, 0);
      expect(turn.sum(), 0);

      var firstHit = Hit.get(HitNumber.twenty, HitMultiplier.triple);
      turn.thrown(firstHit);

      expect(turn.done(), false);
      expect(turn.count, 1);
      expect(turn.sum(), firstHit.value);

      var secondHit = Hit.get(HitNumber.one, HitMultiplier.double);
      turn.thrown(secondHit);

      expect(turn.done(), false);
      expect(turn.count, 2);
      expect(turn.sum(), firstHit + secondHit);

      var thirdHit = Hit.get(HitNumber.five, HitMultiplier.single);
      turn.thrown(thirdHit);

      expect(turn.done(), true);
      expect(turn.count, 3);
      expect(turn.sum(), firstHit + (secondHit + thirdHit));

      turn.undo();

      expect(turn.done(), false);
      expect(turn.count, 2);
      expect(turn.sum(), firstHit + secondHit);
    });
  });
}