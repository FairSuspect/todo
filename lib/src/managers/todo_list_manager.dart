import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/src/repos/todo_repository.dart';
import 'package:todo/src/services/local_service/hive.dart';
import 'package:todo/src/services/navigation.dart';
import 'package:todo/src/services/remote_service/todo_service.dart';
import 'package:todo/src/models/todo.dart';
import 'package:todo/src/view/create_todo/create_todo_screen.dart';

import 'package:todo/src/view/list_todo/todo_list_base_controller.dart';

final todoListManagerProvider = Provider((ref) {
  final todoListManager = TodoListManager(
    state: ref.watch(todoListStateProvider.notifier),
    filterState: ref.read(filterProvider),
    repository: TodoRepository(
      remoteService: RemoteTodoService(),
      localService: HiveService(),
    ),
  );
  todoListManager.getTodos();
  return todoListManager;
});

class TodoListManager implements TodoListBaseController {
  TodoListManager({
    required this.state,
    required this.filterState,
    required this.repository,
  });
  final TodoListStateHolder state;

  // /// Состояние фильтра. Если `true`, значит фильтр включён => выполненные задачи скрыты.
  // /// В противном случае фильтр выключен,
  final bool filterState;

  /// Репозиторий с данными о задачах
  final TodoRepository repository;

  @override
  Todo? selectedTodo;

  @override
  void createTodo(Todo todo) {
    state.createTodo(todo);

    repository.createTodo(todo);
  }

  @override
  void createTodoFromText(String text) {
    final Todo todo = Todo.createFromText(text: text);
    state.createTodo(todo);
    repository.createTodo(todo);
  }

  @override
  Future<void> getTodos() async {
    final todos = await repository.getTodoList();

    state.updateMap(todos);
  }

  @override
  Future<void> onChecked(String id, bool? value) async {
    final todo = state.onChecked(id, value);
    repository.putTodo(todo);
  }

  @override
  void delete(String id) {
    final deletedTodo = state.deleteTodo(id);
    repository.deleteTodo(deletedTodo.id);
  }

  @override
  Future<void> onFABPressed() async {
    final Todo? newTodo = await Navigation().key.currentState!.push<Todo?>(
        MaterialPageRoute(builder: (_) => const CreateTodoScreen()));
    if (newTodo == null) {
      selectedTodo = null;
      return;
    }
    if (selectedTodo == null) {
      createTodo(newTodo);
      return;
    } else {
      updateTodo(newTodo);
      selectedTodo = null;
      return;
    }
  }

  @override
  void onTodoSelected(Todo todo) {
    selectedTodo = todo;
    onFABPressed();
  }

  @override
  void updateTodo(Todo todo) {
    state.updateTodo(todo);
    repository.putTodo(todo);
  }
}

final todoListStateProvider =
    StateNotifierProvider<TodoListStateHolder, Map<String, Todo>>((ref) {
  return TodoListStateHolder({});
});

class TodoListStateHolder extends StateNotifier<Map<String, Todo>> {
  TodoListStateHolder(super.state);

  int get completedCount => state.entries.where((e) => e.value.done).length;

  void updateMap(Map<String, Todo> todos) {
    state = todos;
  }

  Todo deleteTodo(String id) {
    final stateCopy = Map<String, Todo>.from(state);

    final deletedTodo = stateCopy.remove(id);
    state = stateCopy;

    return deletedTodo!;
  }

  void createTodo(Todo todo) {
    final stateCopy = Map<String, Todo>.from(state);
    stateCopy[todo.id] = todo;
    state = stateCopy;
  }

  void updateTodo(Todo todo) {
    final stateCopy = Map<String, Todo>.from(state);
    stateCopy[todo.id] = todo;
    state = stateCopy;
  }

  Todo onChecked(String id, bool? value) {
    final stateCopy = Map<String, Todo>.from(state);
    final newTodo = stateCopy[id]!.copyWith(done: value ?? false);
    stateCopy[id] = newTodo;
    state = stateCopy;

    return newTodo;
  }
}

/// Провайдер фильтра задач по состоянию.
/// Если `true`, то фильтр включён и показываются только невыполненные задачи.
/// В противном случае фильтр выключен и показываются все задачи
final filterProvider = StateNotifierProvider<FilterStateHolder, bool>(
    (ref) => FilterStateHolder(false));

class FilterStateHolder extends StateNotifier<bool> {
  FilterStateHolder(super.state);

  /// Переключение состояния фильтра
  void onChecked() {
    state = !state;
  }
}

final filterManagerProvider = Provider((ref) {
  return FilterMananger(ref.watch(filterProvider.notifier));
});

class FilterMananger {
  final FilterStateHolder state;

  FilterMananger(this.state);
  void onChecked() {
    state.onChecked();
  }
}

class FilteredTodosNotifier extends StateNotifier {
  FilteredTodosNotifier(super.state);
}

final filteredTodosProvider = StateProvider<Map<String, Todo>>((ref) {
  final todos = ref.watch(todoListStateProvider);
  // Если фильтр включён - возвращаем отфильтрованные
  if (ref.watch(filterProvider)) {
    final iterable = todos.values.where((e) => !e.done);
    return Map.fromIterables(iterable.map((e) => e.id), iterable);
  }
  // Иначе возвращаем все

  return todos;
});
