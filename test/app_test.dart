import 'package:cross_platform/pages/game/game_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  try {
    testWidgets('testGame', (WidgetTester tester) async {
      await runApp(MaterialApp(home: GamePage()));
      final titleFinder = find.text('Hangman');
      expect(titleFinder, findsOneWidget);
      final finder = find.byKey(Key('keyAt'));
      print(finder);
      expect(finder, findsNothing);
      var index = 0;
      print(find.widgetWithText(FlatButton, 'Exit').skipOffstage);
      while (index < 6) {
        await tester.tap(find.text(String.fromCharCodes([65 + index])));
        index++;
        expect(finder, findsNothing);
      }
    });
  } catch (e, s) {
    print(s);
  }
}
