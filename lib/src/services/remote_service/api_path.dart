abstract class ApiPath {
  static const String getList = '/list';
  static String getById(String id) => '/list/$id';
  static const String patchList = '/list';
  static const String create = '/list';
  static String put(String id) => '/list/$id';
  static String delete(String id) => '/list/$id';
  static const String revision = '/list';
}
