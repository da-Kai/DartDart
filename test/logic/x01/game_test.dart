import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/game.dart';
import 'package:dart_dart/logic/x01/settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test X01 GameController', () {
    var player = ['Test1', 'Test2', 'Test3'];
    var setFactory = GameSettingFactory();
    setFactory.gameIn = InOut.double;
    var settings = setFactory.get();

    var game = GameController(player, settings);

    expect(game.isMultiPlayer, true);
    expect(game.curTurn.valid, true);
    expect(game.curTurn.first, Hit.skipped);

    game.onThrow(Hit.bull);
    expect(game.curTurn.valid, false);

    expect(game.curPly.name, 'Test1');
    expect(game.canUndo, true);
    expect(game.canRedo, false);
    expect(game.curTurn.first, Hit.bull);

    expect(game.hasGameEnded, false);
    
    game.onThrow(Hit.miss);
    game.onThrow(Hit.miss);
    
    expect(game.curTurn.done, true);

    game.undo();
    expect(game.canRedo, true);
    expect(game.curTurn.done, false);
    game.redo();

    expect(game.curTurn.done, true);

    game.next();
  });
}