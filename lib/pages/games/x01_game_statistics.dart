import 'package:dart_dart/logic/x01/settings.dart';
import 'package:dart_dart/logic/x01/statistics.dart';
import 'package:dart_dart/style/color.dart';
import 'package:flutter/material.dart';

import 'package:dart_dart/style/font.dart';

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
                        //data.commands.undo();
                        Navigator.pop(context);
                        //data.commands.undo();
                      });
                    }),
              ],
              centerTitle: true,
            ),
            body: Column(
              children: [
                Expanded(
                  flex: 6,
                  child: _PlayerStatsView(this),
                ),
                Expanded(
                  flex: 5,
                  child: _GameProgress(this),
                )
              ]
            ),
        )
    );
  }
}

class _GameProgress extends StatelessWidget {
  final _X01StatsState state;

  const _GameProgress(this.state);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: colorScheme.backgroundShade,
        ),
    );
  }
}

class _PlayerStatsView extends StatelessWidget {
  final _X01StatsState state;

  const _PlayerStatsView(this.state);

  @override
  Widget build(BuildContext context) {
    final GameStats data = state.widget.stats;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

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
                name: '',
                setsLegs: 'Sets/Legs',
                nineAvg: '9-AVG',
                avg: 'AVG',
                max: 'MAX',
                sixtyPlus: '60+',
                oneTwentyPlus: '120+',
                checkout: 'Checkout'),
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 40.0),
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
                          setsLegs: '0/0',
                          nineAvg: '',
                          avg: '',
                          max: '',
                          sixtyPlus: '',
                          oneTwentyPlus: '',
                          checkout: '5%',
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
  final String checkout;

  const _StatsColumn({
      required this.name,
      required this.setsLegs,
      required this.nineAvg,
      required this.avg,
      required this.max,
      required this.sixtyPlus,
      required this.oneTwentyPlus,
      required this.checkout
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Column(children: [
      if (name == '') Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        child: Text('', style: FontConstants.subtitle),
      ),
      if (name != '') Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: colorScheme.primary,
        ),
        child: Text(name, style: FontConstants.subtitle),
      ),
      Container(
        padding: const EdgeInsets.only(
            top: 20.0, bottom: 5.0, left: 5.0, right: 5.0),
        child: Text(setsLegs),
      ),
      Container(
        padding: const EdgeInsets.only(
            top: 20.0, bottom: 5.0, left: 5.0, right: 5.0),
        child: Text(nineAvg),
      ),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        child: Text(avg),
      ),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        child: Text(max),
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
        padding: const EdgeInsets.only(
            top: 20.0, bottom: 5.0, left: 5.0, right: 5.0),
        child: Text(checkout),
      ),
    ]);
  }
}