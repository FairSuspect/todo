import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo/src/models/todo.dart';
import 'package:todo/src/services/todo_service.dart';

abstract class TodoListBaseController extends ChangeNotifier {
  TodoService get service;

  List<Todo> todos = [];

  bool showDone = true;

  List<Todo> get filteredTodos;

  Todo? get selectedTodo;

  int? selectedIndex;

  void checkVisibility();

  int get completedCount;

  Future<void> onPressed();

  void onChecked(int index, bool? value);

  void onDelete(int index);
  Future<void> getTodos();

  void onTodoSelected(int index);
}
