/// Every Number fields on a dart board
enum HitNumber {
  unthrown('', 0, -2),
  miss('MISS', 0, -1),
  one('1', 1, 0),
  two('2', 2, 7),
  three('3', 3, 9),
  four('4', 4, 2),
  five('5', 5, 18),
  six('6', 6, 4),
  seven('7', 7, 11),
  eight('8', 8, 13),
  nine('9', 9, 16),
  ten('10', 10, 5),
  eleven('11', 11, 14),
  twelve('12', 12, 17),
  thirteen('13', 13, 3),
  fourteen('14', 14, 15),
  fifteen('15', 15, 6),
  sixteen('16', 16, 12),
  seventeen('17', 17, 8),
  eighteen('18', 18, 1),
  nineteen('19', 19, 10),
  twenty('20', 20, 19),
  bullsEye('BULL', 25, 20);

  const HitNumber(this.abbr, this.value, this.segment);

  final String abbr;
  final int value;

  /// Dartboard segment in clockwise order.
  ///
  /// "1":0, "18":1, ... ,"20":19 and "BE":20.
  final int segment;

  /// Get [HitNumber] object by its segment.
  ///
  /// Returns [HitNumber.unthrown] if segment is null or [HitNumber.miss] if the segment is invalid.
  static HitNumber bySegment(int? segment) {
    if (segment == null) {
      return HitNumber.unthrown;
    } else {
      return HitNumber.values.firstWhere((hitNum) => hitNum.segment == segment, orElse: () => HitNumber.miss);
    }
  }

  static HitNumber byAbbreviation(String abbr) {
    return HitNumber.values.firstWhere((hitNum) => hitNum.abbr == abbr);
  }
}

/// Three possible Multipliers on a Dart board
enum HitMultiplier {
  single(1, '', 'x1'),
  double(2, 'D', 'x2'),
  triple(3, 'T', 'x3');

  const HitMultiplier(this.multiplier, this.prefix, this.text);

  final String prefix;
  final String text;
  final int multiplier;

  bool get isSingle => this == HitMultiplier.single;
  bool get isDouble => this == HitMultiplier.double;
  bool get isTriple => this == HitMultiplier.triple;
}

/// Represents a single Dart hit.
class Hit {
  static const Hit miss = Hit._(HitNumber.miss, HitMultiplier.single);
  static const Hit skipped = Hit._(HitNumber.unthrown, HitMultiplier.single);

  static const Hit bullseye = Hit._(HitNumber.bullsEye, HitMultiplier.single);
  static const Hit doubleBullseye = Hit._(HitNumber.bullsEye, HitMultiplier.double);

  final HitNumber number;
  final HitMultiplier multiplier;

  const Hit._(this.number, this.multiplier);

  static Hit get(HitNumber number, HitMultiplier multiplier) {
    if (number == HitNumber.miss) {
      return Hit.miss;
    }
    if (number == HitNumber.bullsEye && multiplier.isTriple) {
      return Hit.doubleBullseye;
    }
    return Hit._(number, multiplier);
  }

  static Hit getByAbbreviation(String abbr) {
    var mult = HitMultiplier.single;
    if (abbr.startsWith('D')) {
      mult = HitMultiplier.double;
      abbr = abbr.substring(1);
    } else if (abbr.startsWith('T')) {
      mult = HitMultiplier.triple;
      abbr = abbr.substring(1);
    }
    var num = HitNumber.byAbbreviation(abbr);
    return Hit.get(num, mult);
  }

  int get value {
    return number.value * multiplier.multiplier;
  }

  String get abbreviation {
    switch (number) {
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

  int operator +(covariant other) {
    if (other is Hit) return value + other.value;
    if (other is int) return value + other;
    throw UnimplementedError();
  }

  @override
  bool operator ==(Object other) {
    return other is Hit && other.multiplier == multiplier && other.number == number;
  }

  @override
  int get hashCode => abbreviation.hashCode;
}

/// A Representation of a Players 3 throws per turn.
class Turn {
  Hit first;
  Hit second;
  Hit third;

  Turn({this.first = Hit.skipped, this.second = Hit.skipped, this.third = Hit.skipped});

  Hit? get last {
    return get(count - 1);
  }

  Hit? get(int pos) {
    switch (pos) {
      case 0:
        return first;
      case 1:
        return second;
      case 2:
        return third;
      default:
        return null;
    }
  }

  /// Add Hit to throws and return the position.
  ///
  /// If no position is given, the next one is chosen.
  int thrown(Hit hit, {int? pos}) {
    switch (pos ?? count) {
      case 0:
        first = hit;
        return 0;
      case 1:
        second = hit;
        return 1;
      case 2:
        third = hit;
        return 2;
      default:
        return -1;
    }
  }

  /// Undo a Hit and return, if anything changed.
  ///
  /// If no position is given, the last one is chosen.
  bool undo({int? pos}) {
    switch (pos ?? (count - 1)) {
      case 0:
        first = Hit.skipped;
        return true;
      case 1:
        second = Hit.skipped;
        return true;
      case 2:
        third = Hit.skipped;
        return true;
    }
    return false;
  }

  /// Get the number of hits.
  int get count {
    if (third != Hit.skipped) return 3;
    if (second != Hit.skipped) return 2;
    if (first != Hit.skipped) return 1;
    return 0;
  }

  /// Get the number of hits remaining.
  int get remain {
    return 3 - count;
  }

  /// Get the total sum of throws
  int sum({int until = 2}) {
    int sum = 0;
    if (until >= 0) sum += first.value;
    if (until >= 1) sum += second.value;
    if (until >= 2) sum += third.value;
    return sum;
  }

  /// Return if all hits are taken.
  bool done() {
    return count == 3;
  }
}
