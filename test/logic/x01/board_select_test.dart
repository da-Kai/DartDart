import 'dart:ui';

import 'package:dart_dart/logic/common/coordinate.dart';
import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/board_select.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test X01 Board Select', () {
    test('Test X01 GameMath', () {
      var coo = const Coordinate(3, 4);
      var (distance, _) = GameMath.vectorData(coo);
      expect(distance, 5);

      var coo2 = const Coordinate(-10, 10);
      var (_, angle) = GameMath.vectorData(coo2);
      expect(angle.roundToDouble(), 45);

      var offset = const Size(120, 120);
      var size1 = const Offset(120, 120);
      var size2 = const Offset(60, 60);
      var size3 = const Offset(0, 0);
      expect(GameMath.norm(offset, size1), const Coordinate(100, 100));
      expect(GameMath.norm(offset, size2), const Coordinate(0, 0));
      expect(GameMath.norm(offset, size3), const Coordinate(-100, -100));
    });
    test('Test X01 FieldCalc', () {
      var (ang1, dist1) = (301.0, 24.0);
      var (ang2, dist2) = (0.0, 100.0);
      var (ang3, dist3) = (35.0, 40.0);
      var (ang4, dist4) = (-10.0, 70.0);
      var (ang5, dist5) = (161.0, 12.0);

      var fifteen = Hit.get(HitNumber.fifteen, HitMultiplier.single);
      expect(FieldCalc.getField(angle: ang1, distance: dist1), fifteen);

      expect(FieldCalc.getField(angle: ang2, distance: dist2), Hit.miss);

      var seven = Hit.get(HitNumber.seven, HitMultiplier.triple);
      expect(FieldCalc.getField(angle: ang3, distance: dist3), seven);

      var seventeen = Hit.get(HitNumber.seventeen, HitMultiplier.double);
      expect(FieldCalc.getField(angle: ang4, distance: dist4), seventeen);

      expect(FieldCalc.getField(angle: ang5, distance: dist5), Hit.bull);
    });
  });
}