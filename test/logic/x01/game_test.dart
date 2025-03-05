import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/game.dart';
import 'package:dart_dart/logic/x01/settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test X01 GameController', () {
    var setFactory = GameSettingFactory();
    setFactory.gameIn = InOut.double;
    setFactory.playerNames.addAll(['Test1', 'Test2', 'Test3']);
    var settings = setFactory.get();

    var game = GameController(settings);

    expect(game.isMultiPlayer, true);
    expect(game.turnBuilder.first, Hit.skipped);
    expect(game.turnBuilder.valid, true);

    game.onThrow(Hit.bull);
    expect(game.turnBuilder.valid, false);

    expect(game.curPly.name, 'Test1');
    expect(game.canUndo, true);
    expect(game.canRedo, false);
    expect(game.turnBuilder.first, Hit.bull);

    expect(game.hasGameEnded, false);
    
    game.onThrow(Hit.miss);
    game.onThrow(Hit.miss);
    
    expect(game.turnBuilder.done, true);

    game.undo();
    expect(game.canRedo, true);
    expect(game.turnBuilder.done, false);
    game.redo();

    expect(game.turnBuilder.done, true);

    game.next();
  });
}