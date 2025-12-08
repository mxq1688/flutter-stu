import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../core/utils/logger.dart';

part 'auth_provider.g.dart';

/// 认证状态
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// 认证状态模型
class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  bool get isLoading => status == AuthStatus.loading;
  bool get isAuthenticated => status == AuthStatus.authenticated;

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}

/// Auth Notifier - 使用 Riverpod Generator
@riverpod
class Auth extends _$Auth {
  @override
  AuthState build() {
    return const AuthState();
  }

  /// 登录
  Future<bool> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      final repository = ref.read(authRepositoryProvider);
      final response = await repository.login(email, password);
      
      state = AuthState(
        status: AuthStatus.authenticated,
        user: response.user,
      );
      
      AppLogger.i('Login successful: ${response.user.name}');
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      AppLogger.e('Login failed', e);
      return false;
    }
  }

  /// 登出
  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.logout();
      
      state = const AuthState(status: AuthStatus.unauthenticated);
      AppLogger.i('Logout successful');
    } catch (e) {
      state = const AuthState(status: AuthStatus.unauthenticated);
      AppLogger.e('Logout error', e);
    }
  }

  /// 检查登录状态
  Future<void> checkAuthStatus() async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final repository = ref.read(authRepositoryProvider);
      final isLoggedIn = await repository.isLoggedIn();
      
      if (isLoggedIn) {
        final user = await repository.getUserInfo();
        state = AuthState(
          status: AuthStatus.authenticated,
          user: user,
        );
      } else {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }
}


