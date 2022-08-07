import 'package:dio/dio.dart';
import 'package:todo/src/api/api.dart';
import 'package:todo/src/models/todo.dart';
import 'package:todo/src/services/remote_service/api_path.dart';

class TodoService {
  int _lastKnownRevision = 0;

  static const String _revisionHeader = 'X-Last-Known-Revision';

  int get lastKnownRevision => _lastKnownRevision;

  set lastKnownRevision(int lastKnownRevision) {
    _lastKnownRevision = lastKnownRevision;
  }

  Future<Todo> getItemById(String id) async {
    final response = await Api().dio.get(ApiPath.getById(id));

    return Todo.fromJson(response.data);
  }

  Future<List<Todo>> getItemList() async {
    final response = await Api().dio.get(ApiPath.getList);

    lastKnownRevision = response.data['revision'];
    return Todo.listFromJson(response.data['list']);
  }

  Future<List<Todo>> patchList(List<Todo> todos) async {
    final data = todos.map((e) => e.toJson()).toList();
    final response = await Api().dio.patch(
          ApiPath.patchList,
          data: {"list": data},
          options: _revisionHeadersOptions,
        );
    return Todo.listFromJson(response.data['list']);
  }

  Future<Todo> createTodo(Todo todo) async {
    final todoJson = todo.toJson();
    late final Response response;
    try {
      response = await Api().dio.post(
            ApiPath.create,
            data: {"element": todoJson},
            options: _revisionHeadersOptions,
          );
    } on DioError catch (e) {
      if (e.response?.statusCode == 400) {
        await updateRevision();
        response = await Api().dio.post(
              ApiPath.create,
              data: {"element": todoJson},
              options: _revisionHeadersOptions,
            );
      } else {
        rethrow;
      }
    }
    lastKnownRevision = response.data['revision'] ?? lastKnownRevision;

    return Todo.fromJson(response.data);
  }

  Future<Todo> updateTodo(Todo todo) async {
    late final Response response;
    try {
      response = await Api().dio.put(
            ApiPath.put(todo.id!),
            data: {"element": todo.toJson()},
            options: _revisionHeadersOptions,
          );
    } on DioError catch (e) {
      if (e.response?.statusCode == 400) {
        await updateRevision();
        response = await Api().dio.put(
              ApiPath.put(todo.id!),
              data: {"element": todo.toJson()},
              options: _revisionHeadersOptions,
            );
      } else {
        rethrow;
      }
    }

    lastKnownRevision = response.data['revision'] ?? lastKnownRevision;
    return Todo.fromJson(response.data);
  }

  Future<Todo> deleteTodo(String id) async {
    final response = await Api().dio.delete(
          ApiPath.delete(id),
          options: _revisionHeadersOptions,
        );
    lastKnownRevision = response.data['revision'] ?? lastKnownRevision;
    return Todo.fromJson(response.data);
  }

  Map assembleRequest(Todo model, {int? revision}) {
    Map<String, dynamic> request = {"element": model.toJson(), "status": "ok"};

    if (revision != null) request['revision'] = revision;
    return request;
  }

  Future updateRevision() async {
    final response = await Api().dio.get(ApiPath.revision);

    lastKnownRevision = response.data['revision'];
  }

  Options get _revisionHeadersOptions => Options(
        headers: {
          _revisionHeader: lastKnownRevision,
        },
      );
}
