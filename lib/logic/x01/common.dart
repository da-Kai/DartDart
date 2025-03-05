import 'package:dart_dart/logic/constant/fields.dart';

class TurnCheck {
  /// Is a valid CheckIn
  final bool isCheckIn;

  /// Is a valid CheckOut
  final bool isCheckOut;

  /// Was a CheckOut possible / Counts as CheckOut try
  final bool isCheckable;

  /// Is the Turn valid at all
  final bool isValid;

  TurnCheck(this.isValid, this.isCheckIn, this.isCheckOut, this.isCheckable);

  static TurnCheck instance() {
    return TurnCheck(true, false, false, false);
  }

  @override
  String toString() {
    return 'isValid: $isValid, isCheckable: $isCheckable, isCheckOut: $isCheckOut, isCheckOut: $isCheckIn';
  }
}

abstract class X01Turn extends Turn {
  /// X01 Checks
  final TurnCheck check;

  X01Turn(
      {required super.first,
      required super.second,
      required super.third,
      required this.check});

  int calcScore() {
    return check.isValid ? sum() : 0;
  }

  int getScore();
}

class InitTurn extends X01Turn {
  final int initScore;

  InitTurn(
      {super.first = Hit.miss,
      super.second = Hit.miss,
      super.third = Hit.miss,
      required super.check,
      required this.initScore});

  @override
  int getScore() {
    return initScore - calcScore();
  }
}

class GameTurn extends X01Turn {
  final X01Turn previous;

  GameTurn(
      {super.first = Hit.miss,
      super.second = Hit.miss,
      super.third = Hit.miss,
      required super.check,
      required this.previous});

  @override
  int getScore() {
    return previous.getScore() - calcScore();
  }
}

typedef PlayerFactory = Player Function(String);

/// Simple Player
class Player {
  final String name;

  Player(this.name);
}

class GameLeg {
  final int id;
  final Map<String, List<X01Turn>> playerTurnHistory = {};
  String? _winner;

  GameLeg(this.id);

  void pushTurn(String playerId, X01Turn turn) {
    playerTurnHistory.putIfAbsent(playerId, () => []).add(turn);
  }

  void popTurn(String playerId) {
    playerTurnHistory[playerId]?.removeLast();
  }

  void setWinner(String? playerId) => _winner = playerId;

  bool isDone() => _winner != null;

  String? winnerId() => _winner;

  String? leader() {
    if (playerTurnHistory.isEmpty) return null;

    final validEntries =
        playerTurnHistory.entries.where((entry) => entry.value.isNotEmpty);
    if (validEntries.isEmpty) return playerTurnHistory.keys.first;

    return validEntries.reduce((current, next) {
      final currentScore = current.value.last.getScore();
      final nextScore = next.value.last.getScore();
      return nextScore < currentScore ? next : current;
    }).key;
  }

  int? currentScoreFor(String player) {
    return lastPlayerTurn(player)?.getScore();
  }

  X01Turn? lastPlayerTurn(String player) {
    final turns = playerTurnHistory[player];
    if (turns?.isEmpty ?? true) return null;
    return turns!.last;
  }
}

class GameSet {
  final int id;
  final List<GameLeg> _legs = [GameLeg(0)];
  String? _winner;

  GameSet(this.id);

  void setWinner(String? playerId) => _winner = playerId;

  bool isDone() => _winner != null;

  String? winnerId() => _winner;

  int get legCount {
    return _legs.length;
  }

  GameLeg get currentLeg {
    return _legs.last;
  }

  Map<String, int> legsWonPerPlayer() {
    Map<String, int> perPlayerWins = {};
    for (var leg in _legs) {
      if (leg.isDone()) {
        String winnerId = leg.winnerId()!;
        perPlayerWins.update(winnerId, (old) => old++, ifAbsent: () => 1);
      }
    }
    return perPlayerWins;
  }

  void pushLeg({GameLeg? leg}) {
    var nextLeg = leg ?? GameLeg(_legs.length);
    _legs.add(nextLeg);
  }

  void popLeg() {
    _legs.removeLast();
  }

  String? calcPossibleWinnerId(int winningLegsCnt) {
    var legStats = legsWonPerPlayer();
    for (final entry in legStats.entries) {
      if (entry.value >= winningLegsCnt) {
        return entry.key;
      }
    }
    return null;
  }

  int legsWon(String player) {
    var legStats = legsWonPerPlayer();
    return legStats[player] ?? 0;
  }

  String? currentLegLeader() {
    return currentLeg.leader();
  }

  int totalTurnCount(String player) {
    int totalCnt = 0;
    for (GameLeg leg in _legs) {
      totalCnt += leg.playerTurnHistory[player]?.length ?? 0;
    }
    return totalCnt;
  }
}
