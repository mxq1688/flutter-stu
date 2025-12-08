import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/user_entity.dart';

/// 认证仓库接口 - 领域层
abstract class AuthRepository {
  /// 登录
  Future<Either<Failure, UserEntity>> login(String email, String password);

  /// 登出
  Future<Either<Failure, void>> logout();

  /// 获取当前用户
  Future<Either<Failure, UserEntity>> getCurrentUser();

  /// 检查是否已登录
  Future<bool> isLoggedIn();
}


