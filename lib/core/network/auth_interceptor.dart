import 'package:dio/dio.dart';
import 'package:electra/core/errors/api_error.dart';
import 'package:electra/core/network/api_endpoints.dart';
import 'package:electra/core/utils/storage/auth_storage.dart';
import 'package:flutter/widgets.dart';

class AuthInterceptor extends Interceptor {
  final AuthStorage storage;
  final Dio dio;

  bool _isRefreshing = false;

  AuthInterceptor({required this.storage, required this.dio});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await storage.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  // ✅ onError catches 401/400 that Dio routes as exceptions
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint('🔴 onError fired: ${err.response?.statusCode}');
    final status = err.response?.statusCode;
    final isAuthError =
        status == 401 ||
        (status == 400 && _isMissingAuthHeaderFromResponse(err.response));

    if (!isAuthError) return handler.next(err);

    await _handleAuthError(
      requestOptions: err.requestOptions,
      onResolve: handler.resolve,
      onReject: handler.next,
    );
  }

  /// Shared refresh + retry logic used by both onResponse and onError
  Future<void> _handleAuthError({
    required RequestOptions requestOptions,
    required Function(Response) onResolve,
    required Function(DioException) onReject,
  }) async {
    if (_isRefreshing) {
      return onReject(
        DioException(
          requestOptions: requestOptions,
          type: DioExceptionType.badResponse,
        ),
      );
    }

    final refreshToken = await storage.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      await storage.clearTokens();
      return onReject(
        DioException(
          requestOptions: requestOptions,
          type: DioExceptionType.badResponse,
        ),
      );
    }

    _isRefreshing = true;
    try {
      // Clear interceptors to make raw refresh call without triggering this interceptor
      final existingInterceptors = List<Interceptor>.from(dio.interceptors);
      dio.interceptors.clear();

      final refreshResponse = await dio.post(
        ApiEndpoints.refresh,
        data: {'refreshToken': refreshToken},
      );

      // Restore interceptors
      dio.interceptors.addAll(existingInterceptors);

      final body = refreshResponse.data as Map<String, dynamic>;
      if (body['success'] != true) {
        await storage.clearTokens();
        return onReject(
          DioException(
            requestOptions: requestOptions,
            type: DioExceptionType.badResponse,
          ),
        );
      }

      final data = body['data'] as Map<String, dynamic>;
      final newAccessToken = data['accessToken'] as String;
      final newRefreshToken = data['refreshToken'] as String;

      await storage.saveTokens(
        access: newAccessToken,
        refresh: newRefreshToken,
      );

      // Retry original request with new token
      requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
      final cloned = await dio.fetch(requestOptions);
      return onResolve(cloned);
    } catch (e) {
      await storage.clearTokens();
      return onReject(
        DioException(
          requestOptions: requestOptions,
          type: DioExceptionType.unknown,
          error: e,
        ),
      );
    } finally {
      _isRefreshing = false;
    }
  }

  bool _isMissingAuthHeader(Response response) {
    try {
      final apiError = ApiError.fromJson(response.data as Map<String, dynamic>);
      return apiError.code == 'FST_ERR_VALIDATION' &&
          apiError.message.toLowerCase().contains('authorization');
    } catch (_) {
      return false;
    }
  }

  bool _isMissingAuthHeaderFromResponse(Response? response) {
    if (response?.data == null) return false;
    return _isMissingAuthHeader(response!);
  }
}
