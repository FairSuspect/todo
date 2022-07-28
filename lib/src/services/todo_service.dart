import 'package:dio/dio.dart';
import 'package:todo/src/api/api.dart';
import 'package:todo/src/models/todo.dart';
import 'package:uuid/uuid.dart';

class TodoService {
  static TodoService? _instance;

  factory TodoService() => _instance ??= TodoService._();

  TodoService._();
  int lastKnownRevision = 0;

  Future<Todo> getItemById(int id) async {
    final response = await Api().dio.get('/list/$id');

    return Todo.fromJson(response.data);
  }

  Future<List<Todo>> getItemList() async {
    final response = await Api().dio.get('/list');

    lastKnownRevision = response.data['revision'];
    return Todo.listFromJson(response.data['list']);
  }

  Future<List<Todo>> patchList(List<Todo> todos) async {
    final data = todos.map((e) => e.toJson()).toList();
    final response = await Api().dio.patch('/list', data: data);
    return Todo.listFromJson(response.data);
  }

  Future<Todo> createTodo(Todo todo) async {
    todo = todo.copyWith(
        id: (lastKnownRevision + 1).toString(),
        lastUpdatedBy: const Uuid().v4());
    final todoJson = todo.toJson();
    final response = await Api().dio.post('/list',
        data: {"element": todoJson},
        options:
            Options(headers: {'X-Last-Known-Revision': lastKnownRevision}));
    lastKnownRevision = response.data['revision'];
    return Todo.fromJson(response.data['element']);
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

  Map assembleRequest(Todo model, {int? revision}) {
    Map<String, dynamic> request = {"element": model.toJson(), "status": "ok"};

    if (revision != null) request['revision'] = revision;
    return request;
  }
}
