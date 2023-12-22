import 'package:dart_dart/constants/color.dart';
import 'package:dart_dart/constants/font.dart';
import 'package:dart_dart/game/x01/game.site.dart';
import 'package:dart_dart/game/x01/settings.dart';
import 'package:flutter/material.dart';

typedef Validator = (bool, String?) Function(String);

class X01Setting extends StatefulWidget {
  final GameSettings _data = GameSettings();

  X01Setting({super.key});

  @override
  State<X01Setting> createState() => _X01PageState();
}

class _X01PageState extends State<X01Setting> {
  final _formKey = GlobalKey<FormState>();

  late GameSettings _data;

  (bool, String?) validate(String playerName) {
    if (playerName.length < 3) {
      return (false, 'Name to short');
    } else if (playerName.length > 24) {
      return (false, 'Name to long');
    } else if (!_data.isNameFree(playerName)) {
      return (false, 'Name already taken');
    }
    return (true, null);
  }

  void _removePlayer(String ply) => setState(() => _data.players.remove(ply));

  void _addPlayer(String player) => setState(() => _data.players.add(player));

  void _updatePlayer(String oldName, String newName) => setState(() {
        int index = _data.players.indexOf(oldName);
        _data.players.insert(index, newName);
        _data.players.removeAt(index + 1);
      });

  //void _updateSets(int set) => setState(() => _data.sets = set);

  //void _updateLegs(int leg) => setState(() => _data.legs = leg);

  void _setPoints(Games game) => setState(() => _data.game = game);

  void _setGameIn(InOut gameIn) => setState(() => _data.gameIn = gameIn);

  void _setGameOut(InOut gameOut) => setState(() => _data.gameOut = gameOut);

  @override
  Widget build(BuildContext context) {
    _data = widget._data;
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
                onPressed: _data.players.isEmpty
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => X01Game(settings: _data)),
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

class _PlayerNameDialog {
  final String? player;
  final BuildContext context;
  final Validator validate;

  late final ColorScheme colorScheme;
  late final TextEditingController textController;

  String? errorText;

  _PlayerNameDialog({required this.context, required this.validate, this.player}) {
    colorScheme = Theme.of(context).colorScheme;
    textController = TextEditingController(text: player);
  }

  Future<String?> open() async {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(player == null ? 'New Player' : 'Edit Player', textAlign: TextAlign.center),
            content: TextField(
              controller: textController,
              decoration: InputDecoration(hintText: "name", errorText: errorText),
            ),
            backgroundColor: colorScheme.primaryContainer,
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              MaterialButton(
                color: colorScheme.error,
                textColor: colorScheme.onError,
                child: const Text('CANCEL'),
                onPressed: () => Navigator.pop(context),
              ),
              MaterialButton(
                color: colorScheme.primary,
                textColor: colorScheme.onPrimary,
                child: const Text('OK'),
                onPressed: () {
                  var nextPlayer = textController.value.text;
                  var (valid, errMsg) = validate(nextPlayer);
                  if (valid) {
                    setState(() {
                      errorText = '';
                      Navigator.pop(context);
                    });
                  } else {
                    setState(() => errorText = errMsg);
                  }
                },
              ),
            ],
          );
        });
      },
    ).then((value) {
      var nextPly = textController.value.text;
      var (valid, _) = validate(nextPly);
      return valid ? nextPly : null;
    });
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
    final GameSettings settings = state.widget._data;

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
              style: FontConstants.subtitle.copyWith(
                color: colorScheme.onPrimaryContainer
              ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Button(
                '301',
                () => state._setPoints(Games.threeOOne),
                settings.game == Games.threeOOne,
              ),
              _Button(
                '501',
                () => state._setPoints(Games.fiveOOne),
                settings.game == Games.fiveOOne,
              ),
              _Button(
                '701',
                () => state._setPoints(Games.sevenOOne),
                settings.game == Games.sevenOOne,
              ),
            ],
          ),

          /*

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
                value: settings.sets,
                items: GameSettings.setOptions.map<DropdownMenuItem<int>>((int value) {
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
                value: settings.legs,
                items: GameSettings.setOptions.map<DropdownMenuItem<int>>((int value) {
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

           */
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
            style: FontConstants.subtitle.copyWith(
                color: colorScheme.onPrimaryContainer
            ),
          ),
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
          Text("Out",
            style: FontConstants.subtitle.copyWith(
                color: colorScheme.onPrimaryContainer
            ),
          ),
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
                  style: FontConstants.subtitle.copyWith(
                      color: colorScheme.onPrimaryContainer
                  ),
                ),
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
                            style: colorScheme.getTextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _PlayerNameDialog(
                              context: context,
                              player: player,
                              validate: state.validate,
                            ).open().then((newPly) {
                              if (newPly != null) {
                                state._updatePlayer(player, newPly);
                              }
                            });
                          },
                          icon: const Icon(Icons.edit),
                          color: colorScheme.onPrimaryContainer,
                          iconSize: 22,
                          visualDensity: VisualDensity.compact,
                        ),
                        IconButton(
                          onPressed: () {
                            state._removePlayer(player);
                          },
                          icon: const Icon(Icons.delete),
                          color: colorScheme.onPrimaryContainer,
                          iconSize: 22,
                          visualDensity: VisualDensity.compact,
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
                    _PlayerNameDialog(
                      context: context,
                      validate: state.validate,
                    ).open().then((newPly) {
                      if (newPly != null) {
                        state._addPlayer(newPly);
                      }
                    });
                  },
                  icon: Icon(Icons.add, color: colorScheme.onPrimaryContainer,),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
