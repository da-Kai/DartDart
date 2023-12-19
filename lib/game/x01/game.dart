import 'package:dart_dart/constants/fields.dart';
import 'package:dart_dart/constants/font.dart';
import 'package:dart_dart/game/x01/gamedata.dart';
import 'package:flutter/material.dart';

class X01Game extends StatefulWidget {
  final GameData? data;

  const X01Game({super.key, this.data});

  @override
  State<X01Game> createState() => _X01PageState();
}

class _X01PageState extends State<X01Game> {
  final _formKey = GlobalKey<FormState>();

  void thrown(Hit hit) {
    setState(() {
      if (widget.data != null) {
        widget.data!.curThrows.thrown(hit);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final GameData data = widget.data!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: FontConstants.title.fontFamily,
        ),
        backgroundColor: colorScheme.background,
        title: Text(data.settings.points.text),
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
          Visibility(
            visible: data.otherPlayer.isNotEmpty,
            child: _PlayersList(this),
          ),
          _CurrentPlayer(this),
          _PointSelector(this),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            child: ElevatedButton(
              onPressed: () {
                if (data.turnDone()) {
                  setState(() {
                    data.curPlyApply(widget.data!.curThrows);
                    data.next();
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
    final GameData data = state.widget.data!;

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
                        child: Text(ply.name, overflow: TextOverflow.ellipsis),
                      ),
                      SizedBox(
                        width: 30,
                        child: Text(ply.points.toString()),
                      ),
                    ],
                  ),
                );
              }).toList()),
        ))
      ],
    );
  }
}

class _ThrowBean extends Container {
  final Widget child;

  _ThrowBean({required this.child});

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
      child: child,
    );
  }
}

class _CurrentPlayer extends Container {
  final _X01PageState state;

  _CurrentPlayer(this.state);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final GameData data = state.widget.data!;

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
        color: colorScheme.primaryContainer,
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
                  data.currentPlayer!.name,
                  style: titleStyle,
                ),
                const Spacer(flex: 2),
                Text(
                  data.currentPlayerUpdateText(),
                  style: titleStyle.copyWith(
                    color: data.stillLegal //
                        ? data.updatedPoints == 0 //
                          ? colorScheme.tertiary //
                          : colorScheme.onPrimaryContainer //
                        : colorScheme.error
                  ),
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
                    child: Text(
                      data.curThrows.first?.toString() ?? '',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Expanded(
                  child: _ThrowBean(
                    child: Text(
                      data.curThrows.second?.toString() ?? '',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Expanded(
                  child: _ThrowBean(
                    child: Text(
                      data.curThrows.third?.toString() ?? '',
                      style: const TextStyle(fontSize: 20),
                    ),
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

class _PointSelector extends Container {
  final _X01PageState state;
  final _gestureKey = GlobalKey();

  _PointSelector(this.state);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final GameData data = state.widget.data!;

    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: colorScheme.primaryContainer,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: ConstrainedBox(
              constraints: const BoxConstraints.tightFor(),
              child: GestureDetector(
                key: _gestureKey,
                onTapUp: (details) {
                  var size = _gestureKey.currentContext!.size!;
                  var pos = details.localPosition;

                  var norm = GameMath.norm(size, pos);
                  var (distance, angle) = GameMath.vectorData(norm);

                  if (distance > 101) return;

                  var field = FieldCalc.getField(angle: angle, distance: distance);
                  state.thrown(field);
                },
                child: const Image(
                  image: AssetImage("assets/images/dart_board-1024.png"),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
