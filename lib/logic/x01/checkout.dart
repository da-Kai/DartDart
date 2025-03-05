import 'dart:collection';

import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/settings.dart';

class Checkout {
  final Hit first;
  final Hit second;
  final Hit third;

  Checkout({this.first = Hit.skipped, this.second = Hit.skipped, this.third = Hit.skipped});

  static Checkout from(String str, {int dartsRemain = 0}) {
    final shift = 3 - dartsRemain;
    final prefix = ''.padLeft(shift, ';');
    final List<String> throws = '$prefix$str'.split(';');
    return Checkout(
        first: Hit.getByAbbreviation(throws[0]),
        second: Hit.getByAbbreviation(throws[1]),
        third: Hit.getByAbbreviation(throws[2]));
  }

  bool get valid {
    return first != Hit.skipped;
  }
}

bool isCheckoutPossible(InOut setting, int score) {
  if (setting.highestCheckout < score) {
    return false;
  }
  if (setting.lowestCheckout > score) {
    return false;
  }
  return !invalidCheckoutsBelowMax[setting]!.contains(score);
}

Checkout calcCheckout(InOut setting, int score, {int dartsRemain = 0}) {
  final done = dartsRemain == 0 || score <= 0;
  final invalid = score > setting.highestCheckout || score < setting.lowestCheckout;
  if (done || invalid) {
    return Checkout();
  }
  final checkouts = _listOfCheckouts(setting, dartsRemain);
  for (var checkout in checkouts) {
    var line = checkout[score];
    if (line != null) {
      return Checkout.from(line, dartsRemain: dartsRemain);
    }
  }
  return Checkout();
}

List<Map<int, String>> _listOfCheckouts(InOut setting, int dartsRemain) {
  final List<Map<int, String>> checkouts = [];
  if (setting == InOut.straight) {
    if (dartsRemain >= 3) checkouts.add(singleCheckoutTriple);
    if (dartsRemain >= 2) checkouts.add(singleCheckoutDouble);
    if (dartsRemain >= 1) checkouts.add(singleCheckoutSingle);
  }
  if (setting == InOut.master) {
    if (dartsRemain >= 3) checkouts.add(masterCheckoutTriple);
    if (dartsRemain >= 2) checkouts.add(masterCheckoutDouble);
    if (dartsRemain >= 1) checkouts.add(masterCheckoutSingle);
  }
  if (dartsRemain >= 3) checkouts.add(doubleCheckoutTriple);
  if (dartsRemain >= 2) checkouts.add(doubleCheckoutDouble);
  if (dartsRemain >= 1) checkouts.add(doubleCheckoutSingle);
  return checkouts;
}

final Map<InOut, List<int>> invalidCheckoutsBelowMax = Map.unmodifiable(HashMap.from({
    InOut.straight: <int>[],
    InOut.double: <int>[169, 168, 166, 165, 163, 162, 159],
    InOut.master: <int>[179, 178, 176, 175, 173, 172, 169, 166, 163],
}));

final Map<int, String> masterCheckoutTriple = Map.unmodifiable(HashMap.from({
  180: 'T20;T20;T20',
  177: 'T19;T20;T20',
  174: 'T20;T20;T18',
  171: 'T19;T20;T18',
  168: 'T20;T20;T16',
  165: 'T19;T20;T16',
  162: 'T18;T20;T16',
  159: 'T20;T20;T13',
}));

final Map<int, String> masterCheckoutDouble = Map.unmodifiable(HashMap.from({
  120: 'T20;T20;',
  117: 'T20;T19;',
  114: 'T20;T18;',
  111: 'T20;T17;',
  108: 'T20;T16;',
  105: 'T20;T15;',
  102: 'T20;T14;',
  99: 'T20;T13;',
}));

final Map<int, String> masterCheckoutSingle = Map.unmodifiable(HashMap.from({
  60: 'T20;;',
  57: 'T19;;',
  54: 'T18;;',
  51: 'T17;;',
  48: 'T16;;',
  45: 'T15;;',
  42: 'T14;;',
  39: 'T13;;',
  33: 'T11;;',
  27: 'T9;;',
  21: 'T7;;',
  15: 'T5;;',
  9: 'T3;;',
  3: 'T1;;',
}));

