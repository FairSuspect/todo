abstract class LocalService<T> {
  int lastKnownRevision = 0;
  Future<void> storeRevision(int revision);

  Future<int?> getRevision();

  Future<Map<String, T>> putMap(Map<String, T> list);
  Future<T> updateValue(T value);
  Future<T> deleteValue(String id);
  Future<Map<String, T>> getAll();
  Future<T> createValue(T value);
}
