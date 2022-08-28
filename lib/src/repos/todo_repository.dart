import 'package:dio/dio.dart';
import 'package:todo/src/models/todo.dart';
import 'package:todo/src/repos/abstract_repository.dart';
import 'package:todo/src/services/local_service/abstract_local_service.dart';
import 'package:todo/src/services/remote_service/remote_service.dart';
import 'package:uuid/uuid.dart';

typedef Todos = Map<String, Todo>;

class TodoRepository implements TodoBaseRepository<Todo> {
  TodoRepository({
    required this.remoteService,
    required this.localService,
  }) {
    getTodoList();
  }

  final TodoService<Todo> remoteService;
  final LocalService<Todo> localService;

  @override
  Future<void> createTodo(Todo todo) async {
    final dateCreated = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    todo = todo.copyWith(
        id: const Uuid().v4(),
        lastUpdatedBy: "debug",
        createdAt: dateCreated,
        changedAt: dateCreated);
    await localService.createValue(todo);
    await remoteService.createTodo(todo);
    await onRevisionUpdated(remoteService.lastKnownRevision);
  }

  @override
  Future<void> deleteTodo(String id) async {
    await localService.deleteValue(id);
    await remoteService.deleteTodo(id);

    await onRevisionUpdated(remoteService.lastKnownRevision);
  }

  @override
  Future<Todo> getTodo(String id) async {
    late final Todo todo;
    try {
      final remoteTodo = await remoteService.getItemById(id);
      final localTodo = await localService.getById(id);

      if (remoteService.lastKnownRevision > localService.lastKnownRevision ||
          localTodo == null) {
        localService.updateValue(remoteTodo);
        onRevisionUpdated(remoteService.lastKnownRevision);
      } else {
        todo = localTodo;
        remoteService.updateTodo(todo);
      }
    } on DioError {
      final localTodo = await localService.getById(id);
      if (localTodo == null) {
        throw Exception(
            "Todo with specifyed not found neither in remote and local service;");
      }
      todo = localTodo;
    }
    return todo;
  }

  @override
  Future<Todos> getTodoList() async {
    late final Todos todos;
    late final List<Todo> remoteTodos;
    try {
      remoteTodos = await remoteService.getItemList();
      final localTodos = await localService.getAll();
      if (remoteService.lastKnownRevision > localService.lastKnownRevision) {
        todos = Map.fromIterables(remoteTodos.map((e) => e.id), remoteTodos);

        localService.putMap(localTodos);
        onRevisionUpdated(remoteService.lastKnownRevision);
      } else {
        todos = localTodos;
        remoteService.patchList(todos.values.toList());
      }
    } on DioError {
      final localTodos = await localService.getAll();

      todos = localTodos;
    } catch (e) {
      todos = Map.fromIterables(remoteTodos.map((e) => e.id), remoteTodos);
    }
    return todos;
  }

  @override
  Future<void> patchList(List todos) {
    // TODO: implement patchList
    throw UnimplementedError();
  }

  @override
  Future<void> putTodo(Todo todo) async {
    localService.updateValue(todo);
    await remoteService.updateTodo(todo);
    await onRevisionUpdated(remoteService.lastKnownRevision);
  }

  Future<void> onRevisionUpdated(int revision) => localService.storeRevision(revision);
}
