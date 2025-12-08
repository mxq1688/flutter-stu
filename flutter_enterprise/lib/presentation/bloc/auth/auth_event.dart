part of 'auth_bloc.dart';

/// 认证事件基类
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// 登录事件
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// 登出事件
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// 检查认证状态事件
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}


