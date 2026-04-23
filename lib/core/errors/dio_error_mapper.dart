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

      // Explicit auth failures
      if (statusCode == 401) return const UnauthorisedFailure();

      // Fastify missing-auth header comes back as 400
      if (statusCode == 400 && _isMissingAuth(e.response)) {
        return const UnauthorisedFailure();
      }

      // All other server errors — parse the body
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
      return UnknownFailure();
  }
}

bool _isMissingAuth(Response? response) {
  if (response?.data == null) return false;
  try {
    final apiError = ApiError.fromJson(response!.data as Map<String, dynamic>);
    return apiError.code == 'FST_ERR_VALIDATION' &&
        apiError.message.toLowerCase().contains('authorization');
  } catch (_) {
    return false;
  }
}
