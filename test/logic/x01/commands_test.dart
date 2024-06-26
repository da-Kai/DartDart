import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/commands.dart';
import 'package:dart_dart/logic/x01/common.dart';
import 'package:dart_dart/logic/x01/player.dart';
import 'package:dart_dart/logic/x01/settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test X01 Commands', () {
    test('Test Throw', () {
      var settings = GameSettingFactory().get();
      var round = GameRound(settings);
      var hit = Hit.bullseye;

      var t = Throw(round, hit, 0);

      expect(round.current.first, Hit.skipped);
      t.execute();
      expect(round.current.first, hit);
      t.undo();
      expect(round.current.first, Hit.skipped);
    });
    test('Test Switch', () {
      var settings = GameSettingFactory().get();
      Player plyFunc(name) => Player(name, settings.points);
      var plyData = PlayerData.get(['A', 'B'], plyFunc);
      var gameRound = GameRound(settings);
      gameRound.current.thrown(Hit.doubleBullseye);

      var t = Switch.from(plyData, gameRound);

      expect(gameRound.current, t.round);
      expect(plyData.current, t.curPly);
      expect(t.curPly.turnHistory.length, 0);
      t.execute();
      expect(gameRound.current == t.round, false);
      expect(plyData.current == t.curPly, false);
      expect(t.curPly.turnHistory.length, 1);
      t.undo();
      expect(gameRound.current, t.round);
      expect(plyData.current, t.curPly);
      expect(t.curPly.turnHistory.length, 0);
    });
    test('Test Award', () {
      var player = ['A', 'B'];
      var plyData = PlayerData.get(player, 42);
      var curPly = plyData.next;
      var data = LegAndSetData(player);

      var a = EndLeg(data, plyData);

      expect(data.getLeader(), null);
      a.execute();
      expect(data.getLeader(), curPly);
      a.undo();
      expect(data.getLeader(), null);
    });
  });
}
