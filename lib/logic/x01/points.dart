abstract class _Turn {
  _Turn? previous;
  _Turn? next;

  bool get won;

  int get currentLegs;

  int get sets;

  String asString(int sets, int legs);
}

class _Set extends _Turn {
  @override
  final bool won;
  @override
  _Turn? previous;

  _Set(this.previous, this.won);

  @override
  int get currentLegs {
    return 0;
  }

  @override
  int get sets {
    int val = (won ? 1 : 0);
    return previous == null ? val : previous!.sets + val;
  }

  @override
  String asString(int sets, int legs) {
    var str = '[$sets:$legs]';
    if (next == null) {
      return str;
    } else {
      return '$str,${next!.asString(sets + (won ? 1 : 0), legs)}';
    }
  }

  @override
  _Turn? get next => throw UnimplementedError();
}

class _Leg extends _Turn {
  @override
  final bool won;
  @override
  _Turn? previous;

  _Leg(this.previous, this.won);

  @override
  int get currentLegs {
    return _point + (previous == null ? 0 : previous!.currentLegs);
  }

  int get _point => won ? 1 : 0;

  @override
  int get sets {
    return previous == null ? 0 : previous!.sets;
  }

  @override
  String asString(int sets, int legs) {
    var str = '[$sets:$legs]';
    if (next == null) {
      return str;
    } else {
      return '$str,${next!.asString(sets, legs + (won ? 1 : 0))}';
    }
  }
}

class _TurnList {
  _Turn? last;
  _Turn? first;

  void add(_Turn Function(_Turn?) func) {
    if (last == null) {
      first = last = func(null);
    } else {
      final turn = func(last!);
      last!.next = turn;
      last = turn;
    }
  }

  void undo() {
    if (last != null) {
      var prev = last!.previous;
      if (prev != this) {
        last = prev;
      } else {
        last = null;
      }
    }
  }

  void redo() {
    if (last != null) {
      last = last!.next;
    } else if (first != null) {
      last = first;
    }
  }

  bool get canUndo => last != null;

  bool get canRedo => (last != null && last!.next != null) || first != null;

  int get currentLegs => last == null ? 0 : last!.currentLegs;

  int get sets => last == null ? 0 : last!.sets;

  bool get won => last == null ? false : last!.won;

  String asString(int sets, int legs) {
    return first == null ? '' : first!.asString(0, 0);
  }
}

class PlayerPoints {
  final _TurnList _turns = _TurnList();

  void pushLeg(bool won) {
    _turns.add((p) => _Leg(p, won));
  }

  void pushSet(bool won) {
    _turns.add((p) => _Set(p, won));
  }

  void undo() {
    _turns.undo();
  }

  void redo() {
    _turns.redo();
  }

  int get sets => _turns.sets;

  int get currentLegs => _turns.currentLegs;

  int compare(PlayerPoints other) {
    if (sets > other.sets) {
      return 1;
    } else if (sets == other.sets) {
      return currentLegs - other.currentLegs;
    } else {
      return -1;
    }
  }

  String asString() {
    return _turns.asString(0, 0);
  }

  bool operator <(PlayerPoints other) {
    return compare(other) < 0;
  }

  bool operator >(PlayerPoints other) {
    return compare(other) > 0;
  }

  bool operator <=(PlayerPoints other) {
    return compare(other) <= 0;
  }

  bool operator >=(PlayerPoints other) {
    return compare(other) < 0;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is PlayerPoints) {
      return compare(other) == 0;
    } else {
      return false;
    }
  }
}
