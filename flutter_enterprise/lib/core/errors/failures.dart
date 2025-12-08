import 'package:equatable/equatable.dart';

/// 失败基类 - 用于错误处理
abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

/// 服务器错误
class ServerFailure extends Failure {
  const ServerFailure({super.message = '服务器错误', super.code});
}

/// 网络错误
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = '网络连接失败', super.code});
}

/// 缓存错误
class CacheFailure extends Failure {
  const CacheFailure({super.message = '缓存错误', super.code});
}

/// 认证错误
class AuthFailure extends Failure {
  const AuthFailure({super.message = '认证失败', super.code});
}

/// 验证错误
class ValidationFailure extends Failure {
  const ValidationFailure({super.message = '验证失败', super.code});
}

/// 未知错误
class UnknownFailure extends Failure {
  const UnknownFailure({super.message = '未知错误', super.code});
}


