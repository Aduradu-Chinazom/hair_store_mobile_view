/// Exception thrown when an API request fails or returns an error response.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => message;

  factory ApiException.fromStatusCode(int statusCode, dynamic responseData) {
    String message;
    switch (statusCode) {
      case 400:
        message = _extractErrorMessage(responseData) ?? 'Bad request. Please check your input.';
        break;
      case 401:
        message = _extractErrorMessage(responseData) ?? 'Unauthorized. Please log in again.';
        break;
      case 403:
        message = _extractErrorMessage(responseData) ?? 'Forbidden. You do not have permission.';
        break;
      case 404:
        message = _extractErrorMessage(responseData) ?? 'Requested resource not found.';
        break;
      case 422:
        message = _extractErrorMessage(responseData) ?? 'Validation error. Please verify your details.';
        break;
      case 500:
      case 502:
      case 503:
        message = 'Server error. Please try again later.';
        break;
      default:
        message = _extractErrorMessage(responseData) ?? 'An unexpected error occurred ($statusCode).';
    }
    return ApiException(
      message: message,
      statusCode: statusCode,
      data: responseData,
    );
  }

  static String? _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ??
          data['error'] as String? ??
          data['detail'] as String?;
    }
    return null;
  }
}
