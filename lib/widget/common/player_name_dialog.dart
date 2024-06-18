import 'package:dart_dart/pages/settings/x01_settings_page.dart';
import 'package:dart_dart/style/color.dart';
import 'package:flutter/material.dart';

class PlayerNameDialog {
  final String? player;
  final BuildContext context;
  final Validator validate;

  late final ColorScheme colorScheme;
  late final TextEditingController textController;

  String? errorText;

  PlayerNameDialog({required this.context, required this.validate, this.player}) {
    colorScheme = Theme.of(context).colorScheme;
    textController = TextEditingController(text: player);
  }

  Future<String?> open() async {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(player == null ? 'New Player' : 'Edit Player', textAlign: TextAlign.center),
            content: SingleChildScrollView(
              child: TextField(
                controller: textController,
                decoration: InputDecoration(hintText: 'name', errorText: errorText),
              ),
            ),
            backgroundColor: colorScheme.backgroundShade,
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              MaterialButton(
                color: colorScheme.error,
                textColor: colorScheme.onError,
                child: const Text('CANCEL'),
                onPressed: () => Navigator.pop(context),
              ),
              MaterialButton(
                color: colorScheme.primary,
                textColor: colorScheme.onPrimary,
                child: const Text('OK'),
                onPressed: () {
                  var nextPlayer = textController.value.text;
                  var (valid, errMsg) = validate(nextPlayer);
                  if (valid) {
                    setState(() {
                      errorText = '';
                      Navigator.pop(context);
                    });
                  } else {
                    setState(() => errorText = errMsg);
                  }
                },
              ),
            ],
          );
        });
      },
    ).then((value) {
      var nextPly = textController.value.text;
      var (valid, _) = validate(nextPly);
      return valid ? nextPly : null;
    });
  }
}
