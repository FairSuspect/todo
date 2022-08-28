import 'package:todo/src/models/todo.dart';

abstract class TodoListBaseController {
  Todo? selectedTodo;

  Future<void> onFABPressed();

  void onChecked(String id, bool? value);

  void delete(String id);

  Future<void> getTodos();

  void onTodoSelected(Todo todo);

  void createTodo(Todo todo);

  void updateTodo(Todo todo);

  void createTodoFromText(String text);

  void openTodoEditor();
}
