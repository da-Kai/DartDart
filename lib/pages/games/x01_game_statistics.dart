import 'package:dart_dart/logic/x01/flow_chart.dart';
import 'package:dart_dart/logic/x01/settings.dart';
import 'package:dart_dart/logic/x01/statistics.dart';
import 'package:dart_dart/style/color.dart';
import 'package:flutter/material.dart';

import 'package:dart_dart/style/font.dart';
import 'package:fl_chart/fl_chart.dart';

class X01Statistics extends StatefulWidget {
  final GameStats stats;
  final GameSettings settings;
  final VoidCallback onUndo;

  const X01Statistics({super.key, required this.stats, required this.settings, required this.onUndo});

  @override
  State<X01Statistics> createState() => _X01StatsState();
}

class _X01StatsState extends State<X01Statistics> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return PopScope(
        canPop: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: FontConstants.title.fontFamily,
              color: colorScheme.onSurface,
            ),
            backgroundColor: colorScheme.surface,
            title: const Text('Statistics'),
            leading: IconButton(
              onPressed: () {
                setState(() {
                  int count = 0;
                  Navigator.popUntil(context, (route) {
                    return ++count > 2;
                  });
                });
              },
              icon: const Icon(Icons.close),
            ),
            actions: [
              //TODO implement undo functionality
              IconButton(
                  icon: const Icon(Icons.undo),
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onUndo();
                  }),
            ],
            centerTitle: true,
          ),
          body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                  spacing: 10.0,
                  children: [
                    Expanded(
                      flex: 5,
                      child: _PlayerStatsView(this),
                    ),
                    Expanded(
                      flex: 5,
                      child: _GameProgress(this),
                    )
                  ]),
          )
        ));
  }
}

class _GameProgress extends StatelessWidget {
  final _X01StatsState state;

  const _GameProgress(this.state);

  @override
  Widget build(BuildContext context) {
    final game = state.widget.settings.game;
    final gameFlow = state.widget.stats.gameFlow;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final List<Color> playerColors = [Colors.red, Colors.blue, Colors.green, Colors.yellow];

    final lineChartData = FlowChart.from(game, gameFlow.playerScores, playerColors);

    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: colorScheme.backgroundShade,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: lineChartData.dataPoints * 1.5,
              child: LineChart(lineChartData.chartData),
            ),
          )
        ),
      ),
    );
  }
}

class _PlayerStatsView extends StatelessWidget {
  final _X01StatsState state;

  const _PlayerStatsView(this.state);

  @override
  Widget build(BuildContext context) {
    final data = state.widget.stats.playerStats;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: colorScheme.backgroundShade,
        ),
        child: Row(
          spacing: 5.0,
          children: [
            _StatsColumn(
                name: '',
                setsLegs: 'Sets/Legs',
                nineAvg: '9-AVG',
                avg: 'AVG',
                max: 'MAX',
                sixtyPlus: '60+',
                oneTwentyPlus: '120+',
                oneEighty: '180=',
                checkout: 'Checkout'),
            Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: VerticalDivider(
                indent: 5.0,
              ),
            ),
            Expanded(
              child: SizedBox(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 5.0,
                    children: [
                      for (final player in data.entries)
                        _StatsColumn(
                          name: player.key,
                          setsLegs: '${player.value.sets}/${player.value.legs}',
                          nineAvg: player.value.nineAvg.toStringAsFixed(2),
                          avg: player.value.avg.toStringAsFixed(2),
                          max: player.value.max.toString(),
                          sixtyPlus: player.value.sixtyPlus.toString(),
                          oneTwentyPlus: player.value.oneTwentyPlus.toString(),
                          oneEighty: player.value.oneEighty.toString(),
                          checkout:
                              '${(player.value.checkoutRate * 100).toStringAsFixed(1)}%',
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

class _StatsColumn extends StatelessWidget {
  final String name;
  final String setsLegs;
  final String nineAvg;
  final String avg;
  final String max;
  final String sixtyPlus;
  final String oneTwentyPlus;
  final String oneEighty;
  final String checkout;

  const _StatsColumn(
      {required this.name,
      required this.setsLegs,
      required this.nineAvg,
      required this.avg,
      required this.max,
      required this.sixtyPlus,
      required this.oneTwentyPlus,
      required this.oneEighty,
      required this.checkout});

  Container getHeaderBean(String? name, ColorScheme colorScheme) {
    final String nameVal = name ?? '';
    final Decoration? deco = nameVal.isEmpty
        ? null
        : BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: colorScheme.primary,
          );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      decoration: deco,
      child: Text(nameVal, style: FontConstants.subtitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Column(spacing: 8.0, children: [
      getHeaderBean(name, colorScheme),
      Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
      Text(setsLegs),
      Padding(padding: const EdgeInsets.symmetric(vertical: 2.0)),
      Text(nineAvg),
      Text(avg),
      Text(max),
      Padding(padding: const EdgeInsets.symmetric(vertical: 2.0)),
      Text(sixtyPlus),
      Text(oneTwentyPlus),
      Text(oneEighty),
      Padding(padding: const EdgeInsets.symmetric(vertical: 2.0)),
      Text(checkout),
    ]);
  }
}
