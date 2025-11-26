import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final class DioClient {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage; 

  static const  _defaultBaseUrl = 'https://api.jollypodcast.net/api';

  DioClient({String? baseUrl})
    : _dio = Dio(BaseOptions(baseUrl: baseUrl ?? _defaultBaseUrl)),
      _secureStorage = const FlutterSecureStorage() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = await _secureStorage.read(key: 'auth_token');
          options.headers.putIfAbsent('Authorization', () => 'Bearer $token');
          return handler.next(options);
        },
      ),
    );
    if (kDebugMode) {
      addInterceptor(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
  }

  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  Future<Response> get({
    required String path,
    String? baseUrl,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    _dio.options.baseUrl = baseUrl ?? _defaultBaseUrl;
    return _dio.get(path, queryParameters: queryParameters, options: options);
  }

  Future<Response> post({
    required String path,
    Object? data,
    String? baseUrl,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    _dio.options.baseUrl = baseUrl ?? _defaultBaseUrl;
    return _dio.post(path, data: data, queryParameters: queryParameters, options: options,
    );
  }

  authToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }
}