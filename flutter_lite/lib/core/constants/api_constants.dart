/// API 常量配置
class ApiConstants {
  ApiConstants._();

  // 基础URL
  static const String baseUrl = 'https://api.example.com';
  
  // API 版本
  static const String apiVersion = '/api/v1';
  
  // 完整基础路径
  static String get apiBaseUrl => '$baseUrl$apiVersion';

  // 超时设置 (毫秒)
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;

  // API 端点
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String userInfo = '/user/info';
  static const String users = '/users';

  // 请求头
  static const String contentType = 'application/json';
  static const String accept = 'application/json';
}


