enum NumCompare {
  equal,
  greater,
  lower,
}

NumCompare numCompare(num a, num b) {
  if (a > b) return NumCompare.greater;
  if (a < b) return NumCompare.lower;
  return NumCompare.equal;
}

enum NumCheck {
  zero,
  positive,
  negative,
}

NumCheck numCheck(num number) {
  if (number > 0) return NumCheck.positive;
  if (number < 0) return NumCheck.negative;
  return NumCheck.zero;
}