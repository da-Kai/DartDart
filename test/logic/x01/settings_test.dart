import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test X01 Settings', () {
    test('Test X01 SettingFactory', () {
      var game = GameSettingFactory();
      expect(game.isNameFree('A'), true);
      game.playerNames.add('A');
      expect(game.isNameFree('a'), false);
      expect(game.isNameFree('B'), true);

      game.sets = game.legs = 1;
      expect(true, game.isOneDimensional);
      game.sets = 2;
      expect(true, game.isOneDimensional);
      game.legs = 2;
      expect(false, game.isOneDimensional);
      game.sets = 1;
      expect(true, game.isOneDimensional);
    });
    test('Test X01 Settings', () {
      var factory = GameSettingFactory();
      factory.game = Games.threeOOne;
      factory.gameIn = InOut.master;
      factory.gameOut = InOut.master;
      var settings = factory.get();

      expect(settings.isValid(301, Hit.bull), false);
      expect(settings.isValid(301, Hit.bullseye), true);

      var tripleThirteen = Hit.get(HitNumber.thirteen, HitMultiplier.triple);
      var doubleTwenty = Hit.get(HitNumber.twenty, HitMultiplier.double);
      expect(settings.isInvalid(40, Hit.bullseye), true);
      expect(settings.isValid(40, doubleTwenty), true);
      expect(settings.isValid(40, Hit.bull), true);
      expect(settings.isInvalid(40, tripleThirteen), true);
    });
  });
}
