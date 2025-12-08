import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/constants/api_constants.dart';
import '../../models/user_model.dart';

part 'api_client.g.dart';

/// API 客户端 - 使用 Retrofit 生成
@RestApi(baseUrl: '')
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  /// 登录
  @POST(ApiConstants.login)
  Future<LoginResponse> login(@Body() LoginRequest request);

  /// 获取用户信息
  @GET(ApiConstants.userInfo)
  Future<UserModel> getUserInfo();

  /// 获取用户列表
  @GET(ApiConstants.users)
  Future<List<UserModel>> getUsers(
    @Query('page') int page,
    @Query('limit') int limit,
  );

  /// 登出
  @POST(ApiConstants.logout)
  Future<void> logout();
}


