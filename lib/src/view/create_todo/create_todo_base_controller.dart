import 'package:flutter/material.dart';
import 'package:todo/src/models/todo.dart';

abstract class CreateTodoBaseController extends ChangeNotifier {
  Todo? todo;

  GlobalKey<FormState> get formKey;

  void setImportance(Importance? value);

  void setText(String value);

  void setDeadline(DateTime dateTime);

  Future<void> onDeadlineSwitchChanged(BuildContext context, bool value);

  Future<void> pickDeadline(BuildContext context);

  void onTextSaved(String? value);

  void save();

  bool get canBeDeleted;
}
