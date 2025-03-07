import 'package:dart_dart/logic/x01/common.dart';

class PlayerGameStats {
  final bool isWinner;
  final String player;

  final int sets;
  final int legs;
  final double nineAvg;
  final double avg;
  final int max;
  final int sixtyPlus;
  final int oneTwentyPlus;
  final int oneEighty;
  final double checkoutRate;

  PlayerGameStats(this.player, this.isWinner,
      {required this.sets, //
      required this.legs, //
      required this.nineAvg, //
      required this.avg, //
      required this.max, //
      required this.sixtyPlus, //
      required this.oneTwentyPlus, //
      required this.oneEighty, //
      required this.checkoutRate //
      });

  static PlayerGameStats from(String player, bool isWinner,
      {required List<GameSet> stats}) {
    int checkoutCnt = 0;
    int checkouts = 0;
    int setWins = 0;
    int legWins = 0;
    int firstNineSum = 0;
    int firstNineCnt = 0;
    int totalSum = 0;
    int totalCount = 0;
    int maxTurn = 0;
    int sixtyPlusCnt = 0;
    int oneTwentyPlusCnt = 0;
    int oneEightyCnt = 0;

    for (final GameSet set in stats) {
      if (set.winnerId() == player) {
        setWins++;
      }

      for (final GameLeg leg in set.legs) {
        if (leg.winnerId() == player) {
          legWins++;
        }

        int turnNum = 0;
        bool checkedIn = false;
        for (final X01Turn turn in leg.turns(player)) {
          if (turn.check.isCheckIn) checkedIn = true;
          if (!checkedIn) continue;

          if (turn.check.isCheckable) checkoutCnt++;
          if (turn.check.isCheckOut) checkouts++;

          final int sum = turn.sum();

          if (turnNum < 3) {
            firstNineSum += sum;
            firstNineCnt += turn.count;
          }
          totalSum += sum;
          totalCount += turn.count;

          if (sum >= 60) {
            sixtyPlusCnt++;
            if (sum >= 120) {
              oneTwentyPlusCnt++;
              if (sum >= 180) oneEightyCnt++;
            }
          }

          if (sum > maxTurn) maxTurn = sum;

          turnNum++;
        }
      }
    }

    return PlayerGameStats(player, isWinner, //
        sets: setWins,
        legs: legWins,
        nineAvg: firstNineSum / firstNineCnt,
        avg: totalSum / totalCount,
        max: maxTurn,
        sixtyPlus: sixtyPlusCnt,
        oneTwentyPlus: oneTwentyPlusCnt,
        oneEighty: oneEightyCnt,
        checkoutRate: checkoutCnt <= 0 ? 0 : checkouts / checkoutCnt);
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
      playerStats.putIfAbsent(
          ply, () => PlayerGameStats.from(ply, ply == winner, stats: sets));
    }
    gameFlow = GameFlow(stats: sets);
  }
}
