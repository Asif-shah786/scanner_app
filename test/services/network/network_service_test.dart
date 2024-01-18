import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:scanner/services/network/api_error.dart';
import 'package:scanner/services/network/network_service.dart';

class MockDio extends Mock implements Dio {}

void main() {
  final dio = MockDio();
  final networkService = NetworkService.test(dio);

  group('NetworkService Tests', () {
    setUp(TestWidgetsFlutterBinding.ensureInitialized);

    test('call should make a GET request', () async {
      final response = Response(
        requestOptions: RequestOptions(),
        data: {'response': 'test-response'},
      );

      when(
        () => dio.get<dynamic>(
          'test-path',
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => response);

      final result = await networkService.call('test-path', RequestMethod.get);

      expect(result, response);
      verify(
        () => dio.get<dynamic>(
          'test-path',
          queryParameters: {},
          options: any(named: 'options'),
        ),
      ).called(1);
    });
    test('call should make a POST request', () async {
      final response = Response(
        requestOptions: RequestOptions(),
        data: {'response': 'test-response'},
      );

      when(
        () => dio.post<dynamic>(
          'test-path',
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          data: any(named: 'data'),
        ),
      ).thenAnswer((_) async => response);

      final result = await networkService.call('test-path', RequestMethod.post);

      expect(result, response);
      verify(
        () => dio.post<dynamic>(
          'test-path',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).called(1);
    });
    test('call should make a PUT request', () async {
      final response = Response(
        requestOptions: RequestOptions(),
        data: {'response': 'test-response'},
      );

      when(
        () => dio.put<dynamic>(
          'test-path',
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          data: any(named: 'data'),
        ),
      ).thenAnswer((_) async => response);

      final result = await networkService.call('test-path', RequestMethod.put);

      expect(result, response);
      verify(
        () => dio.put<dynamic>(
          'test-path',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).called(1);
    });
    test('call should make a DELETE request', () async {
      final response = Response<dynamic>(
        requestOptions: RequestOptions(),
        data: {'response': 'test-response'},
      );

      when(
        () => dio.delete<dynamic>(
          'test-path',
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          data: any(named: 'data'),
        ),
      ).thenAnswer((_) async => response);

      final result =
          await networkService.call('test-path', RequestMethod.delete);

      expect(result, response);
      verify(
        () => dio.delete<dynamic>(
          'test-path',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    test('call should handle API error response', () async {
      final errorResponse = Response(
        requestOptions: RequestOptions(),
        data: {
          'errors': {
            'error1': ['Error message 1', 'Error message 2'],
          },
        },
      );
      when(
        () => dio.get<dynamic>(
          'test-path',
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => errorResponse);

      expect(
        () async => networkService.call('test-path', RequestMethod.get),
        throwsA(isA<ApiError>()),
      );
    });
  });
}
