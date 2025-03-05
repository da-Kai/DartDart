import 'package:dart_dart/logic/x01/common.dart';

class PlayerGameStats {
  final bool isWinner;
  final String player;

  late final int sets;
  late final int legs;
  late final double nineAvg;
  late final double avg;
  late final int max;
  late final int sixtyPlus;
  late final int twentyOnePlus;
  late final int oneEighty;
  late final double checkoutRate;

  PlayerGameStats(this.player, this.isWinner, {required List<GameSet> stats}) {
    //TODO fill values;
  }
}

class LegStats {
  Map<String, List<int>> playerScores = {};
}

class SetStats {
  List<LegStats> legs = [];
}

class GameFlow {
  List<SetStats> sets = [];

  GameFlow({required List<GameSet> stats}) {
    //TODO fill values
  }
}

class GameStats {
  final List<GameSet> sets;
  final Map<String, PlayerGameStats> playerStats = {};
  late final GameFlow gameFlow;

  GameStats(this.sets, List<String> players, String winner) {
    for (var ply in players) {
      playerStats.putIfAbsent(ply, () => PlayerGameStats(ply, ply == winner, stats: sets));
    }
    gameFlow = GameFlow(stats: sets);
  }
}