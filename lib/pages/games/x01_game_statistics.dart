import 'package:dart_dart/logic/x01/game.dart';
import 'package:flutter/material.dart';

class X01Statistics extends StatefulWidget {
  final GameStats stats;

  const X01Statistics({super.key, required this.stats});

  @override
  State<X01Statistics> createState() => _X01PageState();
}

class _X01PageState extends State<X01Statistics> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final GameStats data = widget.stats;

    return Scaffold(

            );
  }
}

class _PortraitView extends StatelessWidget {
  final _X01PageState state;
  final Function update;

  const _PortraitView(this.state, this.update);

  @override
  Widget build(BuildContext context) {
    final GameStats data = state.widget.stats;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [

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
    final GameStats data = state.widget.stats;

    return Row(
      children: [

      ],
    );
  }
}
