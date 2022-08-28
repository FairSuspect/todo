import 'dio.dart';

class Api {
  final dio = DioFactory.createDio();

  Api._internal();

  static final _api = Api._internal();

  factory Api() => _api;
}
