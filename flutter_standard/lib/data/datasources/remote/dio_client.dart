import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/utils/logger.dart';

/// Dio 实例 Provider
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: ApiConstants.apiBaseUrl,
    connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
    receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
    sendTimeout: const Duration(milliseconds: ApiConstants.sendTimeout),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  dio.interceptors.addAll([
    AuthInterceptor(ref),
    LogInterceptor(),
  ]);

  return dio;
});

/// Token Provider
final tokenProvider = StateProvider<String?>((ref) => null);

/// 认证拦截器
class AuthInterceptor extends Interceptor {
  final Ref ref;
  
  AuthInterceptor(this.ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // 从 SharedPreferences 获取 token
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token 过期，清除登录状态
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      ref.read(tokenProvider.notifier).state = null;
      AppLogger.w('Token expired');
    }
    handler.next(err);
  }
}

/// 日志拦截器
class LogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.d('🚀 REQUEST[${options.method}] => ${options.path}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.d('✅ RESPONSE[${response.statusCode}] => ${response.requestOptions.path}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.e('❌ ERROR[${err.response?.statusCode}] => ${err.requestOptions.path}');
    handler.next(err);
  }
}


