import 'dart:collection';

import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/points.dart';
import 'package:dart_dart/logic/x01/settings.dart';

class PlayerTurn extends Turn {
  final GameSettings settings;
  final int startScore;

  PlayerTurn(this.settings, this.startScore,
      {super.first = Hit.skipped, super.second = Hit.skipped, super.third = Hit.skipped});

  static PlayerTurn from(GameSettings settings) {
    return PlayerTurn(settings, settings.points);
  }

  @override
  bool get done {
    return count == 3 || isCheckout || overthrown;
  }

  bool get overthrown => startScore < sum();

  bool get valid {
    int val = startScore;
    for (int i = 0; i < count; i++) {
      var hit = get(i)!;
      if (settings.isInvalid(val, hit)) {
        return false;
      }
      val -= hit.value;
      if (val == 0 && settings.isValidFinisher(hit)) {
        return true;
      }
    }
    return true;
  }

  int get score {
    final updated = startScore - sum();
    if (valid) {
      return updated <= 0 ? 0 : updated;
    } else {
      return startScore;
    }
  }

  bool get isCheckout {
    return score == 0;
  }
}

class LegTurns {
  final int leg;
  final List<PlayerTurn> turns;
  LegTurns(this.leg, this.turns);
}

class PlayerTurnHistory {
  final Map<int, List<PlayerTurn>> _turnsByLeg = HashMap();

  void add(int leg, PlayerTurn turn) {
    var list = _turnsByLeg.putIfAbsent(leg, () => []);
    list.add(turn);
  }

  PlayerTurn pop(int leg) {
    return _turnsByLeg[leg]!.removeLast();
  }

  int? score(int leg) {
    if (_turnsByLeg.isEmpty || !_turnsByLeg.containsKey(leg)) return null;
    final turns = _turnsByLeg[leg]!;
    if (turns.isEmpty) return null;
    return turns.last.score;
  }

  Iterable<LegTurns> get entries {
    return _turnsByLeg.entries.map((e) => LegTurns(e.key, e.value));
  }

  Iterable<int> get legScores {
    return _turnsByLeg.entries.map((e) => e.value.isEmpty ? 0 : e.value.last.score);
  }

  int get turnCount {
    int cnt = 0;
    for (var leg in _turnsByLeg.values) {
      cnt += leg.length;
    }
    return cnt;
  }
}

typedef PlayerFactory = Player Function(String);

/// Simple Player
class Player {
  final String name;
  final int startScore;
  final PlayerTurnHistory turnHistory = PlayerTurnHistory();

  final PlayerPoints points = PlayerPoints();
  final int Function() leg;

  Player(this.name, this.startScore, this.leg);

  int get handicap {
    int hc = 0;
    for (var score in turnHistory.legScores) {
      hc += score;
    }
    return hc;
  }

  int scoreLeg(int leg) {
    return turnHistory.score(leg) ?? startScore;
  }

  int get score {
    return scoreLeg(leg());
  }

  bool get done {
    return score == 0;
  }

  void pushTurn(int leg, PlayerTurn turn) => turnHistory.add(leg, turn);

  PlayerTurn popTurn(int leg) => turnHistory.pop(leg);
}

/// Container for the active Turn
class GameRound {
  final GameSettings _settings;
  late PlayerTurn current;
  int currentLeg = -1;

  GameRound(this._settings) {
    reset();
  }

  void setupTurn(PlayerTurn round) {
    current = round;
  }

  void setupTurnFor(Player player) {
    current = PlayerTurn(_settings, player.score);
  }

  void reset() {
    current = PlayerTurn.from(_settings);
    currentLeg = 0;
  }
}
