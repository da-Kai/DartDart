import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/checkout.dart';
import 'package:dart_dart/logic/x01/settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test Checkout Values', () {
    var checkouts = [doubleCheckoutSingle, doubleCheckoutDouble, doubleCheckoutTriple, masterCheckoutTriple];

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

    expect(InOut.straight.highestCheckout(), 180);
    expect(InOut.master.highestCheckout(), 180);
    expect(InOut.double.highestCheckout(), 170);

    expect(InOut.straight.lowestCheckout(), 1);
    expect(InOut.master.lowestCheckout(), 2);
    expect(InOut.double.lowestCheckout(), 2);
  });
  test('Test Double Checkouts Fit', () {
    for(var entry in doubleCheckoutTriple.entries) {
      var score = entry.key;
      var three = entry.value.split(';');
      
      var firstHit = Hit.getByAbbreviation(three[0]);
      score -= firstHit.value;

      var twoEntry = doubleCheckoutDouble[score];

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
    for(var entry in masterCheckoutTriple.entries) {
      var score = entry.key;
      var three = entry.value.split(';');

      var firstHit = Hit.getByAbbreviation(three[0]);
      score -= firstHit.value;

      var twoEntry = doubleCheckoutDouble[score] ??  masterCheckoutDouble[score];
      expect(twoEntry != null, true, reason: 'no $score value for doubleOut');
      var two = twoEntry!.split(';');
      expect(three[1], two[0], reason: '${entry.key}: ${entry.value} != $twoEntry');
      expect(three[2], two[1], reason: '${entry.key}: ${entry.value} != $twoEntry');

      var secondHit = Hit.getByAbbreviation(two[0]);
      score -= secondHit.value;

      var oneEntry = doubleCheckoutSingle[score] ?? masterCheckoutSingle[score];
      expect(oneEntry != null, true, reason: 'no $score value for singleOut');
      var one = oneEntry!.split(';');
      expect(one[0], two[1], reason: '${entry.key}: ${entry.value} != $twoEntry != $one');

      var thirdHit = Hit.getByAbbreviation(one[0]);
      score -= thirdHit.value;

      expect(score, 0);
    }
  });
}