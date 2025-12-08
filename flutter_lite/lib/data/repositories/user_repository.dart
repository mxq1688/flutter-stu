import '../models/user_model.dart';
import '../services/api_service.dart';
import '../../core/constants/api_constants.dart';

/// 用户仓库
class UserRepository {
  final ApiService _apiService = ApiService.instance;

  /// 登录
  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final token = data['token'] as String?;
        if (token != null) {
          await _apiService.setToken(token);
        }
        return UserModel.fromJson(data['user'] as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// 获取用户信息
  Future<UserModel?> getUserInfo() async {
    try {
      final response = await _apiService.get(ApiConstants.userInfo);
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return UserModel.fromJson(data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// 登出
  Future<bool> logout() async {
    try {
      await _apiService.post(ApiConstants.logout);
      await _apiService.setToken(null);
      return true;
    } catch (e) {
      await _apiService.setToken(null);
      return true;
    }
  }

  /// 获取用户列表
  Future<List<UserModel>> getUsers({int page = 1, int limit = 20}) async {
    try {
      final response = await _apiService.get(
        ApiConstants.users,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final users = (data['data'] as List)
            .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return users;
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }
}


