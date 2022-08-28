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
    testWidgets(
      "Render main page with 2 todos",
      (widgetTester) async {
        await app.main();
        // Время на выполнение запроса
        await widgetTester.pumpAndSettle(const Duration(seconds: 3));

        final textWidgetsFinder = find.byType(Text);
        final todoTileFinder = find.byType(TodoTile);
        final textFieldFinder = find.byType(TextField);
        final fabFinder = find.byType(FloatingActionButton);

        await widgetTester.scrollUntilVisible(textFieldFinder, 100);
        expect(todoTileFinder, findsWidgets);
        expect(textWidgetsFinder, findsWidgets);
        expect(textFieldFinder, findsOneWidget);
        expect(fabFinder, findsOneWidget);

        // Выбираем любую задачу (здесь последнюю)
        await widgetTester.tap(todoTileFinder.last);
        await widgetTester.pumpAndSettle(const Duration(seconds: 1));
        const text = 'Edited text';
        // Меняем текст
        await widgetTester.enterText(textFieldFinder, text);
        await widgetTester.pumpAndSettle(const Duration(milliseconds: 600));

        // Меняем важность
        final dropDownFinder = find.byType(DropdownButton<Importance>);
        await widgetTester.tap(dropDownFinder);
        await widgetTester.pumpAndSettle(const Duration(milliseconds: 600));

        final importantFinder = find
            .byWidgetPredicate((widget) => widget is ImportantDropDownChild)
            .last;
        await widgetTester.tap(importantFinder);
        await widgetTester.pumpAndSettle(const Duration(milliseconds: 600));

        // Сохраняем
        final saveButton = find.byType(TextButton);
        await widgetTester.tap(saveButton);
        await widgetTester.pumpAndSettle(const Duration(milliseconds: 600));
        // Ищем отредактированную задачу
        final newTextFinder = find.text(text);
        expect(newTextFinder, findsOneWidget);
      },
    );
  });
}
