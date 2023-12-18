enum FieldVal {
  miss('MISS', 0),
  bullsEye('BULL', 25),
  one('01', 1),
  two('02', 2),
  three('03', 3),
  four('04', 4),
  five('05', 5),
  six('06', 6),
  seven('07', 7),
  eight('08', 8),
  nine('09', 9),
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

  const FieldVal(this.abbr, this.value);

  final String abbr;
  final int value;
}

enum FieldMultiplier {
  single('', 1),
  double('D', 2),
  triple('T', 3);

  const FieldMultiplier(this.prefix, this.multiplier);

  final String prefix;
  final int multiplier;
}

class Field {
  static const Field miss = Field(FieldVal.miss, FieldMultiplier.single);

  final FieldVal value;
  final FieldMultiplier multiplier;

  const Field(this.value, this.multiplier);

  int getValue() {
    return value.value * multiplier.multiplier;
  }

  @override
  String toString() {
    return multiplier.prefix + value.abbr;
  }
}