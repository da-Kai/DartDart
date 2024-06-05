import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/x01_common.dart';
import 'package:dart_dart/logic/x01/x01_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test X01 Logic', () {
    test('Test X01 Common', () {
      var gameFactory = GameSettingFactory();
      var set = gameFactory.get();

      var ply = Player('Test', set.points);

      expect(ply.turnHistory.length, 0);
      expect(ply.score, set.points);
      expect(ply.done, false);

      var turnOne = PlayerTurn(set, ply.score);
      turnOne.thrown(const Hit(HitNumber.twenty, HitMultiplier.triple));
      turnOne.thrown(const Hit(HitNumber.twenty, HitMultiplier.triple));
      turnOne.thrown(const Hit(HitNumber.twenty, HitMultiplier.triple));

      ply.turnHistory.add(turnOne);
      expect(ply.turnHistory.length, 1);
      expect(ply.score, 121);
      expect(ply.done, false);

      var turnTwo = PlayerTurn(set, ply.score);
      turnTwo.thrown(const Hit(HitNumber.twenty, HitMultiplier.triple));
      turnTwo.thrown(const Hit(HitNumber.nineteen, HitMultiplier.triple));
      turnTwo.thrown(const Hit(HitNumber.two, HitMultiplier.double));

      ply.turnHistory.add(turnTwo);
      expect(ply.turnHistory.length, 2);
      expect(ply.score, 0);
      expect(ply.done, true);
    });
  });
}