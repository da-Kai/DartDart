import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/x01_commands.dart';
import 'package:dart_dart/logic/x01/x01_common.dart';
import 'package:dart_dart/logic/x01/x01_settings.dart';
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
      var plyData = PlayerData.get(['A', 'B'], 42);
      var gameRound = GameRound(settings);
      gameRound.current.thrown(Hit.doubleBullseye);

      var t = Switch.from(plyData, gameRound);

      expect(gameRound.current, t.round);
      expect(plyData.currentPlayer, t.curPly);
      expect(t.curPly.turnHistory.length, 0);
      t.execute();
      expect(gameRound.current == t.round, false);
      expect(plyData.currentPlayer == t.curPly, false);
      expect(t.curPly.turnHistory.length, 1);
      t.undo();
      expect(gameRound.current, t.round);
      expect(plyData.currentPlayer, t.curPly);
      expect(t.curPly.turnHistory.length, 0);
    });
    test('Test Award', () {
      var plyData = PlayerData.get(['A', 'B'], 42);
      var curPly = plyData.next;

      var a = Award(plyData);

      expect(plyData.winner, null);
      a.execute();
      expect(plyData.winner, curPly);
      a.undo();
      expect(plyData.winner, null);
    });
  });
}
