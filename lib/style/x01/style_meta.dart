import 'package:flutter/material.dart';

enum Placement {
  leftEnd,
  rightEnd,
  center,
}

class PlayerColors {
  PlayerColors._();

  static const dark = [
    Color.fromRGBO(17, 146, 232, 1.0),
    Color.fromRGBO(159, 24, 83, 1.0),
    Color.fromRGBO(178, 134, 0, 1.0),
    Color.fromRGBO(105, 41, 196, 1.0),
    Color.fromRGBO(0, 93, 93, 1.0),
    Color.fromRGBO(1, 39, 73, 1.0)
  ];

  static const light = [
    Color.fromRGBO(51, 177, 255, 1.0),
    Color.fromRGBO(255, 126, 182, 1.0),
    Color.fromRGBO(210, 161, 6, 1.0),
    Color.fromRGBO(138, 63, 252, 1.0),
    Color.fromRGBO(0, 125, 121, 1.0),
    Color.fromRGBO(186, 230, 255, 1.0)
  ];

  static Color get(int playerNum, bool darkMode) {
    if (playerNum < 1 || playerNum > 6) {
      return Colors.black;
    }
    return darkMode ? dark[playerNum - 1] : light[playerNum - 1];
  }
}