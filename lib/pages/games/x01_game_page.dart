import 'package:dart_dart/style/color.dart';
import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/style/font.dart';
import 'package:dart_dart/logic/x01/x01_game.dart';
import 'package:dart_dart/widget/x01/point_selector.dart';
import 'package:flutter/material.dart';

class X01Game extends StatefulWidget {
  late final GameData data;

  X01Game({super.key, required settings}) {
    data = GameData(settings);
  }

  @override
  State<X01Game> createState() => _X01PageState();
}

class _X01PageState extends State<X01Game> {
  void thrown(Hit hit) {
    setState(() {
      widget.data.currentRound.throws.thrown(hit);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final GameData data = widget.data;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: FontConstants.title.fontFamily,
          color: colorScheme.onBackground,
        ),
        backgroundColor: colorScheme.background,
        title: Text(data.settings.game.text),
        leading: IconButton(
          onPressed: () {
            _CancelGame.open(context).then((quit) {
              if (quit) {
                setState(() {
                  Navigator.pop(context);
                });
              }
            });
          },
          icon: const Icon(Icons.close),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: data.canUndo
                ? () {
                    setState(() {
                      data.undo();
                    });
                  }
                : null,
          )
        ],
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        return orientation == Orientation.portrait
            ? //
            _PortraitView(this, setState)
            : //
            _LandscapeView(this, setState);
      }),
    );
  }
}

class _PortraitView extends StatelessWidget {
  final _X01PageState state;
  final Function update;

  const _PortraitView(this.state, this.update);

  @override
  Widget build(BuildContext context) {
    final GameData data = state.widget.data;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Visibility(
          visible: data.isMultiPlayer,
          child: _PlayersList(state),
        ),
        _CurrentPlayer(state),
        PointSelector(onSelect: ((hit) {
          update(() {
            data.currentRound.throws.thrown(hit);
          });
        })),
        _NextButton(state, update),
      ],
    );
  }
}

class _LandscapeView extends StatelessWidget {
  final _X01PageState state;
  final Function update;

  const _LandscapeView(this.state, this.update);

  @override
  Widget build(BuildContext context) {
    final GameData data = state.widget.data;

    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              PointSelector(onSelect: ((hit) {
                update(() {
                  data.currentRound.throws.thrown(hit);
                });
              })),
            ],
          ),
        ),
        Expanded(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Visibility(
              visible: data.isMultiPlayer,
              child: _PlayersList(state),
            ),
            _CurrentPlayer(state),
            const Spacer(),
            _NextButton(state, update),
          ]),
        ),
      ],
    );
  }
}

class _PlayersList extends StatelessWidget {
  final _X01PageState state;

  const _PlayersList(this.state);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final GameData data = state.widget.data;

    return Row(
      children: <Widget>[
        Expanded(
            child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: colorScheme.backgroundShade,
          ),
          height: 50,
          child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: data.otherPlayer.map<Container>((ply) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: colorScheme.primary,
                  ),
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          ply.name,
                          overflow: TextOverflow.ellipsis,
                          style: FontConstants.text.copyWith(
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 35,
                        child: Text(
                          ply.score.toString(),
                          style: FontConstants.text.copyWith(color: colorScheme.onPrimary),
                        ),
                      ),
                    ],
                  ),
                );
              }).followedBy(data.finishedPlayer.map<Container>((ply) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: colorScheme.success,
                  ),
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(ply.name, overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(width: 30, child: Icon(Icons.check)),
                    ],
                  ),
                );
              })).toList()),
        ))
      ],
    );
  }
}

class _ThrowBean extends StatelessWidget {
  final String text;

  const _ThrowBean({required this.text});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorScheme.primary,
      ),
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }
}

class _CurrentPlayer extends StatelessWidget {
  final _X01PageState state;
  late final ActiveRound currentRound;

  _CurrentPlayer(this.state) {
    currentRound = state.widget.data.currentRound;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final TextStyle titleStyle = TextStyle(
      color: colorScheme.onPrimaryContainer,
      fontSize: 24,
      fontFamily: FontConstants.subtitle.fontFamily,
      fontWeight: FontWeight.bold,
    );

    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorScheme.backgroundShade,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
            child: Row(
              children: [
                const Spacer(flex: 1),
                Text(
                  currentRound.player.name,
                  style: titleStyle,
                ),
                const Spacer(flex: 2),
                currentRound.updatedScore == 0 && currentRound.isLegal
                    ? //
                    Icon(Icons.check, color: colorScheme.success)
                    : //
                    Text(
                        currentRound.text,
                        style: titleStyle.copyWith(
                            color: currentRound.isLegal //
                                ? colorScheme.onPrimaryContainer //
                                : colorScheme.error),
                      ),
                const Spacer(flex: 1),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: _ThrowBean(text: '${currentRound.throws.first}'),
                ),
                Expanded(
                  child: _ThrowBean(text: '${currentRound.throws.second}'),
                ),
                Expanded(
                  child: _ThrowBean(text: '${currentRound.throws.third}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GameEnd {
  final String winner;
  final BuildContext context;

  late final ColorScheme colorScheme;

  _GameEnd({required this.context, required this.winner}) {
    colorScheme = Theme.of(context).colorScheme;
  }

  Future<bool> open() async {
    bool rematch = false;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Congratulations',
          textAlign: TextAlign.center,
          style: FontConstants.subtitle,
        ),
        content: Text(
          '"$winner" won!',
          textAlign: TextAlign.center,
          style: FontConstants.text,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          MaterialButton(
            color: colorScheme.primary,
            textColor: colorScheme.onPrimary,
            child: const Text('REMATCH'),
            onPressed: () {
              rematch = true;
              Navigator.pop(context);
            },
          ),
          MaterialButton(
            color: colorScheme.primary,
            textColor: colorScheme.onPrimary,
            child: const Text('QUIT'),
            onPressed: () {
              rematch = false;
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ).then((_) => rematch);
  }
}

class _CancelGame {
  _CancelGame._();

  static Future<bool> open(BuildContext context) async {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    bool quit = false;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'End the Game?',
          textAlign: TextAlign.center,
          style: FontConstants.subtitle,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          MaterialButton(
            color: colorScheme.error,
            textColor: colorScheme.onError,
            child: const Text('END'),
            onPressed: () {
              quit = true;
              Navigator.pop(context);
            },
          ),
          MaterialButton(
            color: colorScheme.primary,
            textColor: colorScheme.onPrimary,
            child: const Text('CONTINUE'),
            onPressed: () {
              quit = false;
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ).then((_) => quit);
  }
}

class _NextButton extends StatelessWidget {
  final _X01PageState state;
  final Function update;

  const _NextButton(this.state, this.update);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final GameData data = state.widget.data;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ElevatedButton(
        onPressed: !data.currentRound.hasEnded
            ? null
            : () {
                update(() {
                  data.next();
                });
                if (data.hasGameFinished()) {
                  var ply = data.winner;
                  _GameEnd(context: context, winner: ply?.name ?? '')
                      .open() //
                      .then((rematch) {
                    update(() {
                      if (rematch) {
                        data.reset();
                      } else {
                        Navigator.pop(context);
                      }
                    });
                  });
                }
              },
        style: ElevatedButton.styleFrom(
          textStyle: FontConstants.text,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),
        child: const Text('next'),
      ),
    );
  }
}
