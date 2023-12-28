import 'package:flutter/material.dart';

class SelectionRow<T> extends StatelessWidget {
  final void Function(T) setState;
  final T Function() getState;
  final Map<String, T> values;

  final ButtonStyle? buttonStyle;
  final bool? expanded;

  const SelectionRow({super.key, required this.values, required this.setState,
    required this.getState, this.buttonStyle, this.expanded});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: values.entries.map<Widget>((e) {
        var button = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: ElevatedButton(
            onPressed: (getState() == e.value) ? null : () {
              setState(e.value);
            },
            style: buttonStyle,
            child: Text(e.key),
          ),
        );
        if(expanded??false) {
          return Expanded(child: button);
        } else {
          return button;
        }
      }).toList(),
    );
  }
}