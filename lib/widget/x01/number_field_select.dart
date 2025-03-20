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
                    hitMultiplier: HitMultiplier.single,
                    current: hitMultiplier,
                  ),
                  _MultiplierButton(
                    style: buttonStyle,
                    onPressed: setHitMultiplier,
                    hitMultiplier: HitMultiplier.double,
                    current: hitMultiplier,
                  ),
                  _MultiplierButton(
                    style: buttonStyle,
                    onPressed: setHitMultiplier,
                    hitMultiplier: HitMultiplier.triple,
                    current: hitMultiplier,
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
                            hitMultiplier = HitMultiplier.single;
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
  final HitMultiplier hitMultiplier;
  final HitMultiplier current;
  final ButtonStyle style;

  const _MultiplierButton(
      {required this.style,
      required this.onPressed,
      required this.hitMultiplier,
      required this.current});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      height: 50,
      margin: const EdgeInsets.all(2.5),
      padding: EdgeInsets.zero,
      child: ElevatedButton(
        onPressed:
            current == hitMultiplier ? null : () => onPressed(hitMultiplier),
        style: style,
        child: Text(hitMultiplier.text),
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
