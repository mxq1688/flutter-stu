import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/constants/api_constants.dart';
import '../../models/user_model.dart';

part 'api_client.g.dart';

/// API 客户端 - Retrofit
@RestApi(baseUrl: '')
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @POST(ApiConstants.login)
  Future<LoginResponse> login(@Body() LoginRequest request);

  @GET(ApiConstants.userInfo)
  Future<UserModel> getUserInfo();

  @POST(ApiConstants.logout)
  Future<void> logout();
}


