import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/main.dart';
import 'package:todo/src/managers/repository_manager.dart';
import 'package:todo/src/models/todo.dart';
import 'package:todo/src/repos/todo_repository.dart';
import 'package:todo/src/services/remote_service/abstract.dart';
import 'package:todo/src/services/local_service/abstract_local_service.dart';
import 'package:todo/src/view/create_todo/create_todo_screen.dart';
import 'package:todo/src/view/todo_tile.dart';

void main() {
  testWidgets("Render main page with 2 todos", (widgetTester) async {
    await widgetTester.pumpWidget(const TestApp());
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
  group("Edit todo:", () {
    testWidgets(
      "text",
      (widgetTester) async {
        await widgetTester.pumpWidget(const TestApp());
        await widgetTester.pumpAndSettle();
        final testTextFinder = find.text("Test text");

        await widgetTester.tap(testTextFinder);
        await widgetTester.pumpAndSettle();
        final textFieldFinder = find.byType(TextFormField);
        const text = 'Edited text';
        await widgetTester.enterText(textFieldFinder, text);
        final saveButton = find.byType(TextButton);
        await widgetTester.tap(saveButton);
        await widgetTester.pumpAndSettle();
        final newTextFinder = find.text(text);
        expect(newTextFinder, findsOneWidget);
        expect(testTextFinder, findsNothing);
      },
    );
    testWidgets(
      "importance",
      (widgetTester) async {
        await widgetTester.pumpWidget(const TestApp());
        await widgetTester.pumpAndSettle();
        final importanceFinder = find.byWidgetPredicate((widget) =>
            widget is LeadingIconByImportance &&
            widget.importance == Importance.important);
        expect(importanceFinder, findsNothing);

        final testTextFinder = find.text("Test text");
        await widgetTester.tap(testTextFinder);
        await widgetTester.pumpAndSettle();

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

        expect(importanceFinder, findsOneWidget);
      },
    );
  });

  group("Cancel", () {
    testWidgets(
      "via CloseButton",
      (widgetTester) async {
        await widgetTester.pumpWidget(const TestApp());
        await widgetTester.pumpAndSettle();
        final testTextFinder = find.text("Test text");

        await widgetTester.tap(testTextFinder);
        await widgetTester.pumpAndSettle();
        final textFieldFinder = find.byType(TextFormField);
        const text = 'Edited text';
        await widgetTester.enterText(textFieldFinder, text);
        final saveButton = find.byType(CloseButton);
        await widgetTester.tap(saveButton);
        await widgetTester.pumpAndSettle();
        final newTextFinder = find.text(text);
        expect(newTextFinder, findsNothing);
        expect(testTextFinder, findsOneWidget);
      },
    );
  });

  group("Delete", () {
    testWidgets(
      "via swipe",
      (widgetTester) async {
        await widgetTester.pumpWidget(const TestApp());
        await widgetTester.pumpAndSettle();
        final testTextFinder = find.text("Test text");
        await widgetTester.drag(testTextFinder, const Offset(-1000, 0));
        await widgetTester.pumpAndSettle();

        final todoTileFinder = find.byType(TodoTile);
        expect(todoTileFinder, findsNWidgets(1));

        expect(testTextFinder, findsNothing);
      },
    );
    testWidgets(
      "via delete button in edit page",
      (widgetTester) async {
        await widgetTester.pumpWidget(const TestApp());
        await widgetTester.pumpAndSettle();
        final testTextFinder = find.text("Test text");

        await widgetTester.tap(testTextFinder);
        await widgetTester.pumpAndSettle();

        final deleteButton = find.byIcon(Icons.delete);
        await widgetTester.tap(deleteButton);
        await widgetTester.pumpAndSettle();
        final todoTileFinder = find.byType(TodoTile);
        expect(todoTileFinder, findsNWidgets(1));

        expect(testTextFinder, findsNothing);
      },
    );
  });
  group("Check", () {
    testWidgets(
      "via checkbox",
      (widgetTester) async {
        await widgetTester.pumpWidget(const TestApp());
        await widgetTester.pumpAndSettle();
        final uncheckedBoxFinder = find.byWidgetPredicate(
            (widget) => widget is Checkbox && widget.value == false);
        final checkedBoxFinder = find.byWidgetPredicate(
            (widget) => widget is Checkbox && widget.value == true);
        expect(uncheckedBoxFinder, findsOneWidget);
        expect(checkedBoxFinder, findsOneWidget);

        await widgetTester.tap(uncheckedBoxFinder);
        await widgetTester.pumpAndSettle();
        expect(uncheckedBoxFinder, findsNothing);
        expect(checkedBoxFinder, findsNWidgets(2));
      },
    );
    testWidgets(
      "via swipe",
      (widgetTester) async {
        await widgetTester.pumpWidget(const TestApp());
        await widgetTester.pumpAndSettle();
        final uncheckedBoxFinder = find.byWidgetPredicate(
            (widget) => widget is Checkbox && widget.value == false);
        final checkedBoxFinder = find.byWidgetPredicate(
            (widget) => widget is Checkbox && widget.value == true);
        expect(uncheckedBoxFinder, findsOneWidget);
        expect(checkedBoxFinder, findsOneWidget);

        await widgetTester.drag(uncheckedBoxFinder, const Offset(1000, 0));
        await widgetTester.pumpAndSettle();
        expect(uncheckedBoxFinder, findsNothing);
        expect(checkedBoxFinder, findsNWidgets(2));
      },
    );
  });
  group("Create", () {
    testWidgets(
      "via FAB",
      (widgetTester) async {
        await widgetTester.pumpWidget(const TestApp());
        await widgetTester.pumpAndSettle();
        final todoTileFinder = find.byType(TodoTile);
        expect(todoTileFinder, findsNWidgets(2));

        final inlineCreateTextField = find.byType(TextField);
        const text = "FAB create";
        await widgetTester.enterText(inlineCreateTextField, text);
        final fabFinder = find.byType(FloatingActionButton);
        await widgetTester.tap(fabFinder);
        await widgetTester.pumpAndSettle();
        final textFieldFinder = find.byType(TextFormField);
        await widgetTester.enterText(textFieldFinder, text);
        final saveButton = find.byType(TextButton);
        await widgetTester.tap(saveButton);
        await widgetTester.pumpAndSettle();
        expect(todoTileFinder, findsNWidgets(3));
        final textFinder = find.text(text);
        expect(textFinder, findsOneWidget);
      },
    );
  });
}

class TestApp extends StatelessWidget {
  const TestApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(overrides: [
      // Override the behavior of repositoryProvider to return
      // FakeRepository instead of Repository.
      repositoryManager.overrideWithValue(Repository())
      // We do not have to override `todoListProvider`, it will automatically
      // use the overridden repositoryProvider
    ], child: const MyApp());
  }
}

class Repository implements TodoRepository {
  Todos todos = {
    '1': Todo(
        id: '1',
        text: "Test text",
        createdAt: DateTime.now().millisecondsSinceEpoch,
        done: false,
        importance: Importance.low),
    '2': Todo(
        id: '2',
        text: "Second text",
        createdAt: DateTime.now().millisecondsSinceEpoch,
        done: true,
        importance: Importance.basic),
  };
  @override
  Future<void> createTodo(Todo todo) async {
    todos[todo.id] = todo;
  }

  @override
  Future<void> deleteTodo(String id) async {
    todos.remove(id);
  }

  @override
  Future<Todo> getTodo(String id) {
    // TODO: implement getTodo
    throw UnimplementedError();
  }

  @override
  Future<Todos> getTodoList() => Future.value(todos);

  @override
  // TODO: implement localService
  LocalService<Todo> get localService => throw UnimplementedError();

  @override
  Future<void> onRevisionUpdated(int revision) {
    // TODO: implement onRevisionUpdated
    throw UnimplementedError();
  }

  @override
  Future<void> patchList(List todos) {
    // TODO: implement patchList
    throw UnimplementedError();
  }

  @override
  Future<void> putTodo(Todo todo) async {
    todos[todo.id] = todo;
  }

  @override
  // TODO: implement remoteService
  TodoService<Todo> get remoteService => throw UnimplementedError();
}

// We expose our instance of Repository in a provider
