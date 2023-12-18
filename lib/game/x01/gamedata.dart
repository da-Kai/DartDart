import 'dart:math';
import 'dart:ui';

import 'package:dart_dart/constants/fields.dart';

enum InOut { single, double, master }

enum Games {
  threeOOne(text: '301', val: 301),
  fiveOOne(text: '501', val: 501),
  sevenOOne(text: '701', val: 701);

  const Games({
    required this.text,
    required this.val,
  });

  final String text;
  final int val;
}

class GameSettings {
  Games points = Games.threeOOne;
  InOut gameIn = InOut.single;
  InOut gameOut = InOut.double;
  int legs = 1;
  int sets = 1;
  final List<String> players = [];
}

class Player {
  String name;
  int points;

  Player(this.name, this.points);
}

class GameData {
  GameSettings settings;
  Player? currentPlayer;
  List<Player> otherPlayer = [];

  GameData(this.settings) {
    otherPlayer = settings.players
        .map((ply) => Player(ply, settings.points.val))
        .toList();
    currentPlayer = otherPlayer.removeAt(0);
  }
}

class Coordinates {
  double x;
  double y;
  Coordinates(this.x, this.y);

  @override
  String toString() {
    return 'x($x)\ny($y)';
  }
}

class GameMath {
  GameMath._();

  static double _getDistance(Coordinates coo) {
    return sqrt(pow(coo.x.abs(), 2) + pow(coo.y.abs(), 2));
  }

  static double _getAngle(double dist, Coordinates coo) {
    var radiant = acos(coo.y / dist);
    var degree = radiant * (180 / pi);
    return coo.x > 0 ? 360 - degree : degree;
  }

  static Coordinates norm(Size size, Offset offset) {
    var nx = (offset.dx / (size.width/2)) - 1;
    var ny = (offset.dy / (size.height/2)) - 1;
    return Coordinates(nx * 100.0, ny * 100.0);
  }

  static (double, double) vectorData(Coordinates coo) {
    var distance = _getDistance(coo);
    var angle = _getAngle(distance, coo);
    return (distance, angle);
  }
}

class FieldCalc {
  FieldCalc._();

  static Field getField({required double angle, required double distance}) {
    //Miss
    if(distance >= 89.0 ) {
      return Field.miss;
    }

    //BullsEye
    if(distance <= 7.0) {
      return const Field(FieldVal.bullsEye, FieldMultiplier.double);
    }
    if(distance < 16.0 ) {
      return const Field(FieldVal.bullsEye, FieldMultiplier.single);
    }

    FieldMultiplier multiplier = FieldMultiplier.single;
    if(distance >= 22.0 && distance < 44.0) {
      multiplier = FieldMultiplier.double;
    } else if (distance >= 67.0 && distance < 89.0) {
      multiplier = FieldMultiplier.triple;
    }

    FieldVal value = FieldVal.miss;
    if( angle < 9 ) {
      value = FieldVal.three;
    } else if( angle < 27 ) {
      value = FieldVal.nineteen;
    } else if( angle < 45 ) {
      value = FieldVal.seven;
    } else if( angle < 63 ) {
      value = FieldVal.sixteen;
    }

    return Field(value, multiplier);
  }
}