import 'package:dio/dio.dart';
import 'package:todo/src/misc/dotenv.dart';

import 'interceptors.dart';
import 'token.dart';

class DioFactory {
  DioFactory._();

  static Dio createDio() {
    final dio = Dio(BaseOptions(
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
