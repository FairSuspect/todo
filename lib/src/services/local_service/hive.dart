import 'package:hive/hive.dart';
import 'package:todo/src/models/todo.dart';
import 'local_service.dart';

class HiveService implements LocalService<Todo> {
  static const String _todoBoxName = "todos";
  static const String _collectionName = "TodoHive";
  static const String _revisionBoxName = "Revision";
  static const String _revisionKey = "revision";
  HiveService() {
    Hive
      ..init('./')
      ..registerAdapter(TodoAdapter())
      ..registerAdapter(ImportanceAdapter());
    getRevision().then((value) {
      _lastKnownRevision = value ?? 0;
    });
  }
  int _lastKnownRevision = 0;

  @override
  int get lastKnownRevision => _lastKnownRevision;

  @override
  set lastKnownRevision(int lastKnownRevision) {
    _lastKnownRevision = lastKnownRevision;
    print("local revision updated: $_lastKnownRevision");
    storeRevision(lastKnownRevision);
  }

  @override
  Future<void> storeRevision(int revision) async {
    final collection =
        await BoxCollection.open(_todoBoxName, {_revisionBoxName}, path: './');
    final revisionBox = await collection.openBox<int>(_revisionBoxName);
    await revisionBox.put(_revisionKey, lastKnownRevision);
    print("revision ($revision) synced with local service");
    final storedRevision = await revisionBox.get(_revisionKey);
    print("Local service revision $storedRevision");
    collection.close();
    _lastKnownRevision = revision;

    // return storedRevision;
  }

  @override
  Future<int?> getRevision() async {
    final collection =
        await BoxCollection.open(_todoBoxName, {_revisionBoxName}, path: './');
    final revisionBox = await collection.openBox<int>(_revisionBoxName);

    final int? storedRevision = await revisionBox.get(_revisionKey);
    collection.close();
    return storedRevision;
  }

  @override
  Future<List<Todo>> putList(List<Todo> list) async {
    final collection = await BoxCollection.open(
      _collectionName,
      {_todoBoxName},
      path: './',
    );

    final todosBox = await collection.openBox<Todo>(_todoBoxName);
    await todosBox.clear();
    for (var todo in list) {
      await todosBox.put(todo.id!, todo);
    }
    final keys = await todosBox.getAllKeys();
    final nullableList = await todosBox.getAll(keys);
    final List<Todo> array = castNullableListToList(nullableList);
    collection.close();
    return array;
  }

  @override
  Future<Todo> updateValue(Todo value) async {
    final collection = await BoxCollection.open(
      _collectionName,
      {_todoBoxName},
      path: './',
    );

    final todosBox = await collection.openBox(_todoBoxName);

    // await todosBox.put(value['id'], value);
    final response = await todosBox.get(value.id!);
    collection.close();
    lastKnownRevision++;

    return response;
  }

  @override
  Future<Todo> deleteValue(String key) async {
    final collection = await BoxCollection.open(
      _collectionName,
      {_todoBoxName},
      path: './',
    );

    final todosBox = await collection.openBox<Todo>(_todoBoxName);
    final deletedValue = await todosBox.get(key);
    await todosBox.delete(key);

    collection.close();
    lastKnownRevision++;

    return deletedValue!;
  }

  @override
  Future<List<Todo>> getAll() async {
    final collection = await BoxCollection.open(
      _collectionName,
      {_todoBoxName},
      path: './',
    );

    final todosBox = await collection.openBox<Todo>(_todoBoxName);
    final keys = await todosBox.getAllKeys();
    if (keys.isEmpty) {
      collection.close();
      return [];
    }
    final nullableList = await todosBox.getAll(keys);
    final List<Todo> array = castNullableListToList(nullableList);
    collection.close();
    return array;
  }

  @override
  Future<Todo> createValue(Todo value) async {
    final collection = await BoxCollection.open(
      _collectionName,
      {_todoBoxName},
      path: './',
    );

    final todosBox = await collection.openBox<Todo>(_todoBoxName);

    await todosBox.put(value.id!, value);
    final response = await todosBox.get(value.id!);
    collection.close();
    lastKnownRevision++;

    return response!;
  }

  List<Todo> castNullableListToList(List<Todo?> list) {
    return list
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
  }
}
