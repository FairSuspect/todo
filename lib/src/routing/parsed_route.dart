/// A route path that has been parsed by [TemplateRouteParser].
class ParsedRoute {
  String? todoId;
  bool main;
  ParsedRoute(this.main, this.todoId);
  ParsedRoute.main()
      : main = true,
        todoId = null;
  ParsedRoute.createTodo()
      : main = false,
        todoId = null;
  ParsedRoute.editTodo(String id)
      : main = false,
        todoId = id;
}
