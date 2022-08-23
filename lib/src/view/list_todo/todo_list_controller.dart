import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/src/models/todo.dart';
import 'package:todo/src/services/firebase/firebase.dart';
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
    final Todo? newTodo = await Navigation()
        .key
        .currentState!
        .push<Todo?>(MaterialPageRoute(builder: (_) {
      if (selectedTodo != null) {
        Analytics.logEditTodoScreenView();
      } else {
        Analytics.logCreateTodoScreenView();
      }
      return ChangeNotifierProvider(
          create: (context) => CreateTodoController(
                todo: selectedTodo,
              ),
          child: const CreateTodoScreen());
    }));
    Analytics.logMainScreenView();
    if (newTodo == null) {
      selectedIndex = null;
      return;
    }
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
  Future<void> onChecked(int index, bool? value) async {
    todos[index] = todos[index].copyWith(done: value ?? false);
    notifyListeners();
    localService.updateValue(todos[index]);
    await service.updateTodo(todos[index]);
    if (value == true) {
      Analytics.logTodoCompleted();
    }
    await onRevisionUpdated(service.lastKnownRevision);
  }

  @override
  Future<void> onDelete(int index) async {
    final deletedId = todos.removeAt(index).id;
    notifyListeners();
    localService.deleteValue(deletedId!);
    await service.deleteTodo(deletedId);
    Analytics.logTodoDeleted();

    await onRevisionUpdated(service.lastKnownRevision);
  }

  @override
  Future<void> getTodos() async {
    try {
      final remoteTodos = await service.getItemList();
      final localTodos = await localService.getAll();
      if (service.lastKnownRevision > localService.lastKnownRevision) {
        todos = remoteTodos;
        localService.putList(remoteTodos);
        onRevisionUpdated(service.lastKnownRevision);
      } else {
        todos = localTodos;
        service.patchList(todos);
      }
    } on DioError {
      todos = await localService.getAll();
    } finally {
      notifyListeners();
    }
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
  Future<void> createTodo(Todo todo) async {
    final dateCreated = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    todo = todo.copyWith(
        id: const Uuid().v4(),
        lastUpdatedBy: "debug",
        createdAt: dateCreated,
        changedAt: dateCreated);
    todos.add(todo);
    notifyListeners();

    localService.createValue(todo);
    await service.createTodo(todo);
    Analytics.logTodoCreated();
    await onRevisionUpdated(service.lastKnownRevision);
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    todos[selectedIndex!] = todo;
    notifyListeners();
    localService.updateValue(selectedTodo!);
    await service.updateTodo(selectedTodo!);
    await onRevisionUpdated(service.lastKnownRevision);
  }

  Future<void> onRevisionUpdated(int revision) async {
    await localService.storeRevision(revision);
  }
}
