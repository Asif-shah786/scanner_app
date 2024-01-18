import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scanner/services/network/api_error.dart';
import 'package:scanner/services/network/auth_interceptor.dart';
import 'package:scanner/services/network/url_config.dart';

/// description: A network provider class which manages network connections
/// between the app and external services. This is a wrapper around [Dio].
///
/// Using this class automatically handle, token management, logging, global

void _printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
}

/// A top level function to print dio logs
void _printDioLogs(Object object) {
  if (kDebugMode) {
    _printWrapped(object.toString());
  }
}

///Dio Network service class
///calls fetchToken from [SpreadlyApiClient] and uses the token
///to make all api calls
class NetworkService {
  ///Network call [connectTimeOut] time
  static const connectTimeOut = Duration(seconds: 30);

  ///Network call [receiveTimeOut] time

  static const receiveTimeOut = Duration(seconds: 30);

  ///[Dio] instanse that powers this class
  Dio? dio;

  ///[baseUrl]API base url

  String? baseUrl;

  ///[authToken]API authtoken passed from Spreadly client

  String? authToken;

  ///[defaultTimeout]
  Duration? defaultTimeout;

  ///Initalizes the Network service with a passed in [baseUrl] and [authToken]
  ///where available
  NetworkService({this.baseUrl, this.authToken, this.defaultTimeout}) {
    _initialiseDio();
  }

  /// Initialize essential class properties
  dynamic _initialiseDio() async {
    dio = Dio(
      BaseOptions(
        connectTimeout: defaultTimeout ?? connectTimeOut,
        receiveTimeout: defaultTimeout ?? receiveTimeOut,
        baseUrl: baseUrl ?? UrlConfig.coreBaseUrl,
      ),
    );

    dio!.interceptors.addAll(
      [
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: _printDioLogs,
        ),
        AuthInterceptor(),
      ],
    );
  }

  /// Factory constructor used mainly for injecting an instance of [Dio] mock
  NetworkService.test(this.dio);

  /// Makes an HTTP request to the specified [path] using the given [method].
  ///
  /// - [path]: The path or URL to make the HTTP request.
  /// - [method]: The HTTP request method, such as GET, POST, PUT, or DELETE.
  /// - [queryParams]: (Optional) Query parameters to include in the request.
  /// - [data]: (Optional) Data to send with the request body.
  /// - [formData]: (Optional) A [FormData] object to use for the request body.
  /// usually for MultiPart requests
  /// - [responseType]: The expected response type (default is JSON).
  ///
  /// Returns a [Future] containing the HTTP response.
  Future<Response<dynamic>> call(
    String path,
    RequestMethod method, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? data,
    FormData? formData,
    ResponseType responseType = ResponseType.json,
  }) async {
    Response<dynamic> response;
    final params = queryParams ?? {};

    try {
      switch (method) {
        case RequestMethod.post:
          response = await dio!.post(
            path,
            queryParameters: params,
            data: data,
            options: _getOptions(),
          );

        case RequestMethod.get:
          response = await dio!
              .get(path, queryParameters: params, options: _getOptions());

        case RequestMethod.put:
          response = await dio!.put(
            path,
            queryParameters: params,
            data: data,
            options: _getOptions(),
          );

        case RequestMethod.patch:
          response = await dio!.patch(
            path,
            queryParameters: params,
            data: data,
            options: _getOptions(),
          );

        case RequestMethod.delete:
          response = await dio!.delete(
            path,
            queryParameters: params,
            data: data,
            options: _getOptions(),
          );

        case RequestMethod.upload:

          // import 'dart:math';

          // String generateBoundaryString() {
          final random = Random();
          const charset = 'abcdefghijklmnopqrstuvwxyz0123456789';
          final boundary = '--${List.generate(
            16,
            (_) => charset[random.nextInt(charset.length)],
          ).join()}';
          // }
          response = await dio!.post(
            path,
            data: formData,
            queryParameters: params,
            options: Options(
              headers: {
                'Content-Disposition': 'form-data',
                'Accept': 'application/vnd.api+json',
                'Content-Type': 'multipart/form-data; boundary=$boundary',
              },
            ),
            onSendProgress: (sent, total) {},
          );
      }

      if (response.statusCode == 204) {
        _printWrapped('Exceptional Not Eerror 204');
      }

      if (response.data is List) {
        return response;
      } else {
        if (response.statusCode == 200 &&
            response.data is! Map<String, dynamic>) {
          return response;
        }

        if (response.data is! Map<String, dynamic>) {
          final apiError = ApiError.fromResponse(response);

          return Future.error(apiError);
        }

        final data = response.data as Map<String, dynamic>;
        if (data['errors'] != null) {
          _printWrapped(response.data.toString());
          final apiError = ApiError.fromResponse(response);

          return Future.error(apiError);
        } else {
          return response;
        }
      }
    } on Exception catch (error, stackTrace) {
      if (error is DioException) {
        final apiError = ApiError.fromDio(error);

        return Future.error(apiError, stackTrace);
      }

      _printWrapped(error.toString());

      final apiError = ApiError.unknown();

      return Future.error(apiError, stackTrace);
    }
  }

  Options _getOptions() {
    return Options(
      contentType: 'application/vnd.api+json',
      headers: {
        'Accept': 'application/vnd.api+json',
        'Content-Type': 'application/vnd.api+json',
      },
    );
  }
}

///API Request method Enums
enum RequestMethod {
  ///POST RequestMethod
  post,

  ///GET RequestMethod
  get,

  ///PUT RequestMethod
  put,

  ///PATCH RequestMethod
  patch,

  ///DELETE RequestMethod
  delete,

  ///UPLOAD RequestMethod
  upload,
}

final netwerkServiceProvider = Provider<NetworkService>((ref) {
  return NetworkService(
    baseUrl: UrlConfig.coreBaseUrl,
  );
});
