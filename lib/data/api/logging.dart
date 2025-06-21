import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
//import 'package:dio/dio.dart' as dio; // ✅ Aliased import

class Logging extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print(
          'REQUEST[${options.method}] => PATH: ${options.baseUrl}${options.path} : ${options.data}');
      print('PARAMS => ${options.queryParameters}');
      print('HEADERS => ${options.headers}');
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path} : ${response.data.toString()} ',
      );
    }
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.message}',
      );
    }
    return super.onError(err, handler);
  }
}
