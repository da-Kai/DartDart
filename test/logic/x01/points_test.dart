import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/checkout.dart';
import 'package:dart_dart/logic/x01/points.dart';
import 'package:dart_dart/logic/x01/settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test Points Values', () {
    var points = PlayerPoints();
    expect(points.currentLegs, 0);

    points.pushLeg(false);
    expect(points.currentLegs, 0);
    points.pushLeg(true);
    expect(points.currentLegs, 1);
    points.pushLeg(true);
    expect(points.currentLegs, 2);
    points.pushLeg(false);
    expect(points.currentLegs, 2);
  });
}