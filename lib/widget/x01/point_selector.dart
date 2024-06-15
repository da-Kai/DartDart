import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/game.dart';
import 'package:dart_dart/style/color.dart';
import 'package:dart_dart/widget/x01/board_select.dart';
import 'package:dart_dart/widget/x01/number_field_select.dart';
import 'package:dart_dart/widget/x01/selection_row.dart';
import 'package:flutter/material.dart';

class PointSelector extends StatefulWidget {
  final void Function(Hit) onSelect;

  const PointSelector({super.key, required this.onSelect});

  @override
  State<StatefulWidget> createState() => _PointSelectorState();
}

class _PointSelectorState extends State<PointSelector> {
  InputType type = InputType.board;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    const Radius borderRadius = Radius.circular(20);

    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(topLeft: borderRadius, topRight: borderRadius),
                      color: colorScheme.backgroundShade,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(bottomLeft: borderRadius, bottomRight: borderRadius),
                    color: colorScheme.backgroundShade,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              children: [
                Expanded(
                  child: type == InputType.board
                      ? //
                      BoardSelect(onSelect: widget.onSelect)
                      : FieldSelect(onSelect: widget.onSelect),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  height: 55,
                  child: SelectionRow(
                    getState: () => type,
                    setState: (type) {
                      setState(() => this.type = type);
                    },
                    values: const <String, InputType>{'BOARD': InputType.board, 'FIELD': InputType.field},
                    expanded: true,
                    buttonStyle: ElevatedButton.styleFrom(
                      foregroundColor: colorScheme.onPrimary,
                      backgroundColor: colorScheme.primary,
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
