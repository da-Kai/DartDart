import 'package:dart_dart/constants/color.dart';
import 'package:dart_dart/constants/font.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DartDart());
}

class DartDart extends StatelessWidget {
  const DartDart({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DartDart',
      theme: ThemeData(
        colorScheme: ColorSchemes.light,
        fontFamily: FontConstants.title.fontFamily,
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Dart Dart'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final ButtonStyle style = ElevatedButton.styleFrom(
        textStyle: FontConstants.text,
        fixedSize: const Size(300, 10),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: colorScheme.secondary,
        backgroundColor: colorScheme.primary,
        surfaceTintColor: colorScheme.onBackground,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: style,
              onPressed: () {},
              child: const Text('01s'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: style,
              onPressed: () {},
              child: const Text('Cricket'),
            ),
          ],
        ),
      ),
    );
  }
}
