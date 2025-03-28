import 'package:dart_dart/logic/x01/settings.dart';
import 'package:dart_dart/pages/games/x01_game_page.dart';
import 'package:dart_dart/style/color.dart';
import 'package:dart_dart/style/font.dart';
import 'package:dart_dart/widget/x01/selection_row.dart';
import 'package:flutter/material.dart';

typedef Validator = (bool, String?) Function(String);

const playerNameMinLength = 2;
const playerNameMaxLength = 12;

class X01Setting extends StatefulWidget {
  final GameSettingFactory _data = GameSettingFactory();

  X01Setting({super.key});

  @override
  State<X01Setting> createState() => _X01PageState();
}

class _X01PageState extends State<X01Setting> {
  final _formKey = GlobalKey<FormState>();

  late GameSettingFactory _data;

  (bool, String?) validate(String playerName) {
    if (playerName.length < playerNameMinLength) {
      return (false, 'Name to short; min $playerNameMinLength characters');
    } else if (playerName.length > 12) {
      return (false, 'Name to long; max $playerNameMaxLength characters');
    } else if (!_data.isNameFree(playerName)) {
      return (false, 'Name already taken');
    }
    return (true, null);
  }

  bool _canAddPlayer() => _data.playerNames.length < maxPlayers;

  void _removePlayer(String ply) => setState(() => _data.playerNames.remove(ply));

  void _addPlayer(String player) => setState(() => _data.playerNames.add(player));

  void _updatePlayer(String oldName, String newName) => setState(() {
        int index = _data.playerNames.indexOf(oldName);
        _data.playerNames.insert(index, newName);
        _data.playerNames.removeAt(index + 1);
      });

  void reorderPlayers(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex--;
      }
      final movedPlayer = _data.playerNames.removeAt(oldIndex);
      _data.playerNames.insert(newIndex, movedPlayer);
    });
  }

  void _updateSets(int set) => setState(() => _data.sets = set);

  void _updateLegs(int leg) => setState(() => _data.legs = leg);

  void _setPoints(Games game) => setState(() => _data.game = game);

  void _setGameIn(InOut gameIn) => setState(() => _data.gameIn = gameIn);

  void _setGameOut(InOut gameOut) => setState(() => _data.gameOut = gameOut);

  @override
  Widget build(BuildContext context) {
    _data = widget._data;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: FontConstants.title.fontFamily,
            color: colorScheme.onPrimary,
          ),
          foregroundColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
          surfaceTintColor: colorScheme.onPrimary,
          title: const Text('X01-Game'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          child: OrientationBuilder(builder: (context, orientation) {
            return orientation == Orientation.portrait
                ? _PortraitView(this)
                : _LandscapeView(this);
          }),
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

class _PortraitView extends StatelessWidget {
  final _X01PageState state;

  const _PortraitView(this.state);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _GameSettingContainer(state),
        _InOutSettingContainer(state),
        Expanded(
          child: _PlayerSettingContainer(state),
        ),
        _StartButton(state),
      ],
    );
  }
}

class _LandscapeView extends StatelessWidget {
  final _X01PageState state;

  const _LandscapeView(this.state);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _GameSettingContainer(state),
                _InOutSettingContainer(state),
              ],
            ),
          ),
        ),
        Flexible(
          fit: FlexFit.tight,
          child: Column(
            children: [
              Expanded(
                child: _PlayerSettingContainer(state),
              ),
              _StartButton(state),
            ],
          ),
        ),
      ],
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
  bool canceled = false;

  _PlayerNameDialog(
      {required this.context, required this.validate, this.player}) {
    colorScheme = Theme.of(context).colorScheme;
    textController = TextEditingController(text: player);
  }

  Future<String?> open() async {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(player == null ? 'New Player' : 'Edit Player',
                textAlign: TextAlign.center),
            content: SingleChildScrollView(
              child: TextField(
                controller: textController,
                decoration:
                    InputDecoration(hintText: 'name', errorText: errorText),
              ),
            ),
            backgroundColor: colorScheme.backgroundShade,
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              MaterialButton(
                color: colorScheme.error,
                textColor: colorScheme.onError,
                child: const Text('CANCEL'),
                onPressed: () {
                  canceled = true;
                  Navigator.pop(context);
                },
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
      if (canceled) return null;
      var nextPly = textController.value.text;
      var (valid, _) = validate(nextPly);
      return valid ? nextPly : null;
    });
  }
}

class _GameSettingContainer extends StatelessWidget {
  final _X01PageState state;

