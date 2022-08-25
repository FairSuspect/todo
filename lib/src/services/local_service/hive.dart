import 'package:hive/hive.dart';
import 'package:todo/src/models/todo.dart';
import 'local_service.dart';

typedef LocalTodos = Map<String, Todo>;

class HiveService implements LocalService<Todo> {
  static const String _todoBoxName = "todos";
  static const String _collectionName = "TodoHive";
  static const String _revisionBoxName = "Revision";
  static const String _revisionKey = "revision";

  HiveService();

  Future<void> init() async {
    _lastKnownRevision = (await getRevision()) ?? 0;
  }

  int _lastKnownRevision = 0;

  @override
  int get lastKnownRevision => _lastKnownRevision;

  @override
  set lastKnownRevision(int lastKnownRevision) {
    _lastKnownRevision = lastKnownRevision;
    storeRevision(lastKnownRevision);
  }

  @override
  Future<void> storeRevision(int revision) async {
    final collection = await BoxCollection.open(
      _todoBoxName,
      {_revisionBoxName},
    );
    final revisionBox = await collection.openBox<int>(_revisionBoxName);
    await revisionBox.put(_revisionKey, lastKnownRevision);
    collection.close();
    _lastKnownRevision = revision;
  }

  @override
  Future<int?> getRevision() async {
    final collection = await BoxCollection.open(
      _todoBoxName,
      {_revisionBoxName},
    );
    final revisionBox = await collection.openBox<int>(_revisionBoxName);

    final int? storedRevision = await revisionBox.get(_revisionKey);
    collection.close();
    return storedRevision;
  }

  @override
  Future<LocalTodos> putMap(LocalTodos list) async {
    final collection = await BoxCollection.open(
      _collectionName,
      {_todoBoxName},
    );

    final todosBox = await collection.openBox<Todo>(_todoBoxName);
    await todosBox.clear();
    for (var todo in list.values) {
      await todosBox.put(todo.id, todo);
    }
    final keys = await todosBox.getAllKeys();
    final nullableList = await todosBox.getAll(keys);
    final LocalTodos array = castNullableListToList(nullableList);
    collection.close();
    return array;
  }

  @override
  Future<Todo> updateValue(Todo value) async {
    final collection = await BoxCollection.open(
      _collectionName,
      {_todoBoxName},
    );

    final todosBox = await collection.openBox(_todoBoxName);

    final response = await todosBox.get(value.id);
    collection.close();
    lastKnownRevision++;

    return response;
  }

  @override
  Future<Todo> deleteValue(String key) async {
    final collection = await BoxCollection.open(
      _collectionName,
      {_todoBoxName},
    );

    final todosBox = await collection.openBox<Todo>(_todoBoxName);
    final deletedValue = await todosBox.get(key);
    await todosBox.delete(key);

    collection.close();
    lastKnownRevision++;

    return deletedValue!;
  }

  @override
  Future<LocalTodos> getAll() async {
    final collection = await BoxCollection.open(
      _collectionName,
      {_todoBoxName},
    );

    final todosBox = await collection.openBox<Todo>(_todoBoxName);
    final keys = await todosBox.getAllKeys();
    if (keys.isEmpty) {
      collection.close();
      return {};
    }
    final nullableList = await todosBox.getAll(keys);
    final LocalTodos array = castNullableListToList(nullableList);
    collection.close();
    return array;
  }

  @override
  Future<Todo> createValue(Todo value) async {
    final collection = await BoxCollection.open(
      _collectionName,
      {_todoBoxName},
    );

    final todosBox = await collection.openBox<Todo>(_todoBoxName);

    await todosBox.put(value.id, value);
    final response = await todosBox.get(value.id);
    collection.close();
    lastKnownRevision++;

    return response!;
  }

  LocalTodos castNullableListToList(List<Todo?> list) {
    final filteredList = list
        .where((element) => element != null)
        .map((todo) => Todo(
              text: todo!.text,
              id: todo.id,
              changedAt: todo.changedAt,
              createdAt: todo.createdAt,
              deadline: todo.deadline,
              done: todo.done,
              importance: todo.importance,
              lastUpdatedBy: todo.lastUpdatedBy,
            ))
        .toList();
    filteredList.sort(
      (a, b) => a.createdAt!.compareTo(b.createdAt!),
    );
    return Map.fromIterables(filteredList.map((e) => e.id), filteredList);
  }
}
