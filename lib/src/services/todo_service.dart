import 'package:todo/src/api/api.dart';
import 'package:todo/src/models/todo.dart';

class TodoService {
  static TodoService? _instance;

  factory TodoService() => _instance ??= TodoService._();

  TodoService._();

  Future<Todo> getItemById(int id) async {
    final response = await Api().dio.get('list/$id');

    return Todo.fromJson(response.data);
  }

  Future<List<Todo>> getItemList() async {
    final response = await Api().dio.get('lib');

    return Todo.listFromJson(response.data);
  }

  Future<List<Todo>> patchList(List<Todo> todos) async {
    final data = todos.map((e) => e.toJson()).toList();
    final response = await Api().dio.patch('/list', data: data);
    return Todo.listFromJson(response.data);
  }

  Future<Todo> createTodo(Todo todo) async {
    final response = await Api().dio.post('/list', data: todo.toJson());
    return Todo.fromJson(response.data);
  }

  Future<Todo> updateTodo(Todo todo) async {
    final response =
        await Api().dio.put('/list/${todo.id}', data: todo.toJson());
    return Todo.fromJson(response.data);
  }

  Future<Todo> deleteTodo(int id) async {
    final response = await Api().dio.delete('/list/$id');
    return Todo.fromJson(response.data);
  }
}
