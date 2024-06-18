import 'package:dart_dart/widget/common/fullscreen_dialog.dart';
import 'package:flutter/material.dart';

class SettingsHelp {
  final BuildContext context;

  late final ColorScheme colorScheme;
  late final TextEditingController textController;

  String? errorText;

  SettingsHelp({required this.context}) {
    colorScheme = Theme.of(context).colorScheme;
  }

  Future<String?> open() async {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return const FullscreenDialog();
        });
      },
    ).then((value) {
      return null;
    });
  }
}
