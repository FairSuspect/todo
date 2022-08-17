import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo/src/models/todo.dart';
import 'package:todo/src/services/local_service/local_service.dart';
import 'package:todo/src/services/remote_service/todo_service.dart';

abstract class TodoListBaseController {
  Todo? selectedTodo;

  Future<void> onFABPressed();

  void onChecked(int index, bool? value);

  void delete(Todo todo);

  Future<void> getTodos();

  void onTodoSelected(Todo todo);

  void createTodo(Todo todo);

  void updateTodo(Todo todo);

  void createTodoFromText(String text);
}
