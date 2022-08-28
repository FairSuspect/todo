import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/src/managers/repository_manager.dart';
import 'package:todo/src/models/todo.dart';
import 'package:todo/src/repos/todo_repository.dart';
import 'package:todo/src/services/navigation.dart';
import 'package:todo/src/view/create_todo/create_todo_base_controller.dart';

final createTodoManagerProvider = Provider((ref) {
  return CreateTodoManager(ref.watch(createTodoStateHolderProvider.notifier),
      ref.read(repositoryManager));
});

class CreateTodoManager implements CreateTodoBaseController {
  CreateTodoManager(this.state, this.repository);
  final CreateTodoStateHolder state;
  final TodoRepository repository;

  @override
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Future<void> onDeadlineSwitchChanged(BuildContext context, bool value) async {
    if (!value) {
      state.setDeadline(null);
      return;
    }

    // Отсюда нет доступа к текущему стейту, поэтому выбор дате делегирован состоянию
    state.pickDeadline(context);
  }

  @override
  void onTextSaved(String? value) {
    state.setText(value!);
  }

  @override
  void save() {
    formKey.currentState!.save();
    Navigation().key.currentState!.pop();
  }

  @override
  void setImportance(Importance? importance) {
    if (importance == null) return;
    state.setImportance(importance);
  }

  @override
  void setActiveTodo(Todo? todo) {
    state.setState(todo ?? Todo.blank());
  }

  @override
  void pickDeadline(BuildContext context) {
    state.pickDeadline(context);
  }

  @override
  void onDeleteTap() {
    Navigation().key.currentState!.pop();
  }

  @override
  Future<void> getTodo(String id) async {
    state.setState(await repository.getTodo(id));
  }
}

final createTodoStateHolderProvider =
    StateNotifierProvider<CreateTodoStateHolder, Todo>((ref) {
  return CreateTodoStateHolder(Todo.blank());
});

class CreateTodoStateHolder extends StateNotifier<Todo> {
  CreateTodoStateHolder(super.state);

  final textController = TextEditingController();

  void setText(String text) {
    state = state.copyWith(text: text);
  }

  void setDeadline(DateTime? deadline) {
    state = state.copyWith(deadline: deadline);
  }

  Future<void> pickDeadline(BuildContext context) async {
    final DateTime? dateTime = await showDatePicker(
        context: context,
        initialDate:
            state.deadline ?? DateTime.now().add(const Duration(hours: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365 * 2)));
    if (dateTime == null) return;
    setDeadline(dateTime);
  }

  /// Удалять можно только созданные задачи. Такие задачи имеют время создания
  bool get canBeDeleted => state.createdAt != null;

  void setImportance(Importance importance) {
    state = state.copyWith(importance: importance);
  }

  void setState(Todo todo) {
    if (textController.text != todo.text) {
      textController.text = todo.text;
    }
    state = todo;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
