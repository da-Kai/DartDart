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

class PlayerTurnHistory {
  final Map<int, List<PlayerTurn>> turnHistory = HashMap();

  void add(int leg, PlayerTurn turn) {
    var list = turnHistory.putIfAbsent(leg, () => []);
    list.add(turn);
  }

  PlayerTurn pop(int leg) {
    return turnHistory[leg]!.removeLast();
  }

  int? score(int leg) {
    if (turnHistory.isEmpty || !turnHistory.containsKey(leg)) return null;
    final turns = turnHistory[leg]!;
    if (turns.isEmpty) return null;
    return turns.last.score;
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
    for (var leg in turnHistory.turnHistory.values) {
      hc += leg.last.score;
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
  int currentLeg = 0;

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
  }
}
