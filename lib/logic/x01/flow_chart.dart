import 'package:dart_dart/logic/x01/settings.dart';
import 'package:dart_dart/logic/x01/statistics.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';

class FlowChart {
  static FlowChart from(
      final Games game,
      final Map<String, PlayerFlow> playerScores,
      final List<Color> playerColors) {
    final List<LineChartBarData> lineBarsData = [];
    int playerIndex = 0;

    playerScores.forEach((player, flow) {
      final List<FlSpot> dataPoints = [];
      int turnCount = 0;
      for (final leg in flow.scoreFlowPerLeg) {
        for (final score in leg) {
          final spot = FlSpot(turnCount.toDouble(), score.toDouble());
          dataPoints.add(spot);
          turnCount++;
        }
      }

      lineBarsData.add(LineChartBarData(
        spots: dataPoints,
        isCurved: true,
        barWidth: 5.0,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        color: playerColors[playerIndex % playerColors.length].withAlpha(128),
      ));

      playerIndex++;
    });

    return FlowChart(game, lineBarsData);
  }

  final List<LineChartBarData> data;
  final Games game;

  int get dataPoints {
    int maxPoints = 0;
    for (final dataSet in data) {
      final dataCnt = dataSet.spots.length;
      if (dataCnt > maxPoints) {
        maxPoints = dataCnt;
      }
    }
    return maxPoints;
  }

  FlowChart(this.game, this.data);

  double get interval {
    switch (game) {
      case Games.threeOOne:
        return 60.0;
      case Games.fiveOOne:
        return 100.0;
      case Games.sevenOOne:
        return 140.0;
    }
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      meta: meta,
      child: Text(
        value.toStringAsFixed(0),
        textAlign: TextAlign.left,
      ),
    );
  }

  SideTitles get bottomSideTiles {
    return SideTitles(
      reservedSize: 25,
      showTitles: true,
      interval: 1,
      getTitlesWidget: bottomTitleWidgets,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    if (value.toInt() == game.val - 1) return Container();

    return SideTitleWidget(
      meta: meta,
      child: Text(
        value.toStringAsFixed(0),
        textAlign: TextAlign.center,
      ),
    );
  }

  SideTitles get leftSideTitles {
    return SideTitles(
      reservedSize: 40,
      showTitles: true,
      interval: interval,
      getTitlesWidget: leftTitleWidgets,
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
      bottomTitles: AxisTitles(sideTitles: bottomSideTiles),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(sideTitles: leftSideTitles));

  LineChartData get chartData => LineChartData(
      gridData: FlGridData(show: false),
      titlesData: titlesData,
      borderData: FlBorderData(show: false),
      lineBarsData: data);
}
