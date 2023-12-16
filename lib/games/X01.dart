import 'package:dart_dart/constants/font.dart';
import 'package:flutter/material.dart';

class X01 extends StatefulWidget {
  const X01({super.key});

  @override
  State<X01> createState() => _X01PageState();
}

class _X01PageState extends State<X01> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final ButtonStyle style = ElevatedButton.styleFrom(
        textStyle: FontConstants.text,
        fixedSize: const Size(100, 10),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary);

    final ButtonStyle startButtonStyle = ElevatedButton.styleFrom(
        textStyle: FontConstants.text,
        fixedSize: const Size(300, 10),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary);

    return Scaffold(
      appBar: AppBar(
        title: const Text("X01-Game Settings"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: ElevatedButton(
                    style: style,
                    onPressed: () {},
                    child: const Text('301'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: ElevatedButton(
                    style: style,
                    onPressed: () {},
                    child: const Text('501'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: ElevatedButton(
                    style: style,
                    onPressed: () {},
                    child: const Text('701'),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: ElevatedButton(
                    style: style,
                    onPressed: () {},
                    child: const Text('Single'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: ElevatedButton(
                    style: style,
                    onPressed: () {},
                    child: const Text('Double'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: ElevatedButton(
                    style: style,
                    onPressed: () {},
                    child: const Text('Master'),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: ElevatedButton(
                    style: style,
                    onPressed: () {},
                    child: const Text('Single'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: ElevatedButton(
                    style: style,
                    onPressed: () {},
                    child: const Text('Double'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: ElevatedButton(
                    style: style,
                    onPressed: () {},
                    child: const Text('Master'),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              style: startButtonStyle,
              onPressed: () {},
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
}