  const _GameSettingContainer(this.state);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final GameSettingFactory settings = state.widget._data;

    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      textStyle: FontConstants.text,
      disabledBackgroundColor: colorScheme.primary,
      disabledForegroundColor: colorScheme.onPrimary,
      padding: EdgeInsets.zero,
    );

    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorScheme.backgroundShade,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Game', style: FontConstants.subtitle),
          SelectionRow(
            values: const <String, Games>{
              '301': Games.threeOOne,
              '501': Games.fiveOOne,
              '701': Games.sevenOOne,
            },
            setState: state._setPoints,
            getState: () => settings.game,
            expanded: true,
            buttonStyle: buttonStyle,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Spacer(flex: 3),
              Text('Sets',
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                  )),
              const Spacer(flex: 1),
              DropdownButton(
                value: settings.sets,
                items: GameSettings.setOptions
                    .map<DropdownMenuItem<int>>((int value) {
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
              Text('Legs',
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                  )),
              const Spacer(flex: 1),
              DropdownButton(
                value: settings.legs,
                items: GameSettings.setOptions
                    .map<DropdownMenuItem<int>>((int value) {
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

class _InOutSettingContainer extends StatelessWidget {
  final _X01PageState state;

  const _InOutSettingContainer(this.state);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      textStyle: FontConstants.text,
      disabledBackgroundColor: colorScheme.primary,
      disabledForegroundColor: colorScheme.onPrimary,
      padding: EdgeInsets.zero,
    );

    final TextStyle textStyle =
        FontConstants.subtitle.copyWith(color: colorScheme.onPrimaryContainer);

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorScheme.backgroundShade,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('In', style: textStyle),
          SelectionRow(
            values: const <String, InOut>{
              'Straight': InOut.straight,
              'Double': InOut.double,
              'Master': InOut.master,
            },
            setState: state._setGameIn,
            getState: () => state._data.gameIn,
            expanded: true,
            buttonStyle: buttonStyle,
          ),
          Text('Out', style: textStyle),
          SelectionRow(
            values: const <String, InOut>{
              'Straight': InOut.straight,
              'Double': InOut.double,
              'Master': InOut.master,
            },
            setState: state._setGameOut,
            getState: () => state._data.gameOut,
            expanded: true,
            buttonStyle: buttonStyle,
          ),
        ],
      ),
    );
  }
}

class _PlayerSettingContainer extends StatelessWidget {
  final _X01PageState state;

  const _PlayerSettingContainer(this.state);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    IconButton getAddButton() {
      if (state._canAddPlayer()) {
        return IconButton(
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
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          icon: Icon(
            Icons.add,
            color: colorScheme.onPrimaryContainer,
          ),
        );
      } else {
        return IconButton(
          onPressed: null,
          icon: Icon(
            Icons.block,
            color: colorScheme.onPrimaryContainer.withAlpha(127),
          ),
        );
      }
    }

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorScheme.backgroundShade,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Player',
                style: FontConstants.subtitle
                    .copyWith(color: colorScheme.onPrimaryContainer),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ReorderableListView(
                onReorder: state.reorderPlayers,
                children: [
                  for (final player in state._data.playerNames)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      key: ValueKey(player),
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                            icon: const Icon(Icons.edit_rounded),
                            color: colorScheme.onPrimaryContainer,
                            iconSize: 20,
                            visualDensity: VisualDensity.compact,
                          ),
                          IconButton(
                            onPressed: () {
                              state._removePlayer(player);
                            },
                            icon: const Icon(Icons.close_rounded),
                            color: colorScheme.onPrimaryContainer,
                            iconSize: 24,
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                      title: Text(
                        player,
                        overflow: TextOverflow.ellipsis,
                        style: colorScheme.getTextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      trailing: ReorderableDragStartListener(
                        index: state._data.playerNames.indexOf(player),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 20.0),
                          color: Colors.transparent,
                          child: Icon(
                            Icons.drag_handle,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getAddButton()
            ],
          ),
        ],
      ),
    );
  }
}

class _StartButton extends StatelessWidget {
  final _X01PageState state;

  const _StartButton(this.state);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final ButtonStyle startButtonStyle = ElevatedButton.styleFrom(
      textStyle: FontConstants.text,
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
    );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 10,
      ),
      child: ElevatedButton(
        style: startButtonStyle,
        onPressed: state._data.playerNames.isEmpty
            ? null
            : () {
                if (state._formKey.currentState!.validate()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => //
                            X01Game(settings: state._data.get())
                    ),
                  );
                }
              },
        child: const Text('Start'),
      ),
    );
  }
}
