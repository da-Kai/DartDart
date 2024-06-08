class Coordinate {
  final double x;
  final double y;

  const Coordinate(this.x, this.y);

  @override
  String toString() {
    return 'x($x)\ny($y)';
  }

  @override
  bool operator ==(Object other) {
    return other is Coordinate && other.x == x && other.y == y;
  }

  @override
  int get hashCode {
    const prime = 31;
    int result = 1;
    result = prime * result + (x.hashCode ^ (x.hashCode >> 32));
    result = prime * result + (y.hashCode ^ (y.hashCode >> 32));
    return result;
  }
}