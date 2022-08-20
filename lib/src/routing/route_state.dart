import 'package:flutter/material.dart';

class RouteState extends ChangeNotifier {
  String? _todoId;
  bool _isMain;

  RouteState(this._isMain, this._todoId);

  bool get isMain => _isMain;

  set isMain(bool isMain) {
    if (isMain == _isMain) return;
    _isMain = isMain;
    notifyListeners();
  }

  String? get todoId => _todoId;

  set todoId(String? todoId) {
    // Если todoId не обновился - не обновляем страницу
    if (todoId == _todoId) return;
    _todoId = todoId;
    notifyListeners();
  }

  @override
  String toString() {
    return "RouteState(isMain: $isMain,todoId: $todoId)";
  }
}
