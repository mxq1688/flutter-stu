import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/api_client.dart';
import '../models/user_model.dart';

/// 认证仓库实现 - 数据层
class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;

  AuthRepositoryImpl(this._apiClient);

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    try {
      final response = await _apiClient.login(
        LoginRequest(email: email, password: password),
      );

      // 保存 token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', response.token);

      return Right(response.user.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _apiClient.logout();
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');

      return const Right(null);
    } on DioException catch (e) {
      // 即使请求失败也清除本地 token
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final user = await _apiClient.getUserInfo();
      return Right(user.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null && token.isNotEmpty;
  }

  Failure _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(message: '连接超时');
      case DioExceptionType.connectionError:
        return const NetworkFailure(message: '网络连接失败');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return const AuthFailure(message: '认证失败，请重新登录');
        } else if (statusCode == 403) {
          return const AuthFailure(message: '无权限访问');
        } else if (statusCode == 404) {
          return const ServerFailure(message: '资源不存在');
        } else if (statusCode != null && statusCode >= 500) {
          return const ServerFailure(message: '服务器错误');
        }
        return ServerFailure(message: e.message ?? '请求失败');
      default:
        return UnknownFailure(message: e.message ?? '未知错误');
    }
  }
}


