import 'package:dio/dio.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print("➡️ [REQUEST]");
    print("URL: ${options.uri}");
    print("METHOD: ${options.method}");
    print("HEADERS: ${options.headers}");
    print("DATA: ${options.data}");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("[RESPONSE] -> ");
    print("STATUS: ${response.statusCode}");
    print("DATA: ${response.data}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print("[ERROR] ->");
    print("MESSAGE: ${err.message}");
    print("RESPONSE: ${err.response}");
    super.onError(err, handler);
  }
}
