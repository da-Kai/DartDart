import 'package:dart_dart/constants/color.dart';
import 'package:dart_dart/constants/fields.dart';
import 'package:dart_dart/constants/font.dart';
import 'package:dart_dart/game/x01/game.dart';
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
  final InputType inputType = InputType();

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
          _PointSelector(this, setState, inputType),
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
                  data.currentPlayer.name,
                  style: titleStyle,
                ),
                const Spacer(flex: 2),
                data.updatedPoints == 0
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

class _PointSelector extends Container {
  final _X01PageState state;
  final Function(Function()) setState;
  final InputType inputType;

  _PointSelector(this.state, this.setState, this.inputType);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    const Radius borderRadius = Radius.circular(20);

    void addSelection(hit) => state.thrown(hit);

    final ButtonStyle selectedButton = ElevatedButton.styleFrom(
      textStyle: FontConstants.text,
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
    );

    final ButtonStyle button = ElevatedButton.styleFrom(
      textStyle: FontConstants.text,
    );

    return StatefulBuilder(builder: (context, setState) {
      return Expanded(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topLeft: borderRadius, topRight: borderRadius),
                        color: colorScheme.primaryContainer,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(bottomLeft: borderRadius, bottomRight: borderRadius),
                      color: colorScheme.primaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Expanded(
                      child: inputType.isBoard ? _BoardSelect(state, addSelection) : _FieldSelect(state, addSelection),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      height: 55,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child:  ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  inputType.isBoard = true;
                                });
                                },
                              style: inputType.isBoard ? selectedButton : button,
                              child: const Text('BOARD'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child:  ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  inputType.isField = true;
                                });
                              },
                              style: inputType.isField ? selectedButton : button,
                              child: const Text('FIELD'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ],
        ),
      );
    });
  }
}

class _BoardSelect extends Container {
  final _X01PageState state;
  final _gestureKey = GlobalKey();
  final Function(Hit) addSelection;

  _BoardSelect(this.state, this.addSelection);

  @override
  EdgeInsetsGeometry? get padding => const EdgeInsets.symmetric(horizontal: 5.0);

  @override
  AlignmentGeometry? get alignment => Alignment.center;

  @override
  Widget? get child => ConstrainedBox(
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
        addSelection(field);
      },
      child: const Image(
        image: AssetImage('assets/images/dart_board-1024.png'),
        fit: BoxFit.contain,
      ),
    ),
  );
}

class _MultiplierButton extends Container {

  final Function(HitMultiplier) onPressed;
  final HitMultiplier hitMultiplier;

  _MultiplierButton({required this.onPressed, required this.hitMultiplier});

  @override
  Widget? get child => Expanded(
      child: Container(
        height: 50,
        margin: const EdgeInsets.all(2.5),
        padding: EdgeInsets.zero,
        child: ElevatedButton(
          onPressed: () => onPressed(hitMultiplier),
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            padding: EdgeInsets.zero,
          ),
          child: Text(hitMultiplier.text),
        ),
      )
  );
}

class _HitButton extends Container {

  final Function(Hit) onPressed;
  final HitNumber hitNum;
  final HitMultiplier hitMult;

  Hit get hit {
    return Hit.getFrom(hitNum, hitMult);
  }

  _HitButton({required this.onPressed, required this.hitMult, required this.hitNum});

  @override
  Widget? get child => Expanded(
      child: Container(
        height: 50,
        margin: const EdgeInsets.all(2.5),
        padding: EdgeInsets.zero,
        child: ElevatedButton(
          onPressed: () => onPressed(hit),
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            padding: EdgeInsets.zero,
          ),
          child: Text(
              hit.abbreviation,
          ),
        ),
      )
  );
}

class _FieldSelect extends Container {
  final _X01PageState state;
  final Function(Hit) addSelection;
  late final ColorScheme colorScheme;

  _FieldSelect(this.state, this.addSelection) {
    colorScheme = Theme.of(state.context).colorScheme;
  }

  @override
  Widget build(BuildContext context) {
    HitMultiplier hitMultiplier = HitMultiplier.single;

    return StatefulBuilder(builder: (context, setState) {

      void setHitMultiplier(HitMultiplier hm) {
        setState((){
          hitMultiplier = hm;
        });
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        alignment: Alignment.center,
        child: ConstrainedBox(
            constraints: const BoxConstraints.tightFor(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    _MultiplierButton(onPressed: setHitMultiplier, hitMultiplier: HitMultiplier.single),
                    _MultiplierButton(onPressed: setHitMultiplier, hitMultiplier: HitMultiplier.double),
                    _MultiplierButton(onPressed: setHitMultiplier, hitMultiplier: HitMultiplier.triple),
                  ],
                ),
                Divider(
                  color: colorScheme.scrim,
                  height: 15.0,
                  thickness: 1.5,
                ),
                Row(
                  children: [
                    _HitButton(onPressed: addSelection, hitMult: hitMultiplier, hitNum: HitNumber.one),
                    _HitButton(onPressed: addSelection, hitMult: hitMultiplier, hitNum: HitNumber.two),
                    _HitButton(onPressed: addSelection, hitMult: hitMultiplier, hitNum: HitNumber.three),
                    _HitButton(onPressed: addSelection, hitMult: hitMultiplier, hitNum: HitNumber.four),
                    _HitButton(onPressed: addSelection, hitMult: hitMultiplier, hitNum: HitNumber.five),
                  ],
                ),
                Row(
                  children: [
                    _HitButton(onPressed: addSelection, hitMult: hitMultiplier, hitNum: HitNumber.six),
                    _HitButton(onPressed: addSelection, hitMult: hitMultiplier, hitNum: HitNumber.seven),
                    _HitButton(onPressed: addSelection, hitMult: hitMultiplier, hitNum: HitNumber.eight),
                    _HitButton(onPressed: addSelection, hitMult: hitMultiplier, hitNum: HitNumber.nine),
                    _HitButton(onPressed: addSelection, hitMult: hitMultiplier, hitNum: HitNumber.ten),
                  ],
                ),
                Row(
                  children: [
                    _HitButton(onPressed: addSelection, hitMult: hitMultiplier, hitNum: HitNumber.eleven),
                    _HitButton(onPressed: addSelection, hitMult: hitMultiplier, hitNum: HitNumber.twelve),
                    _HitButton(onPressed: addSelection, hitMult: hitMultiplier, hitNum: HitNumber.thirteen),
                    _HitButton(onPressed: addSelection, hitMult: hitMultiplier, hitNum: HitNumber.fourteen),
                    _HitButton(onPressed: addSelection, hitMult: hitMultiplier, hitNum: HitNumber.fifteen),
                  ],
                ),
                Row(
                  children: [
                    _HitButton(onPressed: addSelection, hitMult: hitMultiplier, hitNum: HitNumber.sixteen),
                    _HitButton(onPressed: addSelection, hitMult: hitMultiplier, hitNum: HitNumber.seventeen),
                    _HitButton(onPressed: addSelection, hitMult: hitMultiplier, hitNum: HitNumber.eighteen),
                    _HitButton(onPressed: addSelection, hitMult: hitMultiplier, hitNum: HitNumber.nineteen),
                    _HitButton(onPressed: addSelection, hitMult: hitMultiplier, hitNum: HitNumber.twenty),
                  ],
                ),
                Row(
                  children: [
                    _HitButton(onPressed: addSelection, hitMult: hitMultiplier, hitNum: HitNumber.bullsEye),
                    _HitButton(onPressed: addSelection, hitMult: hitMultiplier, hitNum: HitNumber.miss),
                  ],
                ),
              ],
            )
        ),
      );
    });
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
