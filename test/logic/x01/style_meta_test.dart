import 'package:dart_dart/logic/common/style_meta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../common/coordinate_test.dart';

void main() {
  test('Test Style Meta', () {
    expect(Colors.black, PlayerColors.get(0, true));
    expect(Colors.black, PlayerColors.get(0, false));

    for (int i = 1; i <= 6; i++) {
      final darkCol = PlayerColors.get(i, true);
      final lightCol = PlayerColors.get(i, false);

      expectNot(darkCol, lightCol);

      final darkNext = PlayerColors.get(i+1, true);
      final lightNext = PlayerColors.get(i+1, false);

      expectNot(darkCol, darkNext);
      expectNot(lightCol, lightNext);
    }

    expect(Colors.black, PlayerColors.get(7, true));
    expect(Colors.black, PlayerColors.get(8, true));
    expect(Colors.black, PlayerColors.get(7, false));
    expect(Colors.black, PlayerColors.get(8, false));
  });
}