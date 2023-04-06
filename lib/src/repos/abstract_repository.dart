abstract class TodoBaseRepository<T> {
  Future<void> createTodo(T todo);
  Future<void> getTodoList();
  Future<void> getTodo(String id);
  Future<void> deleteTodo(String id);
  Future<void> patchList(List<T> todos);
  Future<void> putTodo(T todo);
}
