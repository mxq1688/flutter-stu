/// API 常量配置
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.example.com';
  static const String apiVersion = '/api/v1';
  static String get apiBaseUrl => '$baseUrl$apiVersion';

  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String userInfo = '/user/info';
}


