import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/x01_common.dart';
import 'package:dart_dart/logic/x01/x01_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test X01 Logic', () {
    test('Test X01 PlayerData', () {
      /// Test Multiplayer
      var player = ['B', 'C', 'D'];

      var plyData = PlayerData(player, 101);

      expect(plyData.isSinglePlayer, false);
      expect(plyData.isMultiPlayer, true);

      var playerD = Player('D', 101);
      plyData.pushPlayerBack(playerD);
      expect(plyData.popPlayerBack(), playerD);

      var playerA = Player('A', 101);
      plyData.pushPlayerFront(playerA);
      expect(plyData.popPlayerFront(), playerA);

      expect(plyData.currentPlayer.name, 'B');
      var playerB = plyData.currentPlayer;
      plyData.setCurrentPlayer(playerA);
      plyData.pushPlayerFront(playerB);
      expect(plyData.currentPlayer, playerA);

      var front = plyData.popPlayerFront()!;
      expect(plyData.winner, null);
      plyData.addWinner(front);
      expect(plyData.winner!, front);
      plyData.pushPlayerFront(plyData.popWinner()!);
      expect(plyData.winner, null);

      /// Test SinglePlayer
      plyData = PlayerData(['nerd'], 101);

      expect(plyData.isSinglePlayer, true);
      expect(plyData.isMultiPlayer, false);
      expect(plyData.done, false);

      plyData.addWinner(plyData.currentPlayer);
      expect(plyData.done, true);
    });
    test('Test X01 PlayerTurn', () {
      var gameFactory = GameSettingFactory();
      var set = gameFactory.get();

      var turn = PlayerTurn.from(set);
      expect(turn.startScore, gameFactory.game.val);
      expect(turn.score, gameFactory.game.val);

      var hitOne = Hit.get(HitNumber.one, HitMultiplier.single);
      var hitDTwenty = Hit.get(HitNumber.twenty, HitMultiplier.double);

      turn = PlayerTurn(set, 40);
      expect(turn.done(), false);
      turn.thrown(hitOne);
      turn.thrown(hitOne);
      turn.thrown(hitOne);
      expect(turn.done(), true);
      expect(turn.isWin, false);

      turn = PlayerTurn(set, 40);
      expect(turn.done(), false);
      turn.thrown(hitDTwenty);
      expect(turn.done(), true);
      expect(turn.isWin, true);
    });
    test('Test X01 Commands', () {
      var gameFactory = GameSettingFactory();
      var set = gameFactory.get();

      var ply = Player('Test', set.points);

      expect(ply.turnHistory.length, 0);
      expect(ply.score, set.points);
      expect(ply.done, false);

      var turnOne = PlayerTurn(set, ply.score);
      expect(turnOne.done(), false);
      turnOne.thrown(Hit.get(HitNumber.twenty, HitMultiplier.triple));
      turnOne.thrown(Hit.get(HitNumber.twenty, HitMultiplier.triple));
      turnOne.thrown(Hit.get(HitNumber.twenty, HitMultiplier.triple));
      expect(turnOne.done(), true);

      ply.turnHistory.add(turnOne);
      expect(ply.turnHistory.length, 1);
      expect(ply.score, 121);
      expect(ply.done, false);

      var turnTwo = PlayerTurn(set, ply.score);
      turnTwo.thrown(Hit.get(HitNumber.twenty, HitMultiplier.triple));
      turnTwo.thrown(Hit.get(HitNumber.nineteen, HitMultiplier.triple));

      ply.turnHistory.add(turnTwo);
      expect(ply.turnHistory.length, 2);
      expect(ply.score, 4);
      expect(ply.done, false);

      var turnThree = PlayerTurn(set, ply.score);
      turnThree.thrown(Hit.get(HitNumber.two, HitMultiplier.double));
      expect(turnOne.done(), true);

      ply.turnHistory.add(turnThree);
      expect(ply.turnHistory.length, 3);
      expect(ply.score, 0);
      expect(ply.done, true);
    });
  });
}
