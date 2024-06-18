import 'package:flutter/material.dart';

class FullscreenDialog extends StatelessWidget {
  const FullscreenDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body:
      Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(onPressed: () {
                  Navigator.pop(context);
                }, icon: const Icon(Icons.close)),
              ],
            ),
            const Text('This is a fullscreen dialog!'),
          ]
      ),
    );
  }
}