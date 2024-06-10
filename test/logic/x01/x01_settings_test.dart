import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/x01_common.dart';
import 'package:dart_dart/logic/x01/x01_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test X01 Settings', () {
    test('Test X01 SettingFactory', () {
      var game = GameSettingFactory();
      expect(game.isNameFree('A'), true);
      game.players.add('A');
      expect(game.isNameFree('a'), false);
      expect(game.isNameFree('B'), true);
    });
    test('Test X01 Settings', () {
      var factory = GameSettingFactory();
      factory.game = Games.threeOOne;
      factory.gameIn = InOut.master;
      factory.gameOut = InOut.master;
      var settings = factory.get();

      expect(settings.isValid(301, Hit.bullseye), false);
      expect(settings.isValid(301, Hit.doubleBullseye), true);

      var tripleThirteen = Hit.get(HitNumber.thirteen, HitMultiplier.triple);
      var doubleTwenty = Hit.get(HitNumber.twenty, HitMultiplier.double);
      expect(settings.isInvalid(40, Hit.doubleBullseye), true);
      expect(settings.isValid(40, doubleTwenty), true);
      expect(settings.isValid(40, Hit.bullseye), true);
      expect(settings.isInvalid(40, tripleThirteen), true);
    });
  });
}
