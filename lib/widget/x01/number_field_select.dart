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
        hitMultiplier = hm;
      });
    }

    void toggleMultiplierLock(HitMultiplier hm) {
      setState(() {
        isMultiplierLocked = !isMultiplierLocked;
        if (isMultiplierLocked) {
          hitMultiplier = hm;
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
                    isLocked: isMultiplierLocked && hitMultiplier == HitMultiplier.single,
                  ),
                  _MultiplierButton(
                    style: buttonStyle,
                    onPressed: setHitMultiplier,
                    onDoubleTap: toggleMultiplierLock,
                    hitMultiplier: HitMultiplier.double,
                    current: hitMultiplier,
                    isLocked: isMultiplierLocked && hitMultiplier == HitMultiplier.double,
                  ),
                  _MultiplierButton(
                    style: buttonStyle,
                    onPressed: setHitMultiplier,
                    onDoubleTap: toggleMultiplierLock,
                    hitMultiplier: HitMultiplier.triple,
                    current: hitMultiplier,
                    isLocked: isMultiplierLocked && hitMultiplier == HitMultiplier.triple,
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
      child: GestureDetector(
        onDoubleTap: () => onDoubleTap(hitMultiplier),
        onLongPress: () => onDoubleTap(hitMultiplier),
        child: ElevatedButton(
          onPressed:
              current == hitMultiplier && !isLocked ? null : () => onPressed(hitMultiplier),
          style: style.copyWith(
            backgroundColor: isLocked 
                ? WidgetStateProperty.all(Colors.orange) 
                : style.backgroundColor,
          ),
          child: Text(
            hitMultiplier.text,
            style: TextStyle(
              fontWeight: isLocked ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    ));
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
