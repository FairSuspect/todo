import 'package:flutter/material.dart';
import 'package:todo/src/models/todo.dart';
import 'package:todo/src/services/navigation.dart';

import 'create_todo_base_controller.dart';

class CreateTodoController extends ChangeNotifier
    implements CreateTodoBaseController {
  @override
  Todo? todo;
  CreateTodoController({this.todo}) {
    todo ??= const Todo(text: '');
  }

  @override
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void setImportance(Importance? value) {
    todo = todo?.copyWith(importance: value!);
    notifyListeners();
  }

  @override
  void setText(String value) {
    todo = todo?.copyWith(text: value);
  }

  @override
  void setDeadline(DateTime dateTime) {
    todo = todo?.copyWith(deadline: dateTime);
    notifyListeners();
  }

  @override
  Future<void> onDeadlineSwitchChanged(BuildContext context, bool value) async {
    if (!value) {
      todo = todo!.copyWith(deadline: null);
      notifyListeners();
      return;
    }
    pickDeadline(context);
  }

  @override
  Future<void> pickDeadline(BuildContext context) async {
    final DateTime? dateTime = await showDatePicker(
        context: context,
        initialDate:
            todo?.deadline ?? DateTime.now().add(const Duration(hours: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365 * 2)));
    if (dateTime == null) return;
    setDeadline(dateTime);
  }

  @override
  void onTextSaved(String? value) {
    value = value!.trim();
    todo = todo!.copyWith(text: value);
  }

  @override
  void save() {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    Navigation().key.currentState!.pop(todo);
  }

  @override
  bool get canBeDeleted => todo?.id != null;

  @override
  void delete() {
    Navigation().key.currentState!.pop(todo!.copyWith(text: ''));
  }
}
