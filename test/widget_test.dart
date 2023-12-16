import 'package:flutter_test/flutter_test.dart';

import 'package:dart_dart/main.dart';

void main() {
  testWidgets('home smoke test', (WidgetTester tester) async {
    // Build my app and trigger a frame.
    await tester.pumpWidget(const DartDart());

    expect(find.text('X01'), findsOneWidget);
    expect(find.text('Cricket'), findsOneWidget);
  });
}
