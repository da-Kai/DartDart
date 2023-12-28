import 'package:dart_dart/style/color.dart';
import 'package:dart_dart/style/font.dart';
import 'package:dart_dart/style/icon.dart';
import 'package:dart_dart/pages/settings/x01_settings_page.dart';
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
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        titleTextStyle: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            fontFamily: FontConstants.title.fontFamily,
            color: colorScheme.onPrimary,
        ),
        foregroundColor: colorScheme.onPrimary,
        backgroundColor: colorScheme.primary,
        surfaceTintColor: colorScheme.onPrimary,
        leading: const Icon(CustomIcons.dartDart, size: 50),
        leadingWidth: 100,
        title: Text(widget.title),
        centerTitle: true,
        toolbarHeight: 90.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 40,
              ),
              child: ElevatedButton(
                style: style,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => X01Setting()),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Text('X01'),
                )
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        height: 50,
        child: Container(
          color: colorScheme.primary,
        ),
      ),
    );
  }
}
