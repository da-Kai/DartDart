import 'dart:async';
import 'package:dart_dart/logic/constant/fields.dart';
import 'package:flutter/material.dart';

class FieldSelect extends StatefulWidget {
  final Function(Hit) onSelect;

  const FieldSelect({super.key, required this.onSelect});

  @override
  State<StatefulWidget> createState() => _FieldSelectState();
}

class _FieldSelectState extends State<FieldSelect> {
  HitMultiplier hitMultiplier = HitMultiplier.single;
  bool isMultiplierLocked = false;
  HitMultiplier? lockedMultiplier;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      padding: EdgeInsets.zero,
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
    );

    final List<List<HitNumber>> hitNumbers = [
      [
        HitNumber.one,
        HitNumber.two,
        HitNumber.three,
        HitNumber.four,
        HitNumber.five
      ],
      [
        HitNumber.six,
        HitNumber.seven,
        HitNumber.eight,
        HitNumber.nine,
        HitNumber.ten
      ],
      [
        HitNumber.eleven,
        HitNumber.twelve,
        HitNumber.thirteen,
        HitNumber.fourteen,
        HitNumber.fifteen
      ],
      [
        HitNumber.sixteen,
        HitNumber.seventeen,
        HitNumber.eighteen,
        HitNumber.nineteen,
        HitNumber.twenty
      ],
      [HitNumber.bull, HitNumber.miss],
    ];

  void setHitMultiplier(HitMultiplier hm) {
    setState(() {
      if (!isMultiplierLocked) {
        hitMultiplier = hm;
      }
    });
  }

    void toggleMultiplierLock(HitMultiplier hm) {
      setState(() {
        if (isMultiplierLocked) {
          // If already locked, unlock and switch to new multiplier
          isMultiplierLocked = false;
          lockedMultiplier = null;
          hitMultiplier = hm;
        } else {
          // If not locked, lock the new multiplier
          isMultiplierLocked = true;
          hitMultiplier = hm;
          lockedMultiplier = hm;
        }
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
                  _MultiplierButton(
                    style: buttonStyle,
                    onPressed: setHitMultiplier,
                    onDoubleTap: toggleMultiplierLock,
                    hitMultiplier: HitMultiplier.single,
                    current: hitMultiplier,
                    isLocked: isMultiplierLocked && lockedMultiplier == HitMultiplier.single,
                  ),
                  _MultiplierButton(
                    style: buttonStyle,
                    onPressed: setHitMultiplier,
                    onDoubleTap: toggleMultiplierLock,
                    hitMultiplier: HitMultiplier.double,
                    current: hitMultiplier,
                    isLocked: isMultiplierLocked && lockedMultiplier == HitMultiplier.double,
                  ),
                  _MultiplierButton(
                    style: buttonStyle,
                    onPressed: setHitMultiplier,
                    onDoubleTap: toggleMultiplierLock,
                    hitMultiplier: HitMultiplier.triple,
                    current: hitMultiplier,
                    isLocked: isMultiplierLocked && lockedMultiplier == HitMultiplier.triple,
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
              Row(),
              for (final hitnumer in hitNumbers)
                Row(
                  children: [
                    for (final hitNum in hitnumer)
                      HitButton(
                        style: buttonStyle,
                        onPressed: (hit) {
                          widget.onSelect(hit);
                          setState(() {
                            if (!isMultiplierLocked) {
                              hitMultiplier = HitMultiplier.single;
                            }
                          });
                        },
                        hitMult: hitMultiplier,
                        hitNum: hitNum,
                      )
                  ],
                ),
            ],
          )),
    );
  }
}

class _MultiplierButton extends StatelessWidget {
  final Function(HitMultiplier) onPressed;
  final Function(HitMultiplier) onDoubleTap;
  final HitMultiplier hitMultiplier;
  final HitMultiplier current;
  final ButtonStyle style;
  final bool isLocked;

  const _MultiplierButton(
      {required this.style,
      required this.onPressed,
      required this.onDoubleTap,
      required this.hitMultiplier,
      required this.current,
      this.isLocked = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      height: 50,
      margin: const EdgeInsets.all(2.5),
      padding: EdgeInsets.zero,
      child: _MultiplierButtonWithGestures(
        onPressed: () => onPressed(hitMultiplier),
        onDoubleTap: () => onDoubleTap(hitMultiplier),
        onLongPress: () => onDoubleTap(hitMultiplier),
        style: style,
        text: hitMultiplier.text,
        isLocked: isLocked,
      ),
    ));
  }
}

class _MultiplierButtonWithGestures extends StatefulWidget {
  final VoidCallback onPressed;
  final VoidCallback onDoubleTap;
  final VoidCallback onLongPress;
  final ButtonStyle style;
  final String text;
  final bool isLocked;

  const _MultiplierButtonWithGestures({
    required this.onPressed,
    required this.onDoubleTap,
    required this.onLongPress,
    required this.style,
    required this.text,
    required this.isLocked,
  });

  @override
  State<_MultiplierButtonWithGestures> createState() => _MultiplierButtonWithGesturesState();
}

class _MultiplierButtonWithGesturesState extends State<_MultiplierButtonWithGestures> {
  Timer? _tapTimer;
  int _tapCount = 0;

  @override
  void dispose() {
    _tapTimer?.cancel();
    super.dispose();
  }

  void _handleTap() {
    _tapCount++;
    if (_tapCount == 1) {
      _tapTimer = Timer(const Duration(milliseconds: 200), () {
        if (_tapCount == 1) {
          widget.onPressed();
        }
        _tapCount = 0;
      });
    } else if (_tapCount == 2) {
      _tapTimer?.cancel();
      _tapCount = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      onDoubleTap: () {
        widget.onDoubleTap();
      },
      onLongPress: () {
        widget.onLongPress();
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: widget.isLocked 
              ? Colors.orange 
              : widget.style.backgroundColor?.resolve({}),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              color: widget.style.foregroundColor?.resolve({}),
              fontWeight: widget.isLocked ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class HitButton extends StatelessWidget {
  final Function(Hit) onPressed;
  final HitNumber hitNum;
  final HitMultiplier hitMult;
  final ButtonStyle style;

  Hit get hit {
    return Hit.get(hitNum, hitMult);
  }

  const HitButton(
      {super.key,
      required this.style,
      required this.onPressed,
      required this.hitMult,
      required this.hitNum});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      height: 50,
      margin: const EdgeInsets.all(2.5),
      padding: EdgeInsets.zero,
      child: ElevatedButton(
        onPressed: () => onPressed(hit),
        style: style,
        child: Text(
          hit.abbreviation,
        ),
      ),
    ));
  }
}
