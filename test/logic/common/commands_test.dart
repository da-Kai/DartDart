import 'package:dart_dart/logic/common/commands.dart';
import 'package:flutter_test/flutter_test.dart';

class TestCommand implements Command {
  @override
  Command? next;
  @override
  Command? previous;

  bool executed = false;

  @override
  void execute() {
    executed = true;
  }

  @override
  void undo() {
    executed = false;
  }
}

void main() {
  test('Test Commands', () {
    var stack = CommandStack();

    var cmdOne = TestCommand();
    var cmdTwo = TestCommand();

    expect(stack.canUndo, false);
    expect(stack.canRedo, false);
    expect(cmdOne.executed, false);

    stack.execute(cmdOne);
    expect(cmdOne.executed, true);
    expect(stack.current, cmdOne);
    expect(stack.canUndo, true);
    expect(stack.canRedo, false);

    stack.execute(cmdTwo);
    expect(cmdTwo.executed, true);
    expect(stack.current, cmdTwo);
    expect(stack.canUndo, true);
    expect(stack.canRedo, false);

    stack.undo();
    expect(cmdTwo.executed, false);
    expect(stack.current, cmdOne);
    expect(stack.canUndo, true);
    expect(stack.canRedo, true);

    stack.undo();
    expect(cmdOne.executed, false);
    expect(stack.current, null);
    expect(stack.canUndo, false);
    expect(stack.canRedo, true);

    stack.undo();
    expect(stack.canRedo, true);
    expect(stack.peak(), null);

    stack.redo();
    expect(cmdOne.executed, true);
    expect(cmdTwo.executed, false);
    expect(stack.peak(), cmdOne);

    stack.redo();
    expect(cmdOne.executed, true);
    expect(cmdTwo.executed, true);

    expect(stack.peak(), cmdTwo);
    expect(stack.peak(position: 1), cmdOne);
    expect(stack.peak(position: 2), null);

    stack.clear();
    expect(stack.canRedo, false);
    expect(stack.canUndo, false);
    expect(stack.current, null);
  });
}
