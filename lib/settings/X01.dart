import 'dart:io';
import 'dart:math';

import 'package:dart_dart/constants/font.dart';
import 'package:flutter/material.dart';

enum InOut { single, double, master }

class GameData {
  int points = 301;
  InOut gameIn = InOut.single;
  InOut gameOut = InOut.double;
  int legs = 1;
  int sets = 1;
}

class X01 extends StatefulWidget {
  const X01({super.key});

  @override
  State<X01> createState() => _X01PageState();
}

class _X01PageState extends State<X01> {
  final _formKey = GlobalKey<FormState>();

  GameData data = GameData();

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final ButtonStyle startButtonStyle = ElevatedButton.styleFrom(
      textStyle: FontConstants.text,
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
    );

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          titleTextStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: FontConstants.title.fontFamily,
          ),
          title: const Text("X01-Game"),
          centerTitle: true,
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _GameSettings(data),
              const _InOutSettings(),
              const _PlayerSettings(),
            ],
          ),
        bottomNavigationBar: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 30,
          ),
          child: ElevatedButton(
            style: startButtonStyle,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );
              }
              setState(() {
                
              });
            },
            child: const Text('Start'),
          ),
        ),
        ),
    );
  }
}

class _Button extends Container {
  final EdgeInsets buttonMargin = const EdgeInsets.all(5);
  final String text;
  final Function() onPressed;

  _Button(this.text, this.onPressed);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: FontConstants.text,
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
    );

    return Expanded(
      child: Container(
        margin: buttonMargin,
        child: ElevatedButton(
          style: style,
          onPressed: onPressed,
          child: Text(text),
        ),
      ),
    );
  }
}

class _GameSettings extends Container {
  final GameData data;

  _GameSettings(this.data);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final List<int> setOptions = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9];
    final List<int> legOptions = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9];

    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorScheme.primaryContainer,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Game",
              style: TextStyle(
                color: colorScheme.onPrimaryContainer,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Button('301', () {}),
              _Button('501', () {}),
              _Button('701', () {}),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Spacer(flex: 3),
              Text("Sets",
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                  )),
              const Spacer(flex: 1),
              DropdownButton(
                value: data.sets,
                items: setOptions.map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),

                onTap: () {
                  stderr.writeln('TEST');
                },
                onChanged: (v) {
                  stdout.writeln(v);
                  data.sets = v!;
                },
              ),
              const Spacer(flex: 3),
              Text("Legs",
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                  )),
              const Spacer(flex: 1),
              DropdownButton(
                value: legOptions.first.toString(),
                items: setOptions.map<DropdownMenuItem<String>>((int value) {
                  return DropdownMenuItem<String>(
                    value: value.toString(),
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (_) {},
              ),
              const Spacer(flex: 3),
            ],
          ),
        ],
      ),
    );
  }
}

class _InOutSettings extends StatelessWidget {
  const _InOutSettings();

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorScheme.primaryContainer,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("In",
              style: TextStyle(
                color: colorScheme.onPrimaryContainer,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Button('Single', () {}),
              _Button('Double', () {}),
              _Button('Master', () {}),
            ],
          ),
          const SizedBox(height: 10),
          Text("Out",
              style: TextStyle(
                color: colorScheme.onPrimaryContainer,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Button('Single', () {}),
              _Button('Double', () {}),
              _Button('Master', () {}),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlayerSettings extends StatelessWidget {
  const _PlayerSettings();

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: colorScheme.primaryContainer,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Player",
                    style: TextStyle(
                      color: colorScheme.onPrimaryContainer,
                    )),
              ],
            ),
            Expanded(
              child: Padding(
              padding: const EdgeInsets.all(10),
              child:  ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  Container(
                    height: 30,
                    child: const Text('Player01'),
                  ),
                  Container(
                    height: 30,
                    child: const Text('Player02'),
                  ),
                  Container(
                    height: 30,
                    child: const Text('Player02'),
                  ),
                  Container(
                    height: 30,
                    child: const Text('Player03'),
                  ),
                  Container(
                    height: 30,
                    child: const Text('Player04'),
                  ),
                  Container(
                    height: 30,
                    child: const Text('Player05'),
                  ),
                  Container(
                    height: 30,
                    child: const Text('Player06'),
                  ),
                ],
              ),
            ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
