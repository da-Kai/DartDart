import 'package:flutter/material.dart';
import 'package:dart_dart/constants/color.dart';
import 'package:dart_dart/constants/icon.dart';

void main() {
  runApp(const DartDart());
}

class DartDart extends StatelessWidget {
  const DartDart({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dart/Dart',
      theme: ThemeData(
        colorScheme: ColorSchemes.light,
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Dart/Dart'),
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
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.secondary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        surfaceTintColor: Theme.of(context).colorScheme.onBackground,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Dart-Dart',
            ),
            Icon(CustomIcons.dartDart),
          ],
        ),
      ),
    );
  }
}
