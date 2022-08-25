import 'package:dio/dio.dart';
import 'package:todo/src/models/todo.dart';
import 'package:todo/src/repos/abstract_repository.dart';
import 'package:todo/src/services/local_service/abstract_local_service.dart';
import 'package:todo/src/services/remote_service/remote_service.dart';
import 'package:uuid/uuid.dart';

class TodoRepository implements TodoBaseRepository<Todo> {
  TodoRepository({
    required this.remoteService,
    required this.localService,
  }) {
    getTodoList();
  }

  final TodoService remoteService;
  final LocalService<Todo> localService;

  Map<String, Todo> todos = {};

  @override
  Future<void> createTodo(Todo todo) async {
    final dateCreated = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    todo = todo.copyWith(
        id: const Uuid().v4(),
        lastUpdatedBy: "debug",
        createdAt: dateCreated,
        changedAt: dateCreated);
    todos[todo.id] = todo;
    await localService.createValue(todo);
    await remoteService.createTodo(todo);
    await onRevisionUpdated(remoteService.lastKnownRevision);
  }

  @override
  Future<void> deleteTodo(String id) async {
    todos.remove(id);
    await localService.deleteValue(id);
    await remoteService.deleteTodo(id);

    await onRevisionUpdated(remoteService.lastKnownRevision);
  }

  @override
  Future<void> getTodo(String id) {
    // TODO: implement getTodo
    throw UnimplementedError();
  }

  @override
  Future<void> getTodoList() async {
    try {
      final remoteTodos = await remoteService.getItemList();
      final localTodos = await localService.getAll();
      if (remoteService.lastKnownRevision > localService.lastKnownRevision) {
        todos = Map.fromIterables(remoteTodos.map((e) => e.id), remoteTodos);

        localService.putList(remoteTodos);
        onRevisionUpdated(remoteService.lastKnownRevision);
      } else {
        todos = Map.fromIterables(localTodos.map((e) => e.id), localTodos);
        remoteService.patchList(todos.values.toList());
      }
    } on DioError {
      final localTodos = await localService.getAll();

      todos =
          todos = Map.fromIterables(localTodos.map((e) => e.id), localTodos);
    }
  }

  @override
  Future<void> patchList(List todos) {
    // TODO: implement patchList
    throw UnimplementedError();
  }

  @override
  Future<void> putTodo(Todo todo) async {
    todos[todo.id] = todo;
    localService.updateValue(todo);
    await remoteService.updateTodo(todo);
    await onRevisionUpdated(remoteService.lastKnownRevision);
  }

  Future<void> onRevisionUpdated(int revision) async {
    await localService.storeRevision(revision);
  }
}
