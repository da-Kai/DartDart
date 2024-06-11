import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/main.dart';
import 'package:dart_dart/widget/x01/board_select.dart';
import 'package:dart_dart/widget/x01/number_field_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> press(WidgetTester tester, Hit hit) async {
  var buttons = find.byType(HitButton).evaluate().map((e) => e.widget as HitButton);
  var button = buttons.firstWhere((b) => b.hit == hit);
  
  await tester.tap(find.byWidget(button));
}

void main() {
  group('Test X01', () {
    testWidgets('Smoke Test Home Screen', (WidgetTester tester) async {
      await tester.pumpWidget(const DartDart());

      expect(find.text('X01'), findsOneWidget);

      var x01Button = find.text('X01');
      await tester.tap(x01Button);
      await tester.pumpAndSettle();

      expect(find.text('X01-Game'), findsOneWidget);
      var addPlayerButton = find.byIcon(Icons.add);
      await tester.tap(addPlayerButton);
      await tester.pumpAndSettle();

      var alertDialog = find.byType(AlertDialog);
      expect(alertDialog, findsOneWidget);
      var alert = tester.widget(alertDialog) as AlertDialog;
      var alertScroll = alert.content! as SingleChildScrollView;
      var alertInput = alertScroll.child! as TextField;
      var alertControl = alertInput.controller!;

      alertControl.text = 'Name';

      var findOkButton = find.text('OK');
      expect(findOkButton, findsOneWidget);
      await tester.tap(findOkButton);
      await tester.pumpAndSettle();

      var findStartButton = find.text('Start');
      expect(findStartButton, findsOneWidget);
      await tester.tap(findStartButton);
      await tester.pumpAndSettle();

      expect(find.text('301'), findsAny);
      
      var findDartBoard = find.byType(BoardSelect);
      expect(findDartBoard, findsOneWidget);

      await tester.tap(find.text('FIELD'));
      await tester.pumpAndSettle();

      /// Round 1
      await tester.tap(find.text('x3'));
      await tester.pumpAndSettle();

      var tripleTwenty = Hit.get(HitNumber.twenty, HitMultiplier.triple);
      var tripleNineteen = Hit.get(HitNumber.nineteen, HitMultiplier.triple);
      var doubleTwo = Hit.get(HitNumber.two, HitMultiplier.double);

      await press(tester, tripleTwenty);
      await press(tester, tripleTwenty);
      await press(tester, tripleTwenty);
      await tester.pumpAndSettle();

      expect(find.text((301 - 180).toString()), findsOneWidget);
      await tester.tap(find.text('next'));
      await tester.pumpAndSettle();

      /// Round 2 (Overthrow)
      await press(tester, tripleTwenty);
      await press(tester, tripleTwenty);
      await press(tester, tripleTwenty);
      await tester.pumpAndSettle();

      expect(find.text((301 - 180).toString()), findsOneWidget);
      await tester.tap(find.text('next'));
      await tester.pumpAndSettle();

      /// Round 3
      await press(tester, tripleTwenty);
      await press(tester, tripleNineteen);

      await tester.tap(find.text('x2'));
      await tester.pumpAndSettle();

      await press(tester, doubleTwo);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsOneWidget);
      await tester.tap(find.text('next'));
      await tester.pumpAndSettle();

      /// Finish
      expect(find.text('Congratulations'), findsOneWidget);
      await tester.tap(find.text('QUIT'));
      await tester.pumpAndSettle();

      expect(find.text('X01-Game'), findsOneWidget);
    });
  });
}
