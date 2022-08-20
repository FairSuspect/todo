import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:todo/src/services/navigation.dart';
import 'package:todo/src/view/create_todo/create_todo_screen.dart';
import 'package:todo/src/view/list_todo/todo_list_screen.dart';

import 'route_state.dart';
import 'parsed_route.dart';

class TodoRouterDelegate extends RouterDelegate<ParsedRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<ParsedRoute> {
  RouteState state = RouteState(true, null);

  void gotoMain() {
    state
      ..isMain = true
      ..todoId = null;
    notifyListeners();
  }

  void gotoTodo(String id) {
    state
      ..isMain = false
      ..todoId = id;
    notifyListeners();
  }

  void gotoCreateTodo() {
    state
      ..isMain = false
      ..todoId = null;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    Logger("Route Delegate").log(Level.INFO, "Notifiying listners with $state");
    super.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    Logger("Route Delegate").log(Level.INFO, "Navigator rebuilt with $state");
    return Navigator(
      onPopPage: (route, result) => route.didPop(result),
      // transitionDelegate: BookshelfTransitionDelegate(),
      key: Navigation().key,
      pages: [
        // Главная страница всегда отрисовывается для pop из страницы редактирования
        const MaterialPage(
          child: TodoListScreen(),
        ),
        if (!state.isMain)
          MaterialPage(
            child: CreateTodoScreen(todoId: state.todoId),
          ),
      ],
    );
  }

  @override
  ParsedRoute? get currentConfiguration {
    return ParsedRoute(state.isMain, state.todoId);
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => GlobalKey();
  @override
  Future<void> setInitialRoutePath(ParsedRoute configuration) {
    return super.setInitialRoutePath(ParsedRoute(true, null));
  }

  @override
  Future<void> setNewRoutePath(ParsedRoute configuration) {
    state.todoId = configuration.todoId;
    state.isMain = configuration.main;
    return Future.value();
  }
}
