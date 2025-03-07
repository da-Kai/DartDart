import 'package:dart_dart/logic/common/math.dart';
import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/checkout.dart';
import 'package:dart_dart/logic/x01/common.dart';

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
    return switch (this) {
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
  final List<String> playerNames = [];

  Games game = Games.threeOOne;
  InOut gameIn = InOut.straight;
  InOut gameOut = InOut.double;
  int legs = 1;
  int sets = 1;

  bool get isOneDimensional {
    return legs == 1 || sets == 1;
  }

  GameSettings get() {
    var l = legs;
    var s = sets;

    if(isOneDimensional) {
      l = legs == 1 ? sets : legs;
      s = 1;
    }

    return GameSettings(game, gameIn, gameOut, s, l, playerNames);
  }

  bool isNameFree(String name) {
    for (var plyName in playerNames) {
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
  final List<String> player;

  GameSettings(this.game, this.gameIn, this.gameOut, this.sets, this.legs, this.player);

  int get points {
    return game.val;
  }

  static const List<int> setOptions = <int>[1, 2, 3];
  static const List<int> legOptions = <int>[1, 2, 3];

  bool get isLegsOnly => sets == 1;
  bool get isFirstWins => isLegsOnly && legs == 1;

  TurnCheck check(int initScore, Turn turn) {
    if (turn.count == 0) {
      return TurnCheck(true, false, false, false);
    }

    if (initScore == points) {
      if (gameIn.fits(turn.first)) {
        return TurnCheck(true, true, false, false);
      } else {
        return TurnCheck(false, false, false, false);
      }
    }
    bool checkable = isCheckoutPossible(gameOut, initScore);
    int endScore = initScore - turn.sum();
    if (checkable && endScore <= 0) {
      int remainScore = initScore;
      for (Hit hit in turn.hits) {
        remainScore -= hit.value;
        if (remainScore == 0) {
          var validCheckOut = gameOut.fits(hit);
          return TurnCheck(validCheckOut, false, validCheckOut, true);
        }
        if (remainScore < 0) {
          return TurnCheck(false, false, false, true);
        }
      }
    }
    bool highEnough = endScore >= gameOut.lowestCheckout;
    return TurnCheck(highEnough, false, false, checkable);
  }

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

  String getPlayer(int playerId) {
    return player[playerId];
  }
}
