import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/checkout.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test Checkout Values', () {
    var checkouts = [doubleCheckoutSingle, doubleCheckoutTwo, doubleCheckoutThree, masterCheckoutThree];

    for(var checkout in checkouts) {
      for(var entry in checkout.entries) {
        var score = entry.key;
        var values = entry.value.split(';');

        for(var val in values) {
          score -= Hit.getByAbbreviation(val).value;
        }

        expect(score, 0, reason: '${entry.key} != ${entry.value}');
      }
    }
  });
  test('Test Double Checkouts Fit', () {
    for(var entry in doubleCheckoutThree.entries) {
      var score = entry.key;
      var three = entry.value.split(';');
      
      var firstHit = Hit.getByAbbreviation(three[0]);
      score -= firstHit.value;

      var twoEntry = doubleCheckoutTwo[score];

      expect(twoEntry != null, true, reason: 'no $score value for doubleOut');
      var two = twoEntry!.split(';');
      expect(three[1], two[0], reason: '${entry.key}: ${entry.value} != $twoEntry');
      expect(three[2], two[1], reason: '${entry.key}: ${entry.value} != $twoEntry');

      var secondHit = Hit.getByAbbreviation(two[0]);
      score -= secondHit.value;

      var oneEntry = doubleCheckoutSingle[score];
      expect(oneEntry != null, true, reason: 'no $score value for singleOut');
      var one = oneEntry!.split(';');
      expect(one[0], two[1], reason: '${entry.key}: ${entry.value} != $twoEntry != $one');

      var thirdHit = Hit.getByAbbreviation(one[0]);
      score -= thirdHit.value;

      expect(score, 0);
    }
  });
  test('Test Master Checkouts Fit', () {
    for(var entry in masterCheckoutThree.entries) {
      var score = entry.key;
      var three = entry.value.split(';');

      var firstHit = Hit.getByAbbreviation(three[0]);
      score -= firstHit.value;

      var twoEntry = doubleCheckoutTwo[score] ??  masterCheckoutTwo[score];
      expect(twoEntry != null, true, reason: 'no $score value for doubleOut');
      var two = twoEntry!.split(';');
      expect(three[1], two[0], reason: '${entry.key}: ${entry.value} != $twoEntry');
      expect(three[2], two[1], reason: '${entry.key}: ${entry.value} != $twoEntry');

      var secondHit = Hit.getByAbbreviation(two[0]);
      score -= secondHit.value;

      var oneEntry = doubleCheckoutSingle[score] ?? masterCheckoutOne[score];
      expect(oneEntry != null, true, reason: 'no $score value for singleOut');
      var one = oneEntry!.split(';');
      expect(one[0], two[1], reason: '${entry.key}: ${entry.value} != $twoEntry != $one');

      var thirdHit = Hit.getByAbbreviation(one[0]);
      score -= thirdHit.value;

      expect(score, 0);
    }
  });
}