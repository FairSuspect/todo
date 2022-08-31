import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

class AppInterceptors extends Interceptor {
  final Dio dio;

  AppInterceptors(this.dio);

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Logger('Dio').log(Level.INFO,
        "${response.requestOptions.path} [${response.requestOptions.method}] — ${response.statusCode} (${response.statusMessage}) {${response.requestOptions.headers['X-Last-Known-Revision']} / ${response.data['revision']}}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    Logger('Dio').shout(
        "${err.response?.data} {${err.response?.requestOptions.headers['X-Last-Known-Revision']}}");
    super.onError(err, handler);
  }
}
