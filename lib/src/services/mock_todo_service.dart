import 'package:todo/src/services/todo_service.dart';
import 'package:uuid/uuid.dart';

import '../models/todo.dart';

class MockTodoService extends TodoService {
  MockTodoService();

  List<Todo> _todos = List.generate(
    20,
    (index) {
      final id = const Uuid().v4();
      final importance = index % 3 == 0
          ? Importance.low
          : index % 3 == 1
              ? Importance.basic
              : Importance.important;
      final deadLine =
          index % 2 == 0 ? null : DateTime.now().add(Duration(days: index));
      return Todo(
          text: "Task #$index",
          id: id,
          importance: importance,
          deadline: deadLine);
    },
  );

  @override
  Future<List<Todo>> getItemList() async {
    return _todos;
  }

  @override
  Future<List<Todo>> patchList(List<Todo> todos) async {
    _todos = todos;
    return _todos;
  }

  @override
  Future<Todo> createTodo(Todo todo) async {
    final dateCreated = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    todo = todo.copyWith(
        id: const Uuid().v4(),
        lastUpdatedBy: "debug",
        createdAt: dateCreated,
        changedAt: dateCreated);
    _todos.add(todo);
    return todo;
  }

  @override
  Future<Todo> updateTodo(Todo todo) async {
    final index = _todos.indexWhere((element) => element.id == todo.id);
    _todos[index] = todo;
    return todo;
  }

  @override
  Future<Todo> deleteTodo(String id) async {
    final index = _todos.indexWhere((element) => element.id == id);
    final removedTodo = _todos.removeAt(index);
    return removedTodo;
  }
}
