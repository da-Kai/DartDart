import 'package:dart_dart/constants/font.dart';
import 'package:dart_dart/game/x01/game.dart';
import 'package:flutter/material.dart';

import 'gamedata.dart';

class X01Setting extends StatefulWidget {
  const X01Setting({super.key});

  @override
  State<X01Setting> createState() => _X01PageState();
}

class _X01PageState extends State<X01Setting> {
  final _formKey = GlobalKey<FormState>();

  final List<int> _setOptions = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9];
  final List<int> _legOptions = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9];

  final GameSettings _data = GameSettings();

  Future<void> _displayTextInputDialog(BuildContext context, {String player = ''}) async {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    String nextPlayer = player;

    errorMsg(str) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(str, style: TextStyle(color: colorScheme.onError)),
              backgroundColor: colorScheme.error,
              duration: const Duration(milliseconds: 500)),
        );

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(player.isEmpty ? 'New Player' : 'Edit Player', textAlign: TextAlign.center),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  nextPlayer = value;
                });
              },
              controller: TextEditingController(text: nextPlayer),
              decoration: const InputDecoration(hintText: "Playername"),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              MaterialButton(
                color: colorScheme.error,
                textColor: colorScheme.onError,
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              MaterialButton(
                color: colorScheme.primary,
                textColor: colorScheme.onPrimary,
                child: const Text('OK'),
                onPressed: () {
                  if (nextPlayer.length < 3) {
                    errorMsg('Name to short');
                  } else if (nextPlayer.length > 24) {
                    errorMsg('Name to long');
                  } else if (player == nextPlayer) {
                    setState(() {
                      Navigator.pop(context);
                    });
                  } else if (_data.players.contains(nextPlayer)) {
                    errorMsg('Name already taken');
                  } else {
                    setState(() {
                      if (player != '') {
                        _data.players.remove(player);
                      }
                      _data.players.add(nextPlayer);
                      Navigator.pop(context);
                    });
                  }
                },
              ),
            ],
          );
        });
  }

  void _removePlayer(String ply) {
    setState(() {
      _data.players.remove(ply);
    });
  }

  void _updateSets(int set) {
    setState(() {
      _data.sets = set;
    });
  }

  void _updateLegs(int leg) {
    setState(() {
      _data.legs = leg;
    });
  }

  void _setPoints(Games game) {
    setState(() {
      _data.points = game;
    });
  }

  void _setGameIn(InOut gameIn) {
    setState(() {
      _data.gameIn = gameIn;
    });
  }

  void _setGameOut(InOut gameOut) {
    setState(() {
      _data.gameOut = gameOut;
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
        resizeToAvoidBottomInset: false,
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
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.question_mark),
            ),
          ],
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => X01Game(data: GameData(_data))),
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
                state._data.points == Games.threeOOne,
              ),
              _Button(
                '501',
                () => state._setPoints(Games.fiveOOne),
                state._data.points == Games.fiveOOne,
              ),
              _Button(
                '701',
                () => state._setPoints(Games.sevenOOne),
                state._data.points == Games.sevenOOne,
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
                value: state._data.sets,
                items: state._setOptions.map<DropdownMenuItem<int>>((int value) {
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
                value: state._data.legs,
                items: state._legOptions.map<DropdownMenuItem<int>>((int value) {
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
                state._data.gameIn == InOut.single,
              ),
              _Button(
                'Double',
                () => state._setGameIn(InOut.double),
                state._data.gameIn == InOut.double,
              ),
              _Button(
                'Master',
                () => state._setGameIn(InOut.master),
                state._data.gameIn == InOut.master,
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
                state._data.gameOut == InOut.single,
              ),
              _Button(
                'Double',
                () => state._setGameOut(InOut.double),
                state._data.gameOut == InOut.double,
              ),
              _Button(
                'Master',
                () => state._setGameOut(InOut.master),
                state._data.gameOut == InOut.master,
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
                  children: state._data.players.map<Row>((String player) {
                    return Row(
                      children: [
                        Expanded(
                          child: Text(
                            player,
                            overflow: TextOverflow.ellipsis,
                            style: FontConstants.text.copyWith(fontSize: 15),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            state._displayTextInputDialog(context, player: player);
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            state._removePlayer(player);
                          },
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
                  onPressed: () {
                    state._displayTextInputDialog(context);
                  },
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
