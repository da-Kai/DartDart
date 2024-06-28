import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/common.dart';
import 'package:dart_dart/logic/x01/player.dart';
import 'package:dart_dart/logic/x01/settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test X01 Logic', () {
    test('Test X01 PlayerData', () {
      /// Test Multiplayer
      var player = ['B', 'C', 'D'];

      Player factory(str) => Player(str, 101, () => 0);
      var plyData = PlayerData.get(player, factory);

      expect(plyData.isSinglePlayer, false);
      expect(plyData.isMultiPlayer, true);

      final next = plyData.next;
      plyData.rotateForward();
      expect(next, plyData.current);

      final previous = plyData.last;
      plyData.rotateBackwards();
      expect(previous, plyData.current);

      /// Test SinglePlayer
      plyData = PlayerData.get(['nerd'], factory);

      expect(plyData.isSinglePlayer, true);
      expect(plyData.isMultiPlayer, false);
      expect(plyData.playerCount, 1);
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
      expect(turn.done, false);
      turn.thrown(hitOne);
      turn.thrown(hitOne);
      turn.thrown(hitOne);
      expect(turn.done, true);
      expect(turn.isCheckout, false);

      turn = PlayerTurn(set, 40);
      expect(turn.done, false);
      turn.thrown(hitDTwenty);
      expect(turn.done, true);
      expect(turn.isCheckout, true);
    });
    test('Test X01 GameRound', () {
      var gameFactory = GameSettingFactory();
      var set = gameFactory.get();
      var round = GameRound(set);

      expect(round.current.startScore, set.points);

      round.setupTurn(PlayerTurn(set, 60));
      expect(round.current.startScore, 60);

      var ply = Player('Test', 101, () => 0);
      round.setupTurnFor(ply);
      expect(round.current.startScore, ply.score);
    });
    test('Test X01 PlayerTurn', () {
      var gameFactory = GameSettingFactory();
      var set = gameFactory.get();

      var ply = Player('Test', set.points, () => 0);

      expect(ply.turnHistory.turnCount, 0);
      expect(ply.score, set.points);
      expect(ply.done, false);

      var turnOne = PlayerTurn(set, ply.score);
      expect(turnOne.done, false);
      turnOne.thrown(Hit.get(HitNumber.twenty, HitMultiplier.triple));
      turnOne.thrown(Hit.get(HitNumber.twenty, HitMultiplier.triple));
      turnOne.thrown(Hit.get(HitNumber.twenty, HitMultiplier.triple));
      expect(turnOne.done, true);

      ply.turnHistory.add(0, turnOne);
      expect(ply.turnHistory.turnCount, 1);
      expect(ply.score, 121);
      expect(ply.done, false);

      var turnTwo = PlayerTurn(set, ply.score);
      turnTwo.thrown(Hit.get(HitNumber.twenty, HitMultiplier.triple));
      turnTwo.thrown(Hit.get(HitNumber.nineteen, HitMultiplier.triple));

      ply.turnHistory.add(0, turnTwo);
      expect(ply.turnHistory.turnCount, 2);
      expect(ply.score, 4);
      expect(ply.done, false);

      var turnThree = PlayerTurn(set, ply.score);
      turnThree.thrown(Hit.get(HitNumber.two, HitMultiplier.double));
      expect(turnOne.done, true);

      ply.turnHistory.add(0, turnThree);
      expect(ply.turnHistory.turnCount, 3);
      expect(ply.score, 0);
      expect(ply.done, true);
    });
  });
}
