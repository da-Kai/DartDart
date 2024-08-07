import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/logic/x01/board_select.dart';
import 'package:flutter/cupertino.dart';

class BoardSelect extends StatefulWidget {
  final Function(Hit) onSelect;

  const BoardSelect({super.key, required this.onSelect});

  @override
  State<StatefulWidget> createState() => _BoardSelectState();
}

class _BoardSelectState extends State<BoardSelect> {
  final _gestureKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(),
        child: GestureDetector(
          key: _gestureKey,
          onTapUp: (details) {
            var size = _gestureKey.currentContext!.size!;
            var pos = details.localPosition;

            var norm = GameMath.norm(size, pos);
            var (distance, angle) = GameMath.vectorData(norm);

            var field = Hit.miss;
            if (distance <= 101) {
              field = FieldCalc.getField(angle: angle, distance: distance);
            }

            widget.onSelect(field);
          },
          child: const Image(
            image: AssetImage('assets/images/dart_board-1024.png'),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
