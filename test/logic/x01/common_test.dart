import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/common.dart';
import 'package:dart_dart/logic/x01/game.dart';
import 'package:dart_dart/logic/x01/player.dart';
import 'package:dart_dart/logic/x01/settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test X01 Logic', () {
    test('Test X01 PlayerData', () {
      /// Test Multiplayer
      var player = ['B', 'C', 'D'];
      var plyData = PlayerData.get(player);

      expect(plyData.isSinglePlayer, false);
      expect(plyData.isMultiPlayer, true);

      final next = plyData.next;
      plyData.rotateForward();
      expect(next, plyData.current);

      final previous = plyData.last;
      plyData.rotateBackwards();
      expect(previous, plyData.current);

      /// Test SinglePlayer
      plyData = PlayerData.get(['nerd']);

      expect(plyData.isSinglePlayer, true);
      expect(plyData.isMultiPlayer, false);
      expect(plyData.playerCount, 1);
    });
    test('Test X01 PlayerTurn', () {
      var gameFactory = GameSettingFactory();
      var set = gameFactory.get();

      var turn = TurnBuilder(set);
      expect(turn.startScore, gameFactory.game.val);
      expect(turn.score, gameFactory.game.val);

      var hitOne = Hit.get(HitNumber.one, HitMultiplier.single);
      var hitDTwenty = Hit.get(HitNumber.twenty, HitMultiplier.double);

      final TurnCheck check = TurnCheck(true, false, false, false);

      turn = TurnBuilder(set);
      turn.setupTurnFor(InitTurn(check: check, initScore: 40));
      expect(turn.done, false);
      turn.thrown(hitOne);
      turn.thrown(hitOne);
      turn.thrown(hitOne);
      expect(turn.done, true);
      expect(turn.isCheckout, false);

      turn = TurnBuilder(set);
      turn.setupTurnFor(InitTurn(check: check, initScore: 40));
      expect(turn.done, false);
      turn.thrown(hitDTwenty);
      expect(turn.done, true);
      expect(turn.isCheckout, true);
    });
    test('Test X01 GameRound', () {
      var gameFactory = GameSettingFactory();
      var set = gameFactory.get();
      var round = TurnBuilder(set);
      final TurnCheck check = TurnCheck(true, false, false, false);

      expect(round.startScore, set.points);

      final X01Turn init = InitTurn(check: check, initScore: 60);
      round.setupTurn(GameTurn(check: check, previous: init), init);
      expect(round.startScore, 60);
    });
    test('Test X01 TurnBuilder', () {
      var gameFactory = GameSettingFactory();
      gameFactory.game = Games.threeOOne;
      gameFactory.gameIn = InOut.straight;
      gameFactory.gameOut = InOut.double;
      var set = gameFactory.get();

      expect(set.gameOut, InOut.double);
      var builder = TurnBuilder(set);

      final Hit tripleTwenty = Hit.get(HitNumber.twenty, HitMultiplier.triple);

      expect(builder.done, false);
      builder.thrown(tripleTwenty);
      expect(builder.done, false);
      builder.thrown(tripleTwenty);
      expect(builder.done, false);
      builder.thrown(tripleTwenty);
      expect(builder.done, true);

      var turn = builder.build();
      expect(turn.done, true);
      expect(turn.sum(), tripleTwenty.value * 3);
      expect(turn.getScore(), 301 - 180);

      final X01Turn init = InitTurn(check: TurnCheck.instance(), initScore: 60);
      builder.setupTurnFor(init);
      expect(builder.score, 60);

      builder.thrown(Hit.get(HitNumber.bull, HitMultiplier.double));
      expect(builder.score, 10);
      expect(builder.done, false);
      expect(builder.valid, true);

      builder.thrown(Hit.get(HitNumber.nine, HitMultiplier.single));
      expect(builder.score, 60);
      expect(builder.overthrown, false);
      expect(builder.done, true);
      expect(builder.valid, false);
      expect(builder.isCheckout, false);

      builder.undo(1);
      expect(builder.score, 10);
      expect(builder.done, false);
      expect(builder.valid, true);

      builder.thrown(Hit.get(HitNumber.ten, HitMultiplier.single));
      expect(builder.score, 60);
      expect(builder.overthrown, false);
      expect(builder.done, true);
      expect(builder.valid, false);
      expect(builder.isCheckout, false);

      builder.undo(1);
      expect(builder.score, 10);
      expect(builder.done, false);
      expect(builder.valid, true);

      builder.thrown(Hit.get(HitNumber.twenty, HitMultiplier.single));
      expect(builder.score, 60);
      expect(builder.overthrown, true);
      expect(builder.done, true);
      expect(builder.valid, false);
      expect(builder.isCheckout, false);

      builder.undo(1);
      expect(builder.score, 10);
      expect(builder.done, false);
      expect(builder.valid, true);

      builder.thrown(Hit.get(HitNumber.five, HitMultiplier.double));
      expect(builder.score, 0);
      expect(builder.overthrown, false);
      expect(builder.done, true);
      expect(builder.valid, true);
      expect(builder.isCheckout, true);
    });
  });
}
