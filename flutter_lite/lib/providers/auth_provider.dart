import 'package:flutter/material.dart';

import '../data/models/user_model.dart';
import '../data/repositories/user_repository.dart';
import '../core/utils/logger.dart';

/// 认证状态
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// 认证 Provider
class AuthProvider extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _errorMessage;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;

  /// 登录
  Future<bool> login(String email, String password) async {
    try {
      _status = AuthStatus.loading;
      _errorMessage = null;
      notifyListeners();

      _user = await _userRepository.login(email, password);
      
      if (_user != null) {
        _status = AuthStatus.authenticated;
        AppLogger.i('Login successful: ${_user!.name}');
        notifyListeners();
        return true;
      } else {
        _status = AuthStatus.unauthenticated;
        _errorMessage = '登录失败，请检查账号密码';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      AppLogger.e('Login failed', e);
      notifyListeners();
      return false;
    }
  }

  /// 登出
  Future<void> logout() async {
    try {
      _status = AuthStatus.loading;
      notifyListeners();

      await _userRepository.logout();
      
      _user = null;
      _status = AuthStatus.unauthenticated;
      AppLogger.i('Logout successful');
      notifyListeners();
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      AppLogger.e('Logout failed', e);
      notifyListeners();
    }
  }

  /// 检查登录状态
  Future<void> checkAuthStatus() async {
    try {
      _status = AuthStatus.loading;
      notifyListeners();

      _user = await _userRepository.getUserInfo();
      
      if (_user != null) {
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
      notifyListeners();
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  /// 清除错误信息
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}


