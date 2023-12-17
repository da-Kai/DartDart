import 'package:dart_dart/constants/color.dart';
import 'package:dart_dart/constants/font.dart';
import 'package:dart_dart/constants/icon.dart';
import 'package:dart_dart/settings/X01.dart';
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
        fontFamily: FontConstants.text.fontFamily,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorSchemes.dark,
        fontFamily: FontConstants.text.fontFamily,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: true,
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
        padding: const EdgeInsets.all(12),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
    );

    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.bold,
          fontFamily: FontConstants.title.fontFamily
        ),
        foregroundColor: colorScheme.onPrimary,
        backgroundColor: colorScheme.primary,
        surfaceTintColor: colorScheme.onPrimary,
        leading: const Icon(CustomIcons.dartDart, size: 35),
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 30,
                ),
              child: ElevatedButton(
                style: style,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const X01()),
                  );
                },
                child: const Text('X01'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
