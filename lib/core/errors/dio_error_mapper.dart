import 'package:dio/dio.dart';
import 'failures.dart';
import 'api_error.dart';

Failure mapDioError(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionError:
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      return const NetworkFailure();

    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode;
      if (statusCode == 401) return const UnauthorisedFailure();

      // Parse your backend's error body
      try {
        final data = e.response?.data as Map<String, dynamic>?;
        if (data != null) {
          final apiError = ApiError.fromJson(data);
          return ServerFailure(
            apiError.message,
            code: apiError.code,
            details: apiError.details,
          );
        }
      } catch (_) {}

      return UnknownFailure();

    default:
      return const UnknownFailure();
  }
}
