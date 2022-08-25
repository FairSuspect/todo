import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/src/models/todo.dart';
import 'package:todo/src/services/navigation.dart';
import 'package:todo/src/view/create_todo/create_todo_base_controller.dart';

final createTodoManagerProvider = Provider((ref) {
  return CreateTodoManager(ref.watch(createTodoStateHolderProvider.notifier));
});

class CreateTodoManager implements CreateTodoBaseController {
  CreateTodoManager(this.state);
  final CreateTodoStateHolder state;

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
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      state.pop();
    }
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
  Future<bool> onWillPop() async {
    Navigation().key.currentState!.pop();
    state.setState(Todo.blank());
    return false;
  }

  @override
  void onDeleteTap() {
    Navigation().key.currentState!.pop();
  }
}

final createTodoStateHolderProvider =
    StateNotifierProvider<CreateTodoStateHolder, Todo>((ref) {
  return CreateTodoStateHolder(Todo.blank());
});

class CreateTodoStateHolder extends StateNotifier<Todo> {
  CreateTodoStateHolder(super.state);

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

  /// Удалять можно только созданные задачи. Такие задачи имеют id
  bool get canBeDeleted => state.createdAt != null;

  void pop() {
    Navigation().key.currentState!.pop(state);
    state = Todo.blank();
  }

  void setImportance(Importance importance) {
    state = state.copyWith(importance: importance);
  }

  void setState(Todo todo) {
    state = todo;
  }
}
