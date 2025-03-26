import 'package:babilon/core/application/models/request/auth/register.dart';
import 'package:babilon/core/application/models/request/otp/request.dart';
import 'package:babilon/core/application/models/response/user/user_profile.dart';
import 'package:dio/dio.dart';
import 'package:babilon/core/application/models/request/auth/login_request.dart';
import 'package:babilon/core/application/models/response/login/login.dart';
import 'package:retrofit/retrofit.dart';

import 'object_response.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: '')
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  @POST('/auth/login')
  Future<ObjectResponse<LoginResponse>> login(
    @Body() LoginRequest body,
  );

  @POST('/auth/register')
  Future<ObjectResponse<dynamic>> register(@Body() RegisterRequest body);

  @POST('/auth/logout')
  Future<ObjectResponse<dynamic>> logout();

  @GET('/auth/profile')
  Future<ObjectResponse<UserProfile>> getUserProfile();

  @POST('/otp/request')
  Future<ObjectResponse<dynamic>> requestOtp(@Body() RequestOtpDto body);
}
