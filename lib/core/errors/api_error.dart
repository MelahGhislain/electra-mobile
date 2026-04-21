class ApiError {
  final String? code;
  final String message;
  final String? details;

  const ApiError({this.code, required this.message, this.details});

  /// Parses your backend's { "error": { "code", "message", "details" } } shape
  factory ApiError.fromJson(Map<String, dynamic> json) {
    final error = json['error'] as Map<String, dynamic>?;
    return ApiError(
      code: error?['code'] as String?,
      message: error?['message'] as String? ?? 'Something went wrong.',
      details: error?['details'] as String?,
    );
  }
}
