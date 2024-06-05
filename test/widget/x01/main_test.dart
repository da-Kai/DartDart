import 'package:flutter_test/flutter_test.dart';

import 'package:dart_dart/main.dart';

void main() {
  group('Test X01', () {
    testWidgets('Smoke Test Home Screen', (WidgetTester tester) async {
      await tester.pumpWidget(const DartDart());

      expect(find.text('X01'), findsOneWidget);

      await tester.press(find.text('X01'));
    });
  });
}
