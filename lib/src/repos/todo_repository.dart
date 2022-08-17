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

  List<Todo> todos = [];

  @override
  Future<void> createTodo(Todo todo) async {
    final dateCreated = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    todo = todo.copyWith(
        id: const Uuid().v4(),
        lastUpdatedBy: "debug",
        createdAt: dateCreated,
        changedAt: dateCreated);
    todos.add(todo);
    localService.createValue(todo);
    await remoteService.createTodo(todo);
    await onRevisionUpdated(remoteService.lastKnownRevision);
  }

  @override
  Future<void> deleteTodo(String id) async {
    final index = todos.indexWhere((element) => element.id == id);
    final deletedId = todos.removeAt(index).id;
    localService.deleteValue(deletedId!);
    await remoteService.deleteTodo(deletedId);

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
        todos = remoteTodos;
        localService.putList(remoteTodos);
        onRevisionUpdated(remoteService.lastKnownRevision);
      } else {
        todos = localTodos;
        remoteService.patchList(todos);
      }
    } on DioError {
      todos = await localService.getAll();
    }
  }

  @override
  Future<void> patchList(List todos) {
    // TODO: implement patchList
    throw UnimplementedError();
  }

  @override
  Future<void> putTodo(Todo todo) async {
    final index = todos.indexWhere((element) => element.id == todo.id);
    if (index == -1) {
      throw StateError("Не найден элемент для обновления");
    }

    todos[index] = todo;
    localService.updateValue(todo);
    await remoteService.updateTodo(todo);
    await onRevisionUpdated(remoteService.lastKnownRevision);
  }

  Future<void> onRevisionUpdated(int revision) async {
    await localService.storeRevision(revision);
  }
}
