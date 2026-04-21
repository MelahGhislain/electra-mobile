import 'package:dio/dio.dart';
import 'package:electra/core/network/auth_interceptor.dart';
import 'api_endpoints.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 120),
        receiveTimeout: const Duration(seconds: 120),
        headers: {"Content-Type": "application/json"},
      ),
    );

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  void addAuthInterceptor(AuthInterceptor interceptor) {
    dio.interceptors.add(interceptor);
  }
}
