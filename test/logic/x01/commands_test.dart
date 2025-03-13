import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/commands.dart';
import 'package:dart_dart/logic/x01/game.dart';
import 'package:dart_dart/logic/x01/player.dart';
import 'package:dart_dart/logic/x01/settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test X01 Commands', () {
    test('Test Throw', () {
      var settings = GameSettingFactory().get();
      var round = TurnBuilder(settings);
      var hit = Hit.bullseye;

      var t = Throw(round, hit, 0);

      expect(round.first, Hit.skipped);
      t.execute();
      expect(round.first, hit);
      t.undo();
      expect(round.first, Hit.skipped);
    });
    test('Test Switch', () {
      var settings = GameSettingFactory().get();
      var plyData = PlayerData.get(['A', 'B']);
      var gameRound = TurnBuilder(settings);
      var gameData = X01GameData(settings);
      gameRound.thrown(Hit.bullseye);

      var t = Switch.from(plyData, gameData, gameRound);

      expect(plyData.current, t.curPly);
      expect(gameData.totalTurnCount(t.curPly), 0);
      t.execute();
      expect(plyData.current == t.curPly, false);
      expect(gameData.totalTurnCount(t.curPly), 1);
      t.undo();
      expect(plyData.current, t.curPly);
      expect(gameData.totalTurnCount(t.curPly), 0);
    });
    test('Test EndLeg', () {
      var player = ['A', 'B'];
      var settings = GameSettings(Games.threeOOne, InOut.straight, InOut.straight, 1, 2, player);
      var data = GameController(settings);
      
      expect(data.commands.toString(), '[]');
      expect(data.totalLeader?.name, 'A');

      var cmdSwitch = Switch.from(data.playerData, data.gameData, data.turnBuilder);
      data.commands.execute(cmdSwitch);
      expect(data.curPly.name, 'B');

      expect(data.commands.toString(), '[(Switch)]');

      expect(data.totalLeader?.name, 'A');
      expect(data.leaderPoints, (0, 0));
      expect(data.curPly.name, 'B');
      var legWinner = data.playerData.find('B');
      var cmdEndLeg = EndLeg.from(data.playerData, data.gameData, data.turnBuilder, ply: legWinner);
      data.commands.execute(cmdEndLeg);

      expect(data.curPly.name, 'A');
      expect(data.commands.toString(), '[Switch, (EndLeg)]');

      expect(data.totalLeader?.name, 'B');
      expect(data.totalLeader?.name, legWinner.name);
      expect(data.leaderPoints, (0, 1));

      var cmdSwitch3 = Switch.from(data.playerData, data.gameData, data.turnBuilder);
      data.commands.execute(cmdSwitch3);

      expect(data.curPly.name, 'B');

      var cmdEndSet = EndSet.from(data.playerData, data.gameData, data.turnBuilder);
      data.commands.execute(cmdEndSet);

      expect(data.commands.toString().endsWith('[Switch, EndLeg, Switch, (EndSet)]'), true);
      expect(data.leaderPoints, (1, 0));

      data.commands.undo();
      expect(data.commands.toString(), '[Switch, EndLeg, (Switch), EndSet]');

      data.commands.undo();
      expect(data.commands.toString(), '[Switch, (EndLeg), Switch, EndSet]');

      expect(data.totalLeader?.name, 'B');
      expect(data.leaderPoints, (0, 1));
      data.commands.undo();

      expect(data.commands.toString(), '[(Switch), EndLeg, Switch, EndSet]');

      expect(data.totalLeader?.name, 'A');
      expect(data.leaderPoints, (0, 0));
      data.commands.undo();

      expect(data.commands.toString(), '[Switch, EndLeg, Switch, EndSet]');

      expect(data.totalLeader?.name, 'A');
    });
  });
}
