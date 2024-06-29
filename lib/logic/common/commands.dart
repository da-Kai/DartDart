abstract class Command {
  Command? next;
  Command? previous;

  void execute();

  void undo();

  bool get hasNext => next != null;
  bool get hasPrevious => next != null;
}

/// History of a games actions.
class CommandStack {
  Command? first;
  Command? last;
  Command? current;

  void execute(Command command) {
    command.execute();

    if (current != null) {
      final cur = current!;
      command.previous = cur;
      cur.next = command;
    } else {
      first = command;
    }

    current = command;
    last = command;
  }

  void undo() {
    if (current != null) {
      final cur = current!;
      cur.undo();
      current = cur.previous;
    }
  }

  void redo() {
    if (current != null && current!.hasNext) {
      final next = current!.next!;
      next.execute();
      current = next;
    }
    else if (current == null && first != null) {
      final next = first!;
      next.execute();
      current = next;
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

  @override
  String toString() {
    if(first == null) return '[]';
    var cur = first;

    final List<String> commands = [];
    do {
      commands.add(cur == current ? //
      '(${cur.runtimeType})' : '${cur.runtimeType}');
      cur = cur!.next;
    } while(cur != null);
    return '[${commands.join(', ')}]';
  }
}
