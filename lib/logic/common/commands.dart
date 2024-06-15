abstract class Command {
  Command? next;
  Command? previous;

  void execute();

  void undo();
}

/// History of a games actions.
class CommandStack {
  Command? first;
  Command? last;
  Command? current;

  void execute(Command command) {
    command.execute();
    if (current != null) {
      current?.next = command;
      command.previous = current;
    } else {
      first = command;
    }
    current = last = command;
  }

  void undo() {
    if (current != null) {
      current!.undo();
      current = current!.previous;
    }
  }

  void redo() {
    if (current != null) {
      if (current!.next != null) {
        var next = current!.next!;
        current = next;
        next.execute();
      }
    } else if (first != null) {
      current = first;
      current!.execute();
    }
  }

  void clear() {
    current = first = last = null;
  }

  Command? peak({position}) {
    if (position == null) return current;
    Command? cmd = last!;
    for (int i = 0; i < position; i++) {
      if (cmd == null) {
        return null;
      }
      cmd = cmd.previous;
    }
    return cmd;
  }

  bool get canUndo => current != null;

  bool get canRedo => last != current;
}
