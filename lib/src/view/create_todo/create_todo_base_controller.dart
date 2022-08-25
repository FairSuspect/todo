import 'package:flutter/material.dart';
import 'package:todo/src/models/todo.dart';

abstract class CreateTodoBaseController {
  GlobalKey<FormState> get formKey;

  void setActiveTodo(Todo? todo);

  void setImportance(Importance? value);

  Future<void> onDeadlineSwitchChanged(BuildContext context, bool value);

  void pickDeadline(BuildContext context);

  void onTextSaved(String? value);

  void save();

  Future<bool> onWillPop();
}
