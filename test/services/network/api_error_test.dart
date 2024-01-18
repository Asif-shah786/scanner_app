import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scanner/services/network/api_error.dart';

void main() {
  group('ApiError Tests', () {
    setUp(() {
      // registerFallbackValue<RequestOptions>(RequestOptions(path: 'some_path'));
    });

    test('fromDio should handle cancel exception', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: 'some_path'),
        type: DioExceptionType.cancel,
      );

      final apiError = ApiError.fromDio(dioError);

      expect(apiError.errorDescription, 'Request to API was cancelled');
    });
    test('fromDio should handle Connection Error with API', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: 'some_path'),
        type: DioExceptionType.connectionError,
      );

      final apiError = ApiError.fromDio(dioError);

      expect(apiError.errorDescription, 'Connection Error with API');
    });
    test('fromDio should handle badCertificate', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: 'some_path'),
        type: DioExceptionType.badCertificate,
      );

      final apiError = ApiError.fromDio(dioError);

      expect(apiError.errorDescription, 'badCertificate, Please try again');
    });
    test('fromDio should handle Send timeout in connection with API', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: 'some_path'),
        type: DioExceptionType.sendTimeout,
      );

      final apiError = ApiError.fromDio(dioError);

      expect(apiError.errorDescription, 'Send timeout in connection with API');
    });
    test('fromDio should handle Receive timeout in connection with API', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: 'some_path'),
        type: DioExceptionType.receiveTimeout,
      );

      final apiError = ApiError.fromDio(dioError);

      expect(
        apiError.errorDescription,
        'Receive timeout in connection with API',
      );
    });

    test('fromDio should handle connection timeout exception', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: 'some_path'),
        type: DioExceptionType.connectionTimeout,
      );

      final apiError = ApiError.fromDio(dioError);

      expect(apiError.errorDescription, 'Connection timeout with API');
    });

    // Add similar tests for other DioErrorTypes

    test('fromResponse should handle a response with message', () {
      final response = Response(
        requestOptions: RequestOptions(path: 'path'),
        data: {'message': 'Custom error message'},
      );

      final apiError = ApiError.fromResponse(response);

      expect(apiError.errorDescription, 'Custom error message');
    });

    test('fromResponse should handle a response with errors', () {
      final response = Response(
        requestOptions: RequestOptions(path: 'path'),
        data: {
          'errors': {
            'error1': ['Error message 1', 'Error message 2'],
          },
        },
      );

      final apiError = ApiError.fromResponse(response);

      expect(apiError.errorDescription, 'Error message 1, Error message 2');
    });

    test('fromResponse should handle a response with data', () {
      final response = Response(
        requestOptions: RequestOptions(path: 'path'),
        data: {'data': 'Data error message'},
      );

      final apiError = ApiError.fromResponse(response);

      expect(apiError.errorDescription, 'Data error message');
    });

    test('verify toString function', () {
      final response = Response(
        requestOptions: RequestOptions(path: 'path'),
        data: {'data': 'Data error message'},
      );

      final apiError = ApiError.fromResponse(response);

      expect(apiError.toString(), 'Data error message');
    });

    test('fromResponse should handle an unknown response', () {
      final response = Response(
        requestOptions: RequestOptions(path: 'path'),
        data: <dynamic, dynamic>{},
      );

      final apiError = ApiError.fromResponse(response);

      expect(
        apiError.errorDescription,
        'Oops an error occurred, we are fixing it',
      );
    });
  });
}
