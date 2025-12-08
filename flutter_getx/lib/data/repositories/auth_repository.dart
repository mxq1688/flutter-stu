import 'package:get/get.dart';

import '../../core/constants/api_constants.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

/// 认证仓库
class AuthRepository {
  final ApiService _apiService = Get.find<ApiService>();

  /// 登录
  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        await _apiService.setToken(data['token'] as String?);
        return UserModel.fromJson(data['user'] as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// 登出
  Future<void> logout() async {
    try {
      await _apiService.post(ApiConstants.logout);
    } finally {
      await _apiService.setToken(null);
    }
  }

  /// 获取用户信息
  Future<UserModel?> getUserInfo() async {
    try {
      final response = await _apiService.get(ApiConstants.userInfo);
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 是否已登录
  bool get isLoggedIn => _apiService.token != null;
}


