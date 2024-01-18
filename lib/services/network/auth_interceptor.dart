import 'package:dio/dio.dart';

/// [Interceptor] extension for setting token header
/// and other required properties for all requests
class AuthInterceptor extends Interceptor {
  /// [AuthInterceptor] constructor with  dependency
  AuthInterceptor();

  /// auth token is set for every request
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    const authTokenIntercept =
        '648|hGTI71dxzrEcqJ42FHNbCayOv2ZqvgHJrXtnYVcK1d762a87';

    // logger.e(authTokenIntercept);

    options.headers.addAll({
      'Authorization': 'Bearer $authTokenIntercept',
    });
    return super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      response.statusCode = 200;
    }
    return super.onResponse(response, handler);
  }
}
