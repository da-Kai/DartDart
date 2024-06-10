import 'package:dart_dart/logic/common/math.dart';
import 'package:dart_dart/logic/constant/fields.dart';

enum InOut {
  straight,
  double,
  master,
}

extension InOutExtension on InOut {
  /// Check if the hit fits.
  bool fits(Hit? hit) {
    if (hit == null) return false;
    if (this == InOut.straight) return true;
    if (this == InOut.double) {
      return hit.multiplier == HitMultiplier.double;
    }
    if (this == InOut.master) {
      return hit.multiplier == HitMultiplier.double || //
          hit.multiplier == HitMultiplier.triple;
    }
    return false;
  }

  /// Check if a finisher is possible with the remaining score.
  bool possible(int remaining) {
    if (remaining < 0) return false;
    if (this == InOut.straight) return true;
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

class GameSettingFactory {
  final List<String> players = [];

  Games game = Games.threeOOne;
  InOut gameIn = InOut.straight;
  InOut gameOut = InOut.double;
  int legs = 1;
  int sets = 1;

  GameSettings get() {
    return GameSettings(game, gameIn, gameOut, sets, legs);
  }

  bool isNameFree(String name) {
    for (var plyName in players) {
      if (plyName.toLowerCase() == name.toLowerCase()) {
        return false;
      }
    }
    return true;
  }
}

class GameSettings {
  final Games game;
  final InOut gameIn;
  final InOut gameOut;
  final int legs;
  final int sets;

  GameSettings(this.game, this.gameIn, this.gameOut, this.sets, this.legs);

  int get points {
    return game.val;
  }

  static const List<int> setOptions = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9];
  static const List<int> legOptions = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9];

  /// Determine if the given hit is a potential fishing hit.
  bool isValidFinisher(Hit hit) {
    return gameOut.fits(hit);
  }

  /// Determine if the given hit is a potential starting hit.
  bool isValidStarter(Hit hit) {
    return gameIn.fits(hit);
  }

  /// Determine if the given hit is valid to the currentScore.
  bool isValid(int curScore, Hit hit) {
    if(curScore == points) {
      return isValidStarter(hit);
    }
    var val = curScore - hit.value;
    switch(numCheck(val)) {
      case NumCheck.zero:
        return isValidFinisher(hit);
      case NumCheck.positive:
        return gameOut.possible(val);
      case NumCheck.negative:
        return false;
    }
  }

  /// Determine if the given hit is NOT valid to the currentScore.
  bool isInvalid(int curScore, Hit hit) {
    return !isValid(curScore, hit);
  }
}
