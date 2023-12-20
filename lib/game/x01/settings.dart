import 'package:dart_dart/constants/fields.dart';

enum InOut {
  single,
  double,
  master,
}

extension InOutExtension on InOut {
  bool fits(Hit? hit) {
    if (hit == null) return false;
    if (this == InOut.single) return true;
    if (this == InOut.double) {
      return hit.multiplier == HitMultiplier.double;
    }
    if (this == InOut.master) {
      return hit.multiplier == HitMultiplier.double && //
          hit.multiplier == HitMultiplier.triple;
    }
    return false;
  }

  bool possible(int remaining) {
    if (remaining < 0) return false;
    if (this == InOut.single) return true;
    if (this == InOut.double) return remaining >= 2;
    if (this == InOut.master) return remaining >= 2;
    return false;
  }
}

enum Games {
  threeOOne(text: '301', val: 301),
  fiveOOne(text: '501', val: 501),
  sevenOOne(text: '701', val: 701);

  const Games({
    required this.text,
    required this.val,
  });

  final String text;
  final int val;
}

class GameSettings {
  Games game = Games.threeOOne;
  InOut gameIn = InOut.single;
  InOut gameOut = InOut.double;
  int legs = 1;
  int sets = 1;

  int get points {
    return game.val;
  }

  static const List<int> setOptions = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9];
  static const List<int> legOptions = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9];

  final List<String> players = [];
}