final Map<int, String> doubleCheckoutTriple = Map.unmodifiable(HashMap.from({
  170: 'T20;T20;BEYE',
  167: 'T20;T19;BEYE',
  164: 'T20;T18;BEYE',
  161: 'T20;T17;BEYE',
  160: 'T20;T20;D20',
  158: 'T20;T20;D19',
  157: 'T20;T19;D20',
  156: 'T20;T20;D18',
  155: 'T20;T19;D19',
  154: 'T20;T18;D20',
  153: 'T20;T19;D18',
  152: 'T20;T20;D16',
  151: 'T20;T17;D20',
  150: 'T20;T18;D18',
  149: 'T20;T19;D16',
  148: 'T20;T16;D20',
  147: 'T20;T17;D18',
  146: 'T20;T18;D16',
  145: 'T20;T15;D20',
  144: 'T20;T20;D12',
  143: 'T20;T17;D16',
  142: 'T20;T14;D20',
  141: 'T20;T19;D12',
  140: 'T20;T20;D10',
  139: 'T20;T13;D20',
  138: 'T20;T18;D12',
  137: 'T20;T15;D16',
  136: 'T20;T20;D8',
  135: 'T20;T17;D12',
  134: 'T20;T14;D16',
  133: 'T20;T19;D8',
  132: 'T20;T16;D12',
  131: 'T20;T13;D16',
  130: 'T20;T18;D8',
  129: 'T19;T16;D12',
  128: 'T18;T14;D16',
  127: 'T20;T17;D8',
  126: 'T19;T15;D12',
  125: 'T18;T13;D16',
  124: 'T20;T16;D8',
  123: 'T19;T14;D12',
  122: 'T20;T18;D4',
  121: 'T20;T11;D14',
  120: 'T20;20;D20',
  119: 'T19;T18;D4',
  118: 'T20;18;D20',
  117: 'T20;17;D20',
  116: 'T20;16;D20',
  115: 'T20;15;D20',
  114: 'T20;14;D20',
  113: 'T20;13;D20',
  112: 'T20;12;D20',
  111: 'T20;11;D20',
  110: 'T20;10;D20',
  109: 'T20;9;D20',
  108: 'T20;8;D20',
  107: 'T20;7;D20',
  106: 'T20;6;D20',
  105: 'T20;5;D20',
  104: 'T20;4;D20',
  103: 'T20;3;D20',
  102: 'T20;2;D20',
  101: 'T17;10;D20',
}));

final Map<int, String> doubleCheckoutDouble = Map.unmodifiable(HashMap.from({
  110: 'T20;BEYE;',
  107: 'T19;BEYE;',
  104: 'T18;BEYE;',
  101: 'T17;BEYE;',
  100: 'T20;D20;',
  98: 'T20;D19;',
  97: 'T19;D20;',
  96: 'T20;D18;',
  95: 'T19;D19;',
  94: 'T18;D20;',
  93: 'T19;D18;',
  92: 'T20;D16;',
  91: 'T17;D20;',
  90: 'T18;D18;',
  89: 'T19;D16;',
  88: 'T16;D20;',
  87: 'T17;D18;',
  86: 'T18;D16;',
  85: 'T15;D20;',
  84: 'T20;D12;',
  83: 'T17;D16;',
  82: 'T14;D20;',
  81: 'T19;D12;',
  80: 'T20;D10;',
  79: 'T13;D20;',
  78: 'T18;D12;',
  77: 'T15;D16;',
  76: 'T20;D8;',
  75: 'T17;D12;',
  74: 'T14;D16;',
  73: 'T19;D8;',
  72: 'T16;D12;',
  71: 'T13;D16;',
  70: 'T18;D8;',
  69: 'T15;D12;',
  68: 'T20;D4;',
  67: 'T17;D8;',
  66: 'T14;D12;',
  65: 'T19;D4;',
  64: 'T16;D8;',
  63: 'T13;D12;',
  62: 'T18;D4;',
  61: 'T11;D14;',
  60: '20;D20;',
  59: '19;D20;',
  58: '18;D20;',
  57: '17;D20;',
  56: '16;D20;',
  55: '15;D20;',
  54: '14;D20;',
  53: '13;D20;',
  52: '12;D20;',
  51: '11;D20;',
  50: '10;D20;',
  49: '9;D20;',
  48: '8;D20;',
  47: '7;D20;',
  46: '6;D20;',
  45: '5;D20;',
  44: '4;D20;',
  43: '3;D20;',
  42: '2;D20;',
  41: '1;D20;',
  39: '7;D16;',
  38: '18;D10;',
  37: '5;D16;',
  35: '3;D16;',
  34: '2;D16;',
  33: '1;D16;',
  31: '7;D12;',
  30: '6;D12;',
  29: '5;D12;',
  27: '3;D12;',
  26: '10;D8;',
  25: '9;D8;',
  23: '7;D8;',
  22: '6;D8;',
  21: '5;D8;',
  19: '3;D8;',
  17: '1;D8;',
  15: '7;D4;',
  14: '6;D4;',
  13: '5;D4;',
  11: '3;D4;',
  9: '1;D4;',
  7: '3;D2;',
  5: '1;D2;',
  3: '1;D1;'
}));

