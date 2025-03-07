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
  String toString() =>
      'isValid: $isValid, isCheckIn: $isCheckIn isCheckOut: $isCheckOut, isCheckable: $isCheckable';
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Player && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => name;
}

/// Represents a leg in a game, which consists of multiple turns for each player.
class GameLeg {
  final int id;
  final Map<String, List<X01Turn>> playerTurnHistory = {};
  String? _winner;

  GameLeg(this.id);

  /// Returns the list of turns for the specified player.
  List<X01Turn> turns(String player) => playerTurnHistory[player] ?? [];

  /// Adds a turn for the specified player.
  void pushTurn(String playerId, X01Turn turn) => playerTurnHistory.putIfAbsent(playerId, () => []).add(turn);

  /// Removes the last turn for the specified player.
  void popTurn(String playerId) => playerTurnHistory[playerId]?.removeLast();

  /// Unsets the winner of the leg.
  void revokeWinner() => _winner = null;

  /// Sets the winner of the leg.
  void setWinner(String playerId) => _winner = playerId;

  /// Checks if the leg is done.
  bool isDone() => _winner != null;

  /// Returns the winner ID of the leg.
  String? winnerId() => _winner;

  /// Returns the leader of the leg based on the current scores.
  String? leader() {
    if (playerTurnHistory.isEmpty) return null;

    final validEntries = playerTurnHistory.entries.where((entry) => entry.value.isNotEmpty);
    if (validEntries.isEmpty) return playerTurnHistory.keys.first;

    return validEntries.reduce((current, next) {
      final currentScore = current.value.last.getScore();
      final nextScore = next.value.last.getScore();
      return nextScore < currentScore ? next : current;
    }).key;
  }

  /// Returns the current score for the specified player.
  int? currentScoreFor(String player) => lastPlayerTurn(player)?.getScore();

  /// Returns the last turn for the specified player.
  X01Turn? lastPlayerTurn(String player) {
    final turns = playerTurnHistory[player];
    if (turns?.isEmpty ?? true) return null;
    return turns!.last;
  }
}

/// Represents a set in a game, which consists of multiple legs.
class GameSet {
  final int id;
  final List<GameLeg> _legs = [GameLeg(0)];
  String? _winner;

  GameSet(this.id);

  void revokeWinner() => _winner = null;
  void setWinner(String playerId) => _winner = playerId;
  bool isDone() => _winner != null;
  String? winnerId() => _winner;

  int get legCount => _legs.length;
  GameLeg get currentLeg => _legs.last;
  List<GameLeg> get legs => _legs;

  Map<String, int> legsWonPerPlayer() {
    final Map<String, int> perPlayerWins = {};
    for (final leg in _legs) {
      if (leg.isDone()) {
        String winnerId = leg.winnerId()!;
        perPlayerWins.update(winnerId, (old) => old + 1, ifAbsent: () => 1);
      }
    }
    return perPlayerWins;
  }

  void pushLeg({GameLeg? leg}) => _legs.add(leg ?? GameLeg(_legs.length));

  void popLeg() => _legs.removeLast();

  int legsWon(String player) => legsWonPerPlayer()[player] ?? 0;

  String? currentLegLeader() => currentLeg.leader();

  String? calcPossibleWinnerId(int winningLegsCnt) {
    var legStats = legsWonPerPlayer();
    for (final entry in legStats.entries) {
      if (entry.value >= winningLegsCnt) {
        return entry.key;
      }
    }
    return null;
  }

  int totalTurnCount(String player) {
    int totalCnt = 0;
    for (GameLeg leg in _legs) {
      totalCnt += leg.playerTurnHistory[player]?.length ?? 0;
    }
    return totalCnt;
  }
}
