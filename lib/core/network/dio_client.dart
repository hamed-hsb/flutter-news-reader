import 'package:dio/dio.dart';
import '../config/config.dart';
import 'dio_interseptor.dart';

Dio buildDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      responseType: ResponseType.json,
    ),
  );
  dio.interceptors.add(LoggerInterceptor());
  return dio;
}

