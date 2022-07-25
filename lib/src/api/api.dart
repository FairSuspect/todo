import 'package:dio/dio.dart';
import 'package:todo/src/misc/dotenv.dart';

import 'token.dart';

class Api {
  final dio = createDio();

  Api._internal();

  static final _api = Api._internal();

  factory Api() => _api;

  static Dio createDio() {
    var dio = Dio(BaseOptions(
        baseUrl: Dotenv().getValue("BASE_URL"),
        receiveTimeout: 15000, // 15 seconds
        connectTimeout: 15000,
        sendTimeout: 15000,
        headers: {
          'Authorization': 'Bearer ${TokenRepository().getAccessToken()}'
        }));

    dio.interceptors.addAll({
      AppInterceptors(dio),
    });
    return dio;
  }
}

class AppInterceptors extends Interceptor {
  final Dio dio;

  AppInterceptors(this.dio);

  @override
  onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    dio.options.headers['X-Last-Known-Revision'] =
        response.data['revision'] as int?;
    handler.next(response);
  }
}
