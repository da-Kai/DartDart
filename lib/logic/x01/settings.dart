import 'package:dart_dart/logic/common/math.dart';
import 'package:dart_dart/logic/constant/fields.dart';

typedef Check<T> = bool Function(T a);

enum InOut {
  straight(180, 1),
  double(170, 2),
  master(180, 2);

  final int highestCheckout;
  final int lowestCheckout;

  const InOut(this.highestCheckout, this.lowestCheckout);

  /// Check if the hit fits.
  bool fits(Hit? hit) {
    if (hit == null) return false;
    return switch(this) {
      InOut.straight => true,
      InOut.double => hit.multiplier.isDouble,
      InOut.master => hit.multiplier.isDouble || hit.multiplier.isTriple,
    };
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
    if (curScore == points) {
      return isValidStarter(hit);
    }
    var val = curScore - hit.value;
    return switch (numCheck(val)) {
      NumCheck.zero => isValidFinisher(hit),
      NumCheck.positive => val >= gameOut.lowestCheckout,
      NumCheck.negative => false
    };
  }

  /// Determine if the given hit is NOT valid to the currentScore.
  bool isInvalid(int curScore, Hit hit) {
    return !isValid(curScore, hit);
  }
}