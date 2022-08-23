abstract class LocalService<T> {
  int lastKnownRevision = 0;
  Future<void> storeRevision(int revision);

  Future<int?> getRevision();

  Future<List<T>> putList(List<T> list);
  Future<T> updateValue(T value);
  Future<T> deleteValue(String id);
  Future<List<T>> getAll();
  Future<T> createValue(T value);
}
