import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/src/models/todo.dart';
import 'package:todo/src/services/local_service/abstract_local_service.dart';
import 'package:todo/src/services/navigation.dart';
import 'package:todo/src/services/remote_service/remote_service.dart';
import 'package:todo/src/view/create_todo/create_todo_controller.dart';
import 'package:uuid/uuid.dart';

import '../create_todo/create_todo_screen.dart';
import 'todo_list_base_controller.dart';

class TodoListController extends ChangeNotifier
    implements TodoListBaseController {
  TodoListController(this.service, this.localService) {
    getTodos();
  }

  @override
  final TodoService service;
  @override
  final LocalService<Todo> localService;

  @override
  List<Todo> todos = [];

  @override
  bool showDone = true;

  @override
  List<Todo> get filteredTodos =>
      showDone ? todos : todos.where((todo) => !todo.done).toList();

  @override
  Todo? get selectedTodo =>
      selectedIndex != null ? todos[selectedIndex!] : null;
  @override
  int? selectedIndex;

  @override
  void checkVisibility() {
    showDone = !showDone;
    notifyListeners();
  }

  @override
  int get completedCount => todos.where((todo) => todo.done).length;

  @override
  Future<void> onPressed() async {
    final Todo? newTodo =
        await Navigation().key.currentState!.push<Todo?>(MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
                create: (context) => CreateTodoController(
                      todo: selectedTodo,
                    ),
                child: const CreateTodoScreen())));
    if (newTodo == null) return;
    if (selectedTodo == null) {
      createTodo(newTodo);
      return;
    } else {
      updateTodo(newTodo);
      selectedIndex = null;
      return;
    }
  }

  @override
  void onChecked(int index, bool? value) {
    todos[index] = todos[index].copyWith(done: value ?? false);
    notifyListeners();
    service.updateTodo(todos[index]);
  }

  @override
  void onDelete(int index) {
    final deletedId = todos.removeAt(index).id;
    notifyListeners();
    service.deleteTodo(deletedId!);
  }

  @override
  Future<void> getTodos() async {
    todos = await service.getItemList();
    notifyListeners();
  }

  @override
  void onTodoSelected(int index) {
    selectedIndex = index;
    onPressed();
  }

  @override
  void createTodoFromText(String text) {
    final todo = Todo(text: text);
    createTodo(todo);
  }

  @override
  void createTodo(Todo todo) {
    todos.add(todo);
    service.createTodo(todo);
    notifyListeners();
  }

  @override
  void updateTodo(Todo todo) {
    todos[selectedIndex!] = todo;
    notifyListeners();
    service.updateTodo(selectedTodo!);
  }
}