final Map<int, String> doubleCheckoutSingle = Map.unmodifiable(HashMap.from({
  50: 'BEYE;;',
  40: 'D20;;',
  38: 'D19;;',
  36: 'D18;;',
  34: 'D17;;',
  32: 'D16;;',
  30: 'D15;;',
  28: 'D14;;',
  26: 'D13;;',
  24: 'D12;;',
  22: 'D11;;',
  20: 'D10;;',
  18: 'D9;;',
  16: 'D8;;',
  14: 'D7;;',
  12: 'D6;;',
  10: 'D5;;',
  8: 'D4;;',
  6: 'D3;;',
  4: 'D2;;',
  2: 'D1;;'
}));

final Map<int, String> singleCheckoutTriple = Map.unmodifiable(HashMap.from({
  145: 'T20;T20;BULL',
  140: 'T20;T20;20',
  139: 'T20;T20;19',
  138: 'T20;T20;18;',
  137: 'T20;T19;20',
  136: 'T20;T19;19',
  135: 'T20;T19;18',
  134: 'T20;T18;20',
  133: 'T20;T18;19',
  132: 'T20;T18;18',
  131: 'T20;T17;20',
  130: 'T20;T17;19',
  129: 'T20;T17;18',
  128: 'T20;T16;20',
  127: 'T20;T16;19',
  126: 'T20;T16;18',
  125: 'T20;T15;20',
  124: 'T20;T15;19',
  123: 'T20;T15;18',
  122: 'T20;T14;20',
  121: 'T20;T14;19',
  119: 'T20;D20;19',
  118: 'T20;D19;20',
  116: 'T20;D18;20',
  115: 'T20;D18;19',
  113: 'T20;D17;19',
  112: 'T20;D16;20',
  109: 'T20;D15;19',
  106: 'T20;D13;20',
  103: 'T20;D12;19',
}));

final Map<int, String> singleCheckoutDouble = Map.unmodifiable(HashMap.from({
  85: 'T20;BULL;',
  82: 'T19;BULL;',
  80: 'T20;20;',
  79: 'T20;19;',
  78: 'T20;18;',
  77: 'T19;20;',
  76: 'T19;19;',
  75: 'T19;18;',
  74: 'T18;20;',
  73: 'T18;19;',
  72: 'T18;18;',
  71: 'T17;20;',
  70: 'T17;19;',
  69: 'T17;18;',
  68: 'T16;20;',
  67: 'T16;19;',
  66: 'T16;18;',
  65: 'T15;20;',
  64: 'T15;19;',
  63: 'T15;18;',
  62: 'T14;20;',
  61: 'T14;19;',
  59: 'D20;19;',
  58: 'D19;20;',
  56: 'D18;20;',
  55: 'D18;19;',
  53: 'D17;19;',
  52: 'D16;20;',
  49: 'D15;19;',
  47: 'D14;19;',
  46: 'D13;20;',
  44: 'D12;20;',
  43: 'D12;19;',
  41: 'D11;19;',
  37: '20;17;',
  35: '20;15;',
  31: '20;11;',
  29: '20;9;',
  23: '20;3;',
  21: '20;1;',
}));

final Map<int, String> singleCheckoutSingle = Map.unmodifiable(HashMap.from({
  25: 'BULL;;',
  20: '20;;',
  19: '19;;',
  18: '18;;',
  17: '17;;',
  16: '16;;',
  15: '15;;',
  14: '14;;',
  13: '13;;',
  12: '12;;',
  11: '11;;',
  10: '10;;',
  9: '9;;',
  8: '8;;',
  7: '7;;',
  6: '6;;',
  5: '5;;',
  4: '4;;',
  3: '3;;',
  2: '2;;',
  1: '1;;',
}));
