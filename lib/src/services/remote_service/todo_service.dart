import 'package:dio/dio.dart';
import 'package:todo/src/api/api.dart';
import 'package:todo/src/models/todo.dart';

class TodoService {
  int _lastKnownRevision = 0;

  int get lastKnownRevision => _lastKnownRevision;

  set lastKnownRevision(int lastKnownRevision) {
    _lastKnownRevision = lastKnownRevision;
  }

  Future<Todo> getItemById(String id) async {
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
    final response = await Api().dio.patch('/list',
        data: {"list": data},
        options:
            Options(headers: {'X-Last-Known-Revision': lastKnownRevision}));
    return Todo.listFromJson(response.data['list']);
  }

  Future<Todo> createTodo(Todo todo) async {
    final todoJson = todo.toJson();
    late final Response response;
    try {
      response = await Api().dio.post('/list',
          data: {"element": todoJson},
          options:
              Options(headers: {'X-Last-Known-Revision': lastKnownRevision}));
    } on DioError catch (e) {
      if (e.response?.statusCode == 400) {
        await updateRevision();
        response = await Api().dio.post('/list',
            data: {"element": todoJson},
            options:
                Options(headers: {'X-Last-Known-Revision': lastKnownRevision}));
      } else {
        rethrow;
      }
    }
    lastKnownRevision = response.data['revision'] ?? lastKnownRevision;

    return Todo.fromJson(response.data['element']);
  }

  Future<Todo> updateTodo(Todo todo) async {
    late final Response response;
    try {
      response = await Api().dio.put('/list/${todo.id}',
          data: {"element": todo.toJson()},
          options:
              Options(headers: {'X-Last-Known-Revision': lastKnownRevision}));
    } on DioError catch (e) {
      if (e.response?.statusCode == 400) {
        await updateRevision();
        response = await Api().dio.put('/list/${todo.id}',
            data: {"element": todo.toJson()},
            options:
                Options(headers: {'X-Last-Known-Revision': lastKnownRevision}));
      } else {
        rethrow;
      }
    }

    lastKnownRevision = response.data['revision'] ?? lastKnownRevision;
    return Todo.fromJson(response.data['element']);
  }

  Future<Todo> deleteTodo(String id) async {
    final response = await Api().dio.delete('/list/$id',
        options:
            Options(headers: {'X-Last-Known-Revision': lastKnownRevision}));
    lastKnownRevision = response.data['revision'] ?? lastKnownRevision;
    return Todo.fromJson(response.data['element']);
  }

  Map assembleRequest(Todo model, {int? revision}) {
    Map<String, dynamic> request = {"element": model.toJson(), "status": "ok"};

    if (revision != null) request['revision'] = revision;
    return request;
  }

  Future updateRevision() async {
    final response = await Api().dio.get('/list');

    lastKnownRevision = response.data['revision'];
  }
}
