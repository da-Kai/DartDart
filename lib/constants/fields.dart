enum HitNumber {
  miss('MISS', 0),
  bullsEye('BULL', 25),
  one('1', 1),
  two('2', 2),
  three('3', 3),
  four('4', 4),
  five('5', 5),
  six('6', 6),
  seven('7', 7),
  eight('8', 8),
  nine('9', 9),
  ten('10', 10),
  eleven('11', 11),
  twelve('12', 12),
  thirteen('13', 13),
  fourteen('14', 14),
  fifteen('15', 15),
  sixteen('16', 16),
  seventeen('17', 17),
  eighteen('18', 18),
  nineteen('19', 19),
  twenty('20', 20);

  const HitNumber(this.abbr, this.value);

  final String abbr;
  final int value;

  static HitNumber bySegment(int segment) {
    if (segment < 0) {
      return HitNumber.miss;
    } else if (segment > 19) {
      return HitNumber.bullsEye;
    }
    switch (segment) {
      case 0:
        return HitNumber.one;
      case 1:
        return HitNumber.eighteen;
      case 2:
        return HitNumber.four;
      case 3:
        return HitNumber.thirteen;
      case 4:
        return HitNumber.six;
      case 5:
        return HitNumber.ten;
      case 6:
        return HitNumber.fifteen;
      case 7:
        return HitNumber.two;
      case 8:
        return HitNumber.seventeen;
      case 9:
        return HitNumber.three;
      case 10:
        return HitNumber.nineteen;
      case 11:
        return HitNumber.seven;
      case 12:
        return HitNumber.sixteen;
      case 13:
        return HitNumber.eight;
      case 14:
        return HitNumber.eleven;
      case 15:
        return HitNumber.fourteen;
      case 16:
        return HitNumber.nine;
      case 17:
        return HitNumber.twelve;
      case 18:
        return HitNumber.five;
      case 19:
        return HitNumber.twenty;
    }
    return HitNumber.miss;
  }
}

enum HitMultiplier {
  single('', 1),
  double('D', 2),
  triple('T', 3);

  const HitMultiplier(this.prefix, this.multiplier);

  final String prefix;
  final int multiplier;
}

class Hit {
  static const Hit miss = Hit(HitNumber.miss, HitMultiplier.single);
  static const Hit skipped = Hit(HitNumber.miss, HitMultiplier.single);

  final HitNumber value;
  final HitMultiplier multiplier;

  const Hit(this.value, this.multiplier);

  int getValue() {
    return value.value * multiplier.multiplier;
  }

  @override
  String toString() {
    return multiplier.prefix + value.abbr;
  }
}

class Throws {
  Hit? first;
  Hit? second;
  Hit? third;

  Hit? get last {
    return third ?? second ?? first;
  }

  int sum() {
    return ( first?.getValue() ?? 0 ) + ( second?.getValue() ?? 0 ) + ( third?.getValue() ?? 0);
  }

  void thrown(Hit hit) {
    if(first == null) {
      first = hit;
    } else if (second == null) {
      second = hit;
    } else {
      third ??= hit;
    }
  }

  bool done() {
    return first != null && second != null && third != null;
  }
}

