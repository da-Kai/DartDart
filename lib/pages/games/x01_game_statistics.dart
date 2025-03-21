import 'package:dart_dart/style/x01/style_meta.dart';
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

  const X01Statistics(
      {super.key,
      required this.stats,
      required this.settings,
      required this.onUndo});

  @override
  State<X01Statistics> createState() => _X01StatsState();
}

class _X01StatsState extends State<X01Statistics> {
  int leg = 0;

  void setLeg(double val) {
    setState(() {
      leg = val.toInt();
    });
  }

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
              child: Column(spacing: 10.0, children: [
                Expanded(
                  flex: 5,
                  child: _PlayerStatsView(this),
                ),
                Expanded(
                  flex: 5,
                  child: _GameProgress(
                      data: widget.settings.game,
                      gameFlow: widget.stats.gameFlow),
                )
              ]),
            )));
  }
}

class _GameProgress extends StatefulWidget {
  final Games data;
  final GameFlow gameFlow;

  const _GameProgress({required this.data, required this.gameFlow});

  @override
  State<_GameProgress> createState() => _GameProgressState();
}

class _GameProgressState extends State<_GameProgress> {
  int currentLeg = 0;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final legCount = widget.gameFlow.legCount;

    final List<Color> playerColors =
        colorScheme.brightness == Brightness.light //
            ? PlayerColors.light //
            : PlayerColors.dark;

    final lineChartData = FlowChart.from(
        widget.data, widget.gameFlow.playerScores, currentLeg, playerColors);

    return Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: colorScheme.backgroundShade,
        ),
        child: Column(
          children: [
            legCount <= 1
                ? Container()
                : Slider(
                    value: currentLeg.toDouble(),
                    divisions: legCount - 1,
                    max: (legCount - 1).toDouble(),
                    min: 0,
                    label: '${currentLeg + 1}. Leg',
                    onChanged: (val) {
                      setState(() {
                        currentLeg = val.toInt();
                      });
                    }),
            Expanded(
                child: SingleChildScrollView(
              clipBehavior: Clip.hardEdge,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: lineChartData.dataPoints * 50,
                child: LineChart(lineChartData.chartData),
              ),
            )),
          ],
        ));
  }
}

class _PlayerStatsView extends StatelessWidget {
  final _X01StatsState state;

  const _PlayerStatsView(this.state);

  @override
  Widget build(BuildContext context) {
    final data = state.widget.stats.playerStats;
    final colorScheme = Theme.of(context).colorScheme;

    final List<Color> playerColors =
        colorScheme.brightness == Brightness.light //
            ? PlayerColors.light //
            : PlayerColors.dark;

    Color playerColor(String name) {
      final int index =
          data.entries.toList().indexWhere((element) => element.key == name);
      return playerColors[index];
    }

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
                checkout: 'Checkout',
                alignment: CrossAxisAlignment.end,
                isFaded: true
            ),
            Padding(
              padding: EdgeInsets.only(top: 40.0, right: 10.0),
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
                            winner: player.key == state.widget.stats.winner,
                            setsLegs:
                                '${player.value.sets}/${player.value.legs}',
                            nineAvg: player.value.nineAvg.toStringAsFixed(2),
                            avg: player.value.avg.toStringAsFixed(2),
                            max: player.value.max.toString(),
                            sixtyPlus: player.value.sixtyPlus.toString(),
                            oneTwentyPlus:
                                player.value.oneTwentyPlus.toString(),
                            oneEighty: player.value.oneEighty.toString(),
                            checkout:
                                '${(player.value.checkoutRate * 100).toStringAsFixed(1)}%',
                            color: playerColor(player.key)),
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
  final Color? color;
  final bool winner;
  final CrossAxisAlignment alignment;
  final bool isFaded;

  final Shadow shadow = const Shadow(
      color: Colors.black, blurRadius: 0.0, offset: Offset(0.0, 1.0));

  const _StatsColumn({
    required this.name,
    required this.setsLegs,
    required this.nineAvg,
    required this.avg,
    required this.max,
    required this.sixtyPlus,
    required this.oneTwentyPlus,
    required this.oneEighty,
    required this.checkout,
    this.color,
    this.winner = false,
    this.alignment = CrossAxisAlignment.center,
    this.isFaded = false,
  });

  Widget getColorIcon() {
    if (color == null) {
      return Icon(Icons.circle, color: Colors.transparent);
    }
    if (winner) {
      return Icon(Icons.emoji_events, color: color, shadows: [shadow]);
    } else {
      return Icon(Icons.circle, color: color, shadows: [shadow]);
    }
  }

  Container getHeaderBean(String? name, ColorScheme colorScheme) {
    final String nameVal = name ?? '';
    final Decoration? deco = nameVal.isEmpty
        ? null
        : BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: colorScheme.primary,
          );
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        decoration: deco,
        child: Row(
          children: [
            Text(
              nameVal,
              overflow: TextOverflow.ellipsis,
              style: FontConstants.text.copyWith(
                color: colorScheme.onPrimary,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.0, top: 2.0, bottom: 2.0),
              child: getColorIcon(),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextStyle text = FontConstants.text.copyWith(
      fontStyle: isFaded ? FontStyle.italic : FontStyle.normal,
      color: colorScheme.onSurface.withAlpha(isFaded? 150 : 255),
    );

    return Column(spacing: 8.0, crossAxisAlignment: alignment, children: [
      getHeaderBean(name, colorScheme),
      Padding(padding: const EdgeInsets.symmetric(vertical: 2.0)),
      Text(setsLegs, style: text),
      Padding(padding: const EdgeInsets.symmetric(vertical: 2.0)),
      Text(nineAvg, style: text),
      Text(avg, style: text),
      Text(max, style: text),
      Padding(padding: const EdgeInsets.symmetric(vertical: 2.0)),
      Text(sixtyPlus, style: text),
      Text(oneTwentyPlus, style: text),
      Text(oneEighty, style: text),
      Padding(padding: const EdgeInsets.symmetric(vertical: 2.0)),
      Text(checkout, style: text),
    ]);
  }
}
