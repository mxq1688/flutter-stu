import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/constants/api_constants.dart';
import '../../core/utils/logger.dart';

/// API 服务 - GetX Service
class ApiService extends GetxService {
  late Dio _dio;
  final _storage = GetStorage();

  Dio get dio => _dio;

  Future<ApiService> init() async {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.apiBaseUrl,
      connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.addAll([
      _AuthInterceptor(this),
      _LogInterceptor(),
    ]);

    return this;
  }

  String? get token => _storage.read('auth_token');

  Future<void> setToken(String? token) async {
    if (token != null) {
      await _storage.write('auth_token', token);
    } else {
      await _storage.remove('auth_token');
    }
  }

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? params}) {
    return _dio.get<T>(path, queryParameters: params);
  }

  Future<Response<T>> post<T>(String path, {dynamic data}) {
    return _dio.post<T>(path, data: data);
  }
}

class _AuthInterceptor extends Interceptor {
  final ApiService _apiService;
  _AuthInterceptor(this._apiService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _apiService.token;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _apiService.setToken(null);
    }
    handler.next(err);
  }
}

class _LogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.d('🚀 ${options.method} => ${options.path}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.d('✅ ${response.statusCode} => ${response.requestOptions.path}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.e('❌ ${err.response?.statusCode} => ${err.requestOptions.path}');
    handler.next(err);
  }
}


