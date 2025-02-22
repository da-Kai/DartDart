import 'package:dart_dart/logic/x01/game.dart';
import 'package:dart_dart/logic/x01/settings.dart';
import 'package:dart_dart/pages/settings/x01_settings_page.dart';
import 'package:dart_dart/style/color.dart';
import 'package:flutter/material.dart';

import '../../style/font.dart';

class X01Statistics extends StatefulWidget {
  final GameStats stats;
  final GameSettings settings;

  const X01Statistics({super.key, required this.stats, required this.settings});

  @override
  State<X01Statistics> createState() => _X01StatsState();
}

class _X01StatsState extends State<X01Statistics> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final GameStats data = widget.stats;

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
                      setState(() {
                        data.commands.undo();
                        Navigator.pop(context);
                        data.commands.undo();
                      });
                    }),
              ],
              centerTitle: true,
            ),
            body: _PlayerStatsView(this, setState)));
  }
}

class _PlayerStatsView extends StatelessWidget {
  final _X01StatsState state;
  final Function update;

  const _PlayerStatsView(this.state, this.update);

  @override
  Widget build(BuildContext context) {
    final GameStats data = state.widget.stats;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextStyle textStyle =
        FontConstants.subtitle.copyWith(color: colorScheme.onPrimaryContainer);

    return Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: colorScheme.backgroundShade,
        ),
        child: Row(
          children: [
            _StatsColumn(
                name: 'Player',
                avg: 'AVG',
                max: 'MAX',
                min: 'MIN',
                most: 'Most-Hits',
                sixtyPlus: '60+',
                oneTwentyPlus: '120+',
                oneEighty: '180'),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: VerticalDivider(
                indent: 5.0,
              ),
            ),
            Expanded(
              child: SizedBox(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final player in data.playerStats.entries)
                        _StatsColumn(
                          name: player.key,
                          avg: player.value.avgScore.toStringAsFixed(2),
                          max: player.value.maxPoints.toString(),
                          min: player.value.minPoints.toString(),
                          most: player.value.mostHit.abbreviation,
                          sixtyPlus: player.value.sixtyPlusCnt.toString(),
                          oneTwentyPlus: player.value.oneTwentyPlusCnt.toString(),
                          oneEighty: player.value.oneEightyCnt.toString(),
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
  final String avg;
  final String max;
  final String min;
  final String most;
  final String sixtyPlus;
  final String oneTwentyPlus;
  final String oneEighty;

  const _StatsColumn(
      {required this.name,
      required this.avg,
      required this.max,
      required this.min,
      required this.most,
      required this.sixtyPlus,
      required this.oneTwentyPlus,
      required this.oneEighty});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        child: Text(name),
      ),
      Container(
        padding: const EdgeInsets.only(
            top: 20.0, bottom: 5.0, left: 5.0, right: 5.0),
        child: Text(avg),
      ),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        child: Text(max),
      ),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        child: Text(min),
      ),
      Container(
        padding: const EdgeInsets.only(
            top: 20.0, bottom: 5.0, left: 5.0, right: 5.0),
        child: Text(most),
      ),
      Container(
        padding: const EdgeInsets.only(
            top: 20.0, bottom: 5.0, left: 5.0, right: 5.0),
        child: Text(sixtyPlus),
      ),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        child: Text(oneTwentyPlus),
      ),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        child: Text(oneEighty),
      ),
    ]);
  }
}
