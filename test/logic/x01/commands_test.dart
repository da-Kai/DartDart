import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/commands.dart';
import 'package:dart_dart/logic/x01/common.dart';
import 'package:dart_dart/logic/x01/game.dart';
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
      Player plyFunc(name) => Player(name, settings.points, () => 0);
      var plyData = PlayerData.get(['A', 'B'], plyFunc);
      var gameRound = GameRound(settings);
      gameRound.current.thrown(Hit.bullseye);

      var t = Switch.from(plyData, gameRound);

      expect(gameRound.current, t.round);
      expect(plyData.current, t.curPly);
      expect(t.curPly.turnHistory.turnCount, 0);
      t.execute();
      expect(gameRound.current == t.round, false);
      expect(plyData.current == t.curPly, false);
      expect(t.curPly.turnHistory.turnCount, 1);
      t.undo();
      expect(gameRound.current, t.round);
      expect(plyData.current, t.curPly);
      expect(t.curPly.turnHistory.turnCount, 0);
    });
    test('Test EndLeg', () {
      var player = ['A', 'B'];
      var settings = GameSettings(Games.threeOOne, InOut.straight, InOut.straight, 2, 2);
      var data = GameController(player, settings);
      
      expect(data.commands.toString(), '[]');

      expect(data.leader!.name, 'A');
      var cmdSwitch = Switch.from(data.playerData, data.gameRound);
      data.commands.execute(cmdSwitch);

      expect(data.commands.toString(), '[(Switch)]');

      expect(data.leader!.name, 'A');
      expect(data.leader!.points.currentLegs, 0);
      var cmdEndLeg = EndLeg.from(data.playerData, data.gameRound);
      data.commands.execute(cmdEndLeg);

      expect(data.commands.toString(), '[Switch, (EndLeg)]');

      expect(data.leader!.points.sets, 0);
      expect(data.leader!.points.currentLegs, 1);
      var cmdEndSet = EndSet.from(data.playerData, data.gameRound);
      data.commands.execute(cmdEndSet);

      expect(data.commands.toString(), '[Switch, EndLeg, (EndSet)]');

      expect(data.leader!.points.sets, 1);
      data.commands.undo();

      expect(data.commands.toString(), '[Switch, (EndLeg), EndSet]');

      expect(data.leader!.name, 'B');
      expect(data.leader!.points.sets, 0);
      expect(data.leader!.points.currentLegs, 1);
      data.commands.undo();

      expect(data.commands.toString(), '[(Switch), EndLeg, EndSet]');

      expect(data.leader!.name, 'A');
      expect(data.leader!.points.currentLegs, 0);
      data.commands.undo();

      expect(data.commands.toString(), '[Switch, EndLeg, EndSet]');

      expect(data.leader!.name, 'A');
    });
  });
}
