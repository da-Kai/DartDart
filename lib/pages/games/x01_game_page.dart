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
      widget.data.curThrows.thrown(hit);
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
            setState(() {
              Navigator.pop(context);
            });
          },
          icon: const Icon(Icons.close),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: () {
              setState(() {
                data.curThrows.undo();
              });
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Visibility(
            visible: data.isMultiPlayer,
            child: _PlayersList(this),
          ),
          _CurrentPlayer(this),
          PointSelector(onSelect: thrown),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(
              bottom: 5,
              left: 10,
              right: 10,
            ),
            child: ElevatedButton(
              onPressed: !data.turnDone()
                  ? null
                  : () {
                      var done = false;
                      var ply = data.currentPlayer.name;
                      setState(() {
                        data.curPlyApply(data.curThrows);
                        done = data.currentPlayer.done;
                        data.next();
                      });
                      if (done) {
                        _GameEnd(context: context, winner: ply)
                            .open() //
                            .then((rematch) {
                          setState(() {
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
          ),
        ],
      ),
    );
  }
}

class _PlayersList extends Container {
  final _X01PageState state;

  _PlayersList(this.state);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final GameData data = state.widget.data;

    return Row(
      children: <Widget>[
        Expanded(
            child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: colorScheme.primaryContainer,
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
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                        width: 30,
                        child: Text(
                          ply.points.toString(),
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

class _ThrowBean extends Container {
  final String text;

  _ThrowBean({required this.text});

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

class _CurrentPlayer extends Container {
  final _X01PageState state;

  _CurrentPlayer(this.state);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final GameData data = state.widget.data;

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
                  data.currentPlayer.name,
                  style: titleStyle,
                ),
                const Spacer(flex: 2),
                data.updatedPoints == 0 && data.stillLegal
                    ? //
                    Icon(Icons.check, color: colorScheme.success)
                    : //
                    Text(
                        data.currentPlayerUpdateText(),
                        style: titleStyle.copyWith(
                            color: data.stillLegal //
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
                  child: _ThrowBean(text: '${data.curThrows.first}'),
                ),
                Expanded(
                  child: _ThrowBean(text: '${data.curThrows.second}'),
                ),
                Expanded(
                  child: _ThrowBean(text: '${data.curThrows.third}'),
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
