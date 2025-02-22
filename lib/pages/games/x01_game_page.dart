import 'package:dart_dart/logic/common/style_meta.dart';
import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/game.dart';
import 'package:dart_dart/logic/x01/player.dart';
import 'package:dart_dart/logic/x01/settings.dart';
import 'package:dart_dart/pages/games/x01_game_statistics.dart';
import 'package:dart_dart/style/color.dart';
import 'package:dart_dart/style/font.dart';
import 'package:dart_dart/widget/x01/point_selector.dart';
import 'package:flutter/material.dart';

class X01Game extends StatefulWidget {
  late final GameController data;

  X01Game({super.key, required List<String> player, required GameSettings settings}) {
    data = GameController(player, settings);
  }

  @override
  State<X01Game> createState() => _X01PageState();
}

class _X01PageState extends State<X01Game> {
  void thrown(Hit hit) {
    setState(() {
      widget.data.onThrow(hit);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final GameController data = widget.data;

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
                ),
                IconButton(
                  icon: const Icon(Icons.redo),
                  onPressed: data.canRedo
                      ? () {
                          setState(() {
                            data.redo();
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
            ));
  }
}

class _PortraitView extends StatelessWidget {
  final _X01PageState state;
  final Function update;

  const _PortraitView(this.state, this.update);

  @override
  Widget build(BuildContext context) {
    final GameController data = state.widget.data;

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
            data.onThrow(hit);
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
    final GameController data = state.widget.data;

    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              PointSelector(onSelect: ((hit) {
                update(() {
                  data.onThrow(hit);
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
    final PlayerData data = state.widget.data.playerData;

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
              children: data.mapPlayer<Container>((ply) {
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
              }, skip: 1).toList()),
        ))
      ],
    );
  }
}

class _ThrowBean extends StatelessWidget {
  final double fontSize = 18;

  final String text;
  final String tooltip;
  final Placement placement;

  const _ThrowBean({required this.text, required this.tooltip, required this.placement});

  BorderRadius getBorderRadius() {
    switch (placement) {
      case Placement.center:
        return BorderRadius.circular(5);
      case Placement.leftEnd:
        return BorderRadius.horizontal(left: Radius.circular(20), right: Radius.circular(5));
      case Placement.rightEnd:
        return BorderRadius.horizontal(right: Radius.circular(20), left: Radius.circular(5));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final tooltipStyle = colorScheme.getTextStyle(
      fontSize: fontSize,
      color: colorScheme.onPrimary.withAlpha(102),
      fontStyle: FontStyle.italic,
    );

    final textStyle = colorScheme.getTextStyle(color: colorScheme.onPrimary, fontSize: fontSize);

    return Container(
      decoration: BoxDecoration(
        borderRadius: getBorderRadius(),
        color: colorScheme.primary,
      ),
      padding: const EdgeInsets.all(3),
      margin: const EdgeInsets.all(5),
      alignment: Alignment.center,
      child: Text(
        text.isNotEmpty ? text : tooltip,
        style: text.isNotEmpty ? textStyle : tooltipStyle,
      ),
    );
  }
}

class _CurrentPlayer extends StatelessWidget {
  final _X01PageState state;
  late final GameController game;

  _CurrentPlayer(this.state) {
    game = state.widget.data;
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

    final TextStyle scoreStyle = titleStyle.copyWith(
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
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
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0, bottom: 5.0),
            child: Row(
              children: [
                const Spacer(flex: 1),
                Text(
                  game.curPly.name,
                  style: titleStyle,
                ),
                Text(
                  game.curPoints,
                  style: scoreStyle,
                ),
                const Spacer(flex: 2),
                game.curTurn.isCheckout
                    ? //
                    Icon(Icons.check, color: colorScheme.success)
                    : //
                    Text(
                        game.curTurn.score.toString(),
                        style: titleStyle.copyWith(
                            color: game.curTurn.valid //
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
                  child: _ThrowBean(
                    text: '${game.curTurn.first}',
                    tooltip: game.checkout.first,
                    placement: Placement.leftEnd,
                  ),
                ),
                Expanded(
                  child: _ThrowBean(
                    text: '${game.curTurn.second}',
                    tooltip: game.checkout.second,
                    placement: Placement.center,
                  ),
                ),
                Expanded(
                  child: _ThrowBean(
                    text: '${game.curTurn.third}',
                    tooltip: game.checkout.third,
                    placement: Placement.rightEnd,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
    final GameController data = state.widget.data;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ElevatedButton(
        onPressed: !data.curTurn.done
            ? null
            : () {
                update(() {
                  data.next();
                });
                if (data.hasGameEnded) {
                  update(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => //
                          X01Statistics(stats: data.getStats(), settings: data.settings)
                    ));
                  });
                }
              },
        style: ElevatedButton.styleFrom(
          textStyle: FontConstants.text,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),
        child: data.hasGameEnded? const Text('end') : const Text('next'),
      ),
    );
  }
}
