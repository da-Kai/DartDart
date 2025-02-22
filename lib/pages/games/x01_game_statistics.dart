import 'package:dart_dart/logic/x01/game.dart';
import 'package:dart_dart/logic/x01/settings.dart';
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
                  Navigator.pop(context);
                });
              },
              icon: const Icon(Icons.close),
            ),
            centerTitle: true,
          ),
          body: _TableView(this, setState)
        ));
  }
}

class _TableView extends StatelessWidget {
  final _X01StatsState state;
  final Function update;

  const _TableView(this.state, this.update);

  @override
  Widget build(BuildContext context) {
    final GameStats data = state.widget.stats;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        DataTable(
            columns: [
              DataColumn(label: const Text('Name')),
              DataColumn(label: const Text('AVG')),
              DataColumn(label: const Text('MAX')),
              DataColumn(label: const Text('MIN')),
              DataColumn(label: const Text('Most-Hits')),
              DataColumn(label: const Text('60+')),
              DataColumn(label: const Text('120+')),
              DataColumn(label: const Text('180=')),
            ],
            rows: [
              for (final player in data.playerStats.entries)
                DataRow(cells: [
                  DataCell(Text(player.key)),
                  DataCell(Text(player.value.avgScore.toStringAsFixed(2))),
                  DataCell(Text(player.value.maxPoints.toString())),
                  DataCell(Text(player.value.minPoints.toString())),
                  DataCell(Text(player.value.mostHit.abbreviation)),
                  DataCell(Text(player.value.sixtyPlusCnt.toString())),
                  DataCell(Text(player.value.oneTwentyPlusCnt.toString())),
                  DataCell(Text(player.value.oneEightyCnt.toString()))
                ])
            ],
        )
      ],
    );
  }
}
