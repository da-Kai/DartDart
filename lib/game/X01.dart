import 'dart:math';

import 'package:dart_dart/constants/font.dart';
import 'package:flutter/material.dart';

enum InOut { single, double, master }

enum Games { threeOOne, fiveOOne, sevenOOne }

class GameData {
  Games points = Games.threeOOne;
  InOut gameIn = InOut.single;
  InOut gameOut = InOut.double;
  int legs = 1;
  int sets = 1;
  final List<String> players = [
    'Player',
  ];
}

class X01Game extends StatefulWidget {
  const X01Game({super.key});

  @override
  State<X01Game> createState() => _X01PageState();
}

class _X01PageState extends State<X01Game> {
  final _formKey = GlobalKey<FormState>();

  double getDistance(double x, double y) {
    return sqrt(pow(x.abs(), 2) + pow(y.abs(), 2));
  }

  double getAngle(double x, double y) {
    var distance = getDistance(x, y);
    var radiant = acos(y / distance);
    var degree = radiant * (180/pi);
    return x > 0 ? 360 - degree : degree;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: FontConstants.title.fontFamily,
          ),
          backgroundColor: colorScheme.background,
          title: const Text("301"),
          //leading: Icon,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.question_mark),
            ),
          ],
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(getAngle(0,1).toString()),
          ],
        ),
      ),
    );
  }
}
