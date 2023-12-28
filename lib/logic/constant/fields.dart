enum HitNumber {
  unthrown('', 0),
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
  single(1, '', 'x1'),
  double(2, 'D', 'x2'),
  triple(3, 'T', 'x3');

  const HitMultiplier(this.multiplier, this.prefix, this.text);

  final String prefix;
  final String text;
  final int multiplier;
}

class Hit {
  static const Hit miss = Hit(HitNumber.miss, HitMultiplier.single);
  static const Hit skipped = Hit(HitNumber.unthrown, HitMultiplier.single);

  final HitNumber number;
  final HitMultiplier multiplier;

  const Hit(this.number, this.multiplier);

  static Hit getFrom(HitNumber number, HitMultiplier multiplier) {
    if(number == HitNumber.bullsEye && multiplier == HitMultiplier.triple) {
      return Hit(number, HitMultiplier.double);
    } else {
      return Hit(number, multiplier);
    }
  }

  int get value {
    return number.value * multiplier.multiplier;
  }

  String get abbreviation {
    switch(number) {
      case HitNumber.unthrown:
        return '';
      case HitNumber.miss:
        return 'MISS';
      default:
        return multiplier.prefix + number.abbr;
    }
  }

  @override
  String toString() {
    return abbreviation;
  }
}

class Throws {
  Hit first = Hit.skipped;
  Hit second = Hit.skipped;
  Hit third = Hit.skipped;

  Hit? get last {
    switch(count) {
      case 1: return first;
      case 2: return second;
      case 3: return third;
    }
    return null;
  }

  int get count {
    if(third != Hit.skipped) return 3;
    if (second != Hit.skipped) return 2;
    if (first != Hit.skipped) return 1;
    return 0;
  }

  int sum() {
    return first.value + second.value + third.value;
  }

  void thrown(Hit hit) {
    switch(count) {
      case 0: first = hit;
      case 1: second = hit;
      case 2: third = hit;
    }
  }

  bool done() {
    return count == 3;
  }

  void undo() {
    switch(count) {
      case 1: first = Hit.skipped;
      case 2: second = Hit.skipped;
      case 3: third = Hit.skipped;
    }
  }
}

