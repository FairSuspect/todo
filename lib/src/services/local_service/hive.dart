import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import 'package:todo/src/models/todo.dart';
import 'local_service.dart';

typedef LocalTodos = Map<String, Todo>;

class HiveService implements LocalService<Todo> {
  final _logger = Logger("Hive");
  static const String _todoBoxName = "todos";
  static const String _revisionBoxName = "Revision";
  static const String _revisionKey = "revision";

  Future<void> init() async {
    _lastKnownRevision = await getRevision();
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
    _lastKnownRevision = revision;
    final revisionBox = await Hive.openBox<int>(_revisionBoxName);
    _logger.info("Updating revision ($revision) in local service");

    await revisionBox.put(_revisionKey, revision);
    revisionBox.close();
  }

  @override
  Future<int> getRevision() async {
    final revisionBox = await Hive.openBox<int>(_revisionBoxName);
    final int storedRevision = revisionBox.get(_revisionKey) ?? 0;
    _logger.info("Revision stored in local service: $storedRevision");
    revisionBox.close();
    return storedRevision;
  }

  @override
  Future<LocalTodos> putMap(LocalTodos todos) async {
    final todosBox = await Hive.openBox<Todo>(_todoBoxName);
    await todosBox.clear();
    await todosBox.putAll(todos);
    todos = await getAll();
    todosBox.close();
    return todos;
  }

  @override
  Future<Todo> updateValue(Todo value) async {
    final todosBox = await Hive.openBox(_todoBoxName);

    final response = await todosBox.get(value.id);
    todosBox.close();
    lastKnownRevision++;

    return response;
  }

  @override
  Future<Todo?> deleteValue(String key) async {
    final todosBox = await Hive.openBox<Todo>(_todoBoxName);
    final deletedValue = todosBox.get(key);
    await todosBox.delete(key);

    todosBox.close();
    lastKnownRevision++;

    return deletedValue;
  }

  @override
  Future<LocalTodos> getAll() async {
    final todosBox = await Hive.openBox<Todo>(_todoBoxName);
    final values = todosBox.values;
    if (values.isEmpty) {
      todosBox.close();
      return {};
    }
    final sortedList = values.toList()
      ..sort(
        (a, b) => a.createdAt!.compareTo(b.createdAt!),
      );

    final localTodos =
        Map.fromIterables(sortedList.map((e) => e.id), sortedList);
    _logger.info('Got ${localTodos.length} todos from local service');
    todosBox.close();
    return localTodos;
  }

  @override
  Future<Todo> createValue(Todo value) async {
    final todosBox = await Hive.openBox<Todo>(_todoBoxName);

    await todosBox.put(value.id, value);
    final todo = todosBox.get(value.id);
    todosBox.close();
    lastKnownRevision++;

    return todo!;
  }

  @override
  Future<Todo?> getById(String id) async {
    final todosBox = await Hive.openBox<Todo>(_todoBoxName);
    final todo = todosBox.get(id);
    todosBox.close();
    return todo;
  }
}
