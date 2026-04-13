import 'package:dio/dio.dart';
import 'package:electra/core/network/api_client.dart';
import 'package:electra/core/utils/storage/auth_storage.dart';
import 'package:electra/domain/repository/auth/auth_repository.dart';

class AuthInterceptor extends Interceptor {
  final AuthStorage storage;
  final AuthRepository remote;
  final ApiClient apiClient;

  AuthInterceptor(this.storage, this.remote, this.apiClient);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await storage.accessToken;

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken = await storage.refreshToken;

        if (refreshToken == null) return handler.next(err);

        final newTokens = await remote.refresh(refreshToken: refreshToken);

        await storage.saveTokens(access: newTokens.accessToken, refresh: newTokens.refreshToken);

        final cloneReq = await apiClient.dio.fetch(err.requestOptions);
        return handler.resolve(cloneReq);
      } catch (e) {
        await storage.clearTokens();
      }
    }

    handler.next(err);
  }
}