import 'package:dio/dio.dart';

/// Helper class for converting [DioException] into readable formats
class ApiError implements Exception {
  /// description of error generated this is similar to convention
  String? errorDescription;

  /// Creates an instance of [ApiError] with the provided [errorDescription].
  ApiError(this.errorDescription);

  /// Factory constructor to create an [ApiError] from a [DioException].
  factory ApiError.fromDio(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        // logger.e('unknown');

        return ApiError('Request to API was cancelled');
      case DioExceptionType.connectionTimeout:
        // logger.e('connectionTimeout');

        return ApiError('Connection timeout with API');
      case DioExceptionType.connectionError:
        return ApiError('Connection Error with API');
      case DioExceptionType.badCertificate:
        return ApiError('badCertificate, Please try again');
      case DioExceptionType.sendTimeout:
        return ApiError('Send timeout in connection with API');
      case DioExceptionType.receiveTimeout:
        return ApiError('Receive timeout in connection with API');
      case DioExceptionType.badResponse:
        return ApiError(_setCustomErrorMessage(dioError.response!));

      case DioExceptionType.unknown:
        return ApiError(_setCustomErrorMessage(dioError.response!));
    }
  }

  /// Factory constructor to create an [ApiError] for unknown errors.
  factory ApiError.unknown() {
    return ApiError('Oops!, Something went wrong, Please try again');
  }

  /// Factory constructor to create an [ApiError] from a generic response
  ApiError.fromResponse(Object? error) {
    if (error is Response) {
      errorDescription = _setCustomErrorMessage(error);
      _handleErr();
    } else {
      errorDescription = 'Oops an error occurred  we are fixing it';

      _handleErr();
    }
  }

  String? _handleErr() {
    return errorDescription;
  }

  @override
  String toString() => '$errorDescription';
}

String _setCustomErrorMessage(Response<dynamic> error) {
  final errorMessageList = <String>[];

  if (error.data is! Map<String, dynamic>) {
    return 'Oops an error occurred, we are fixing it';
  }
  final errorData = error.data as Map<String, dynamic>;

  // logger.e(errorData);
  if (errorData['message'] is String) {
    errorMessageList.add(errorData['message'] as String);
  }
  if (errorData['error'] is String) {
    errorMessageList.add(errorData['error'] as String);
  }

  if (errorData['errors'] is Map<String, dynamic>) {
    final errors = errorData['errors'] as Map<String, dynamic>;
    final errorMessages = errors.values
        .whereType<List<dynamic>>()
        .expand((messages) => messages.whereType<String>());
    errorMessageList.addAll(errorMessages);
  }

  if (errorData['errors'] is List) {
    final error = ((errorData['errors'] as List).isNotEmpty)
        ? (errorData['errors'] as List)[0] as Map<String, dynamic>?
        : null;

    if (error != null) {
      // final title = error['title'] as String? ?? 'Error';
      final detail = error['detail'] ?? 'An error occurred';
      // final status = error['status'] ?? 'Unknown Status';

      errorMessageList.add('Error: $detail');
    }
  }

  if (errorData['data'] is String) {
    errorMessageList.add(errorData['data'] as String);
  }
  return errorMessageList.join(', ');
}
