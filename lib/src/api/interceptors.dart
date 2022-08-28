import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

class AppInterceptors extends Interceptor {
  final Dio dio;

  AppInterceptors(this.dio);

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Logger('Dio').log(Level.INFO,
        "${response.requestOptions.path} [${response.requestOptions.method}] — ${response.statusCode} (${response.statusMessage})");
    super.onResponse(response, handler);
  }
}
