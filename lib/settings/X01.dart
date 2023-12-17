import 'package:dart_dart/constants/font.dart';
import 'package:flutter/material.dart';

enum InOut { single, double, master }

enum Games { threeOOne, fiveOOne, sevenOOne }

class X01 extends StatefulWidget {
  const X01({super.key});

  @override
  State<X01> createState() => _X01PageState();
}

class _X01PageState extends State<X01> {
  final _formKey = GlobalKey<FormState>();

  final List<int> _setOptions = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9];
  final List<int> _legOptions = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9];

  Games _points = Games.threeOOne;
  InOut _gameIn = InOut.single;
  InOut _gameOut = InOut.double;
  int _legs = 1;
  int _sets = 1;
  List<String> _players = [
    'Kai',
    'Player2',
    'Santiago Karl Loustaunau-Matos der 4te'
  ];

  void _updateSets(int set) {
    setState(() {
      _sets = set;
    });
  }

  void _updateLegs(int leg) {
    setState(() {
      _legs = leg;
    });
  }

  void _setPoints(Games game) {
    setState(() {
      _points = game;
    });
  }

  void _setGameIn(InOut gameIn) {
    setState(() {
      _gameIn = gameIn;
    });
  }

  void _setGameOut(InOut gameOut) {
    setState(() {
      _gameOut = gameOut;
    });
  }

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
          foregroundColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
          surfaceTintColor: colorScheme.onPrimary,
          title: const Text("X01-Game"),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            _GameSettingContainer(this),
            _InOutSettingContainer(this),
            _PlayerSettingContainer(this),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 10,
              ),
              child: ElevatedButton(
                style: startButtonStyle,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                  setState(() {});
                },
                child: const Text('Start'),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
        bottomNavigationBar: SizedBox(
          width: double.infinity,
          height: 25,
          child: Container(
            color: colorScheme.primary,
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
  final bool selected;

  _Button(this.text, this.onPressed, this.selected);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: FontConstants.text,
      backgroundColor: colorScheme.primary //
          .withOpacity(selected ? 1.0 : 0.4),
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

class _GameSettingContainer extends Container {
  final _X01PageState state;

  _GameSettingContainer(this.state);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

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
              _Button(
                '301',
                () => state._setPoints(Games.threeOOne),
                state._points == Games.threeOOne,
              ),
              _Button(
                '501',
                () => state._setPoints(Games.fiveOOne),
                state._points == Games.fiveOOne,
              ),
              _Button(
                '701',
                () => state._setPoints(Games.sevenOOne),
                state._points == Games.sevenOOne,
              ),
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
                value: state._sets,
                items:
                    state._setOptions.map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (v) {
                  state._updateSets(v!);
                },
              ),
              const Spacer(flex: 3),
              Text("Legs",
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                  )),
              const Spacer(flex: 1),
              DropdownButton(
                value: state._legs,
                items:
                    state._legOptions.map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (v) {
                  state._updateLegs(v!);
                },
              ),
              const Spacer(flex: 3),
            ],
          ),
        ],
      ),
    );
  }
}

class _InOutSettingContainer extends Container {
  final _X01PageState state;

  _InOutSettingContainer(this.state);

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
              _Button(
                'Single',
                () => state._setGameIn(InOut.single),
                state._gameIn == InOut.single,
              ),
              _Button(
                'Double',
                () => state._setGameIn(InOut.double),
                state._gameIn == InOut.double,
              ),
              _Button(
                'Master',
                () => state._setGameIn(InOut.master),
                state._gameIn == InOut.master,
              ),
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
              _Button(
                'Single',
                () => state._setGameOut(InOut.single),
                state._gameOut == InOut.single,
              ),
              _Button(
                'Double',
                () => state._setGameOut(InOut.double),
                state._gameOut == InOut.double,
              ),
              _Button(
                'Master',
                () => state._setGameOut(InOut.master),
                state._gameOut == InOut.master,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlayerSettingContainer extends Container {
  final _X01PageState state;

  _PlayerSettingContainer(this.state);

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
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: state._players.map<Row>((String player) {
                    return Row(
                      children: [
                        Expanded(
                          child: Text(player, overflow: TextOverflow.ellipsis),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.delete),
                        )
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                color: colorScheme.onPrimaryContainer,
                height: 0,
                thickness: 1,
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
