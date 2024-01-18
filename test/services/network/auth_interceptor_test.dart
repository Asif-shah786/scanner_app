import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scanner/services/network/auth_interceptor.dart';

void main() {
  group('AuthInterceptor Tests', () {
    late AuthInterceptor authInterceptor;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      authInterceptor = AuthInterceptor();
    });

    const testToken = '648|hGTI71dxzrEcqJ42FHNbCayOv2ZqvgHJrXtnYVcK1d762a87';

    test('onRequest should set Authorization header', () async {
      final options = RequestOptions(path: 'some_path');

      await authInterceptor.onRequest(options, RequestInterceptorHandler());

      expect(
        options.headers,
        containsPair('Authorization', 'Bearer $testToken'),
      );
    });

    test('onResponse should update status code to 200 on success', () async {
      final response =
          Response<dynamic>(statusCode: 201, requestOptions: RequestOptions());

      await authInterceptor.onResponse(response, ResponseInterceptorHandler());

      expect(response.statusCode, 200);
    });

    test(
        'onResponse should call authenticateUser as user is '
        'not authorized and not modify '
        'status code on 401', () async {
      final response = Response<dynamic>(
        statusCode: 401,
        requestOptions: RequestOptions(),
      ); // Simulate a 401 response

      await authInterceptor.onResponse(response, ResponseInterceptorHandler());

      expect(response.statusCode, 401); // Status code remains 401
    });
  });
}
