import 'package:dio/dio.dart';
import 'package:electra/core/network/api_client.dart';
import 'package:electra/core/utils/storage/auth_storage.dart';
import 'package:electra/domain/repository/auth/auth_repository.dart';

class AuthInterceptor extends Interceptor {
  final AuthStorage storage;
  final AuthRepository repository;
  final ApiClient apiClient;

  bool _isRefreshing = false;

  AuthInterceptor(this.storage, this.repository, this.apiClient);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await storage.accessToken;

    // Always attach if we have a token — even on non-401 paths
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;

    // Treat 400 validation-missing-auth AND 401 as auth failures
    final isAuthError =
        status == 401 || (status == 400 && _isMissingAuthHeader(err.response));

    if (isAuthError && !_isRefreshing) {
      _isRefreshing = true;

      try {
        final refreshToken = await storage.refreshToken;

        if (refreshToken == null || refreshToken.isEmpty) {
          await storage.clearTokens();
          return handler.next(err);
        }

        final result = await repository.refresh(refreshToken: refreshToken);

        final newTokens = result.fold((failure) => null, (tokens) => tokens);

        if (newTokens == null) {
          await storage.clearTokens();
          return handler.next(err);
        }

        // Retry with fresh token
        err.requestOptions.headers['Authorization'] =
            'Bearer ${newTokens.accessToken}';
        final clonedRequest = await apiClient.dio.fetch(err.requestOptions);
        return handler.resolve(clonedRequest);
      } catch (_) {
        await storage.clearTokens();
        handler.next(err);
      } finally {
        _isRefreshing = false;
      }
    } else {
      handler.next(err);
    }
  }

  /// Detects Fastify's FST_ERR_VALIDATION for missing authorization header
  bool _isMissingAuthHeader(Response? response) {
    if (response == null) return false;
    try {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final error = data['error'];
        if (error is Map<String, dynamic>) {
          return error['code'] == 'FST_ERR_VALIDATION' &&
              (error['message'] as String? ?? '').contains('authorization');
        }
      }
    } catch (_) {}
    return false;
  }
}
