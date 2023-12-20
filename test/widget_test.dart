import 'package:flutter_test/flutter_test.dart';

import 'package:dart_dart/main.dart';

void main() {
  testWidgets('home smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DartDart());

    expect(find.text('X01'), findsOneWidget);

    await tester.press(find.text('X01'));
  });
}
