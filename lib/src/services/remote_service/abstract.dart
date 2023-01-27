abstract class TodoService<T> {
  Future<T> getItemById(String id);
  Future<List<T>> getItemList();
  Future<List<T>> patchList(List<T> todos);
  Future<T> createTodo(T todo);
  Future<T> updateTodo(T todo);
  Future<T> deleteTodo(String id);
  int get lastKnownRevision;
}
