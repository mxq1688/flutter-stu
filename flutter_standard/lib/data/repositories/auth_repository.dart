import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../datasources/remote/api_client.dart';
import '../datasources/remote/dio_client.dart';

/// Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final apiClient = ApiClient(dio);
  return AuthRepository(apiClient);
});

/// 认证仓库
class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  /// 登录
  Future<LoginResponse> login(String email, String password) async {
    final response = await _apiClient.login(
      LoginRequest(email: email, password: password),
    );
    
    // 保存 token
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', response.token);
    
    return response;
  }

  /// 获取用户信息
  Future<UserModel> getUserInfo() async {
    return await _apiClient.getUserInfo();
  }

  /// 登出
  Future<void> logout() async {
    try {
      await _apiClient.logout();
    } finally {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
    }
  }

  /// 检查是否已登录
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null && token.isNotEmpty;
  }
}


