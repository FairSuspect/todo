import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:todo/main.dart' as app;
import 'package:todo/src/models/todo.dart';
import 'package:todo/src/view/create_todo/create_todo_screen.dart';
import 'package:todo/src/view/todo_tile.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets("Render main page with 2 todos", (widgetTester) async {
      await app.main();
      await widgetTester.pumpAndSettle();
      final testTextFinder = find.text("Test text");
      final textWidgetsFinder = find.byType(Text);
      final todoTileFinder = find.byType(TodoTile);
      final textFieldFinder = find.byType(TextField);
      final fabFinder = find.byType(FloatingActionButton);
      expect(todoTileFinder, findsNWidgets(2));
      expect(textWidgetsFinder, findsWidgets);
      expect(testTextFinder, findsOneWidget);
      expect(textFieldFinder, findsOneWidget);
      expect(fabFinder, findsOneWidget);
    });
    testWidgets(
      "Edit todo",
      (widgetTester) async {
        await app.main();
        await widgetTester.pumpAndSettle();
        final testTextFinder = find.text("Test text");

        await widgetTester.tap(testTextFinder);
        await widgetTester.pumpAndSettle();
        final textFieldFinder = find.byType(TextFormField);
        const text = 'Edited text';
        await widgetTester.enterText(textFieldFinder, text);
        final dropDownFinder = find.byType(DropdownButton<Importance>);
        await widgetTester.tap(dropDownFinder);
        await widgetTester.pumpAndSettle();
        final importantFinder = find
            .byWidgetPredicate((widget) => widget is ImportantDropDownChild)
            .last;
        await widgetTester.tap(importantFinder);
        await widgetTester.pumpAndSettle();
        final saveButton = find.byType(TextButton);
        await widgetTester.tap(saveButton);
        await widgetTester.pumpAndSettle();
        final newTextFinder = find.text(text);
        expect(newTextFinder, findsOneWidget);
        expect(testTextFinder, findsNothing);
      },
    );
  });
}
