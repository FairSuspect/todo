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
  return TodoListManager(
    state: ref.watch(todoListStateProvider.notifier),
    filterState: ref.read(filterProvider),
    repository: TodoRepository(
      remoteService: TodoService(),
      localService: HiveService(),
    ),
  );
});

class TodoListManager implements TodoListBaseController {
  TodoListManager({
    required this.state,
    required this.filterState,
    required this.repository,
  }) {
    getTodos();
  }
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
    final todos = await TodoService().getItemList();
    state.updateList(todos);
  }

  @override
  Future<void> onChecked(int index, bool? value) async {
    final todo = state.onChecked(index, value);
    repository.putTodo(todo);
  }

  @override
  void delete(Todo todo) {
    final deletedTodo = state.deleteTodo(todo);
    repository.deleteTodo(deletedTodo.id!);
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
    StateNotifierProvider<TodoListStateHolder, List<Todo>>((ref) {
  return TodoListStateHolder([]);
});

class TodoListStateHolder extends StateNotifier<List<Todo>> {
  TodoListStateHolder(super.state);

  int get completedCount => state.where((todo) => todo.done).length;
  void updateList(List<Todo> todos) {
    state = todos;
  }

  Todo deleteTodo(Todo todo) {
    final isDeleted = state.remove(todo);
    if (!isDeleted) {
      throw StateError("Не удалось удалить элемент из состояния");
    }
    return todo;
  }

  void createTodo(Todo todo) {
    state.add(todo);
  }

  void updateTodo(Todo todo) {
    final index = state.indexWhere((element) => element.id == todo.id);
    state[index] = todo;
  }

  Todo onChecked(int index, bool? value) {
    state[index] = state[index].copyWith(done: value ?? false);
    return state[index];
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

class FilteredTodosNotifier extends StateNotifier<List<Todo>> {
  FilteredTodosNotifier(super.state);
}

final filteredTodosProvider = StateProvider<List<Todo>>((ref) {
  final todos = ref.watch(todoListStateProvider);
  // Если фильтр включён - возвращаем отфильтрованные
  if (ref.watch(filterProvider)) {
    return todos.where((todo) => !todo.done).toList();
  }
  // Иначе возвращаем все

  return todos.toList();
});
