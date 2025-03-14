import 'package:dart_dart/logic/constant/fields.dart';
import 'package:dart_dart/main.dart';
import 'package:dart_dart/widget/x01/board_select.dart';
import 'package:dart_dart/widget/x01/number_field_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const vertical = Size(1080, 1920);
const horizontal = Size(1920, 1080);

Future<void> press(WidgetTester tester, HitNumber number, HitMultiplier multiplier) async {
  final hit = Hit.get(number, multiplier);

  final multButton = find.text(hit.multiplier.text);
  await tester.tap(multButton);
  await tester.pumpAndSettle();

  final buttons = find.byType(HitButton).evaluate().map((e) => e.widget as HitButton);
  final button = buttons.firstWhere((b) => b.hit == hit);

  await tester.tap(find.byWidget(button));
  await tester.pumpAndSettle();
}

Future<void> rotate(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(vertical);
  await tester.pumpAndSettle();
  await tester.binding.setSurfaceSize(horizontal);
  await tester.pumpAndSettle();
}

Future<void> addPlayer(WidgetTester tester, String playerName) async {
  final addPlayerButton = find.byIcon(Icons.add);
  await tester.tap(addPlayerButton);
  await tester.pumpAndSettle();

  final alertDialog = find.byType(AlertDialog);
  expect(alertDialog, findsOneWidget);
  final alert = tester.widget(alertDialog) as AlertDialog;
  final alertScroll = alert.content! as SingleChildScrollView;
  final alertInput = alertScroll.child! as TextField;
  final alertControl = alertInput.controller!;

  alertControl.text = playerName;

  final findOkButton = find.text('OK');
  expect(findOkButton, findsOneWidget);
  await tester.tap(findOkButton);
  await tester.pumpAndSettle();
}

void main() {
  group('Smoke Test X01', () {
    testWidgets('2 Player Game', (WidgetTester tester) async {
      await tester.pumpWidget(const DartDart());

      await rotate(tester);

      expect(find.text('X01'), findsOneWidget);

      final x01Button = find.text('X01');
      await tester.tap(x01Button);
      await tester.pumpAndSettle();

      expect(find.text('X01-Game'), findsOneWidget);

      await rotate(tester);

      await addPlayer(tester, 'Player01');
      await addPlayer(tester, 'Player02');

      final findStartButton = find.text('Start');
      expect(findStartButton, findsOneWidget);
      await tester.tap(findStartButton);
      await tester.pumpAndSettle();

      expect(find.text('301'), findsAny);

      await rotate(tester);

      final findDartBoard = find.byType(BoardSelect);
      expect(findDartBoard, findsOneWidget);

      await tester.tap(find.text('FIELD'));
      await tester.pumpAndSettle();

      /// Player 1 - Round 1
      await press(tester, HitNumber.twenty, HitMultiplier.triple);
      await press(tester, HitNumber.twenty, HitMultiplier.triple);
      await press(tester, HitNumber.twenty, HitMultiplier.triple);

      expect(find.text((301 - 180).toString()), findsOneWidget);
      await tester.tap(find.text('next'));
      await tester.pumpAndSettle();

      /// Player 2 - Round 1
      await press(tester, HitNumber.miss, HitMultiplier.single);
      await press(tester, HitNumber.miss, HitMultiplier.single);
      await press(tester, HitNumber.miss, HitMultiplier.single);

      await tester.tap(find.text('next'));
      await tester.pumpAndSettle();

      /// Player 1 - Round 2 (Overthrow)
      await press(tester, HitNumber.twenty, HitMultiplier.triple);
      await press(tester, HitNumber.twenty, HitMultiplier.triple);
      await press(tester, HitNumber.twenty, HitMultiplier.triple);

      expect(find.text((301 - 180).toString()), findsOneWidget);
      await tester.tap(find.text('next'));
      await tester.pumpAndSettle();

      /// Player 2 - Round 2
      await press(tester, HitNumber.miss, HitMultiplier.single);
      await press(tester, HitNumber.miss, HitMultiplier.single);
      await press(tester, HitNumber.miss, HitMultiplier.single);

      await tester.tap(find.text('next'));
      await tester.pumpAndSettle();

      /// Player 1 - Round 3 (Win)
      await press(tester, HitNumber.twenty, HitMultiplier.triple);
      await press(tester, HitNumber.nineteen, HitMultiplier.triple);
      await press(tester, HitNumber.two, HitMultiplier.double);

      expect(find.byIcon(Icons.check), findsOneWidget);
      await tester.tap(find.text('done'));
      await tester.pumpAndSettle();

      /// Finish
      expect(find.text('Statistics'), findsOneWidget);
      expect(find.text('1/1'), findsOneWidget);
      expect(find.text('0/0'), findsOneWidget);
      expect(find.text('50.0%'), findsOneWidget);
      expect(find.text('140.33'), findsAtLeast(2));
    });
  });
}
