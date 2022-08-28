import 'package:flutter/widgets.dart';
import 'package:todo/src/routing/paths.dart';

import 'parsed_route.dart';

class TodoRouteParser extends RouteInformationParser<ParsedRoute> {
  @override
  Future<ParsedRoute> parseRouteInformation(RouteInformation routeInformation) {
    final path = routeInformation.location ?? '';
    final uri = Uri.parse(path);

    if (uri.pathSegments.isEmpty) {
      return Future.value(ParsedRoute.main());
    }
    switch (uri.pathSegments[0]) {
      case Paths.editTodo:
        // case Paths.createTodo:
        if (uri.pathSegments.length > 1 && uri.pathSegments[1].isNotEmpty) {
          final todoId = uri.pathSegments[1];
          return Future.value(ParsedRoute.editTodo(todoId));
        } else {
          return Future.value(ParsedRoute.createTodo());
        }

      case Paths.main:
      default:
        return Future.value(ParsedRoute.main());
    }
  }

  @override
  RouteInformation? restoreRouteInformation(ParsedRoute configuration) {
    if (configuration.main) {
      return const RouteInformation(location: Paths.main);
    }
    if (configuration.todoId == null) {
      return const RouteInformation(location: "/${Paths.createTodo}");
    }
    return RouteInformation(
        location: "/${Paths.editTodo}/${configuration.todoId}");
  }
}
