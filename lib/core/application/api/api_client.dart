import 'package:babilon/core/application/api/array_response.dart';
import 'package:babilon/core/application/models/request/auth/change_password.dart';
import 'package:babilon/core/application/models/request/auth/register.dart';
import 'package:babilon/core/application/models/request/auth/reset_password.dart';
import 'package:babilon/core/application/models/request/otp/request.dart';
import 'package:babilon/core/application/models/request/otp/verify.dart';
import 'package:babilon/core/application/models/response/otp/verify.dart';
import 'package:babilon/core/application/models/response/user/user.entity.dart';
import 'package:babilon/core/application/models/response/video/comment.dart';
import 'package:babilon/core/application/models/response/video/video.dart';
import 'package:dio/dio.dart';
import 'package:babilon/core/application/models/request/auth/login_request.dart';
import 'package:babilon/core/application/models/response/login/login.dart';
import 'package:retrofit/retrofit.dart';

import 'object_response.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: '')
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  // ========================== Auth ==========================
  @POST('/auth/login')
  Future<ObjectResponse<LoginResponse>> login(
    @Body() LoginRequest body,
  );

  @POST('/auth/register')
  Future<ObjectResponse<dynamic>> register(@Body() RegisterRequest body);

  @POST('/auth/logout')
  Future<ObjectResponse<dynamic>> logout();

  @POST('/auth/reset-password')
  Future<ObjectResponse<dynamic>> resetPassword(@Body() ResetPassword body);

  @GET('/auth/profile')
  Future<ObjectResponse<UserEntity>> getUserProfile();

  @POST('/auth/change-password')
  Future<ObjectResponse<dynamic>> changePassword(
    @Body() ChangePassword body,
  );

  // ========================== OTP ==========================
  @POST('/otp/request')
  Future<ObjectResponse<dynamic>> requestOtp(@Body() RequestOtpDto body);

  @POST('/otp/verify')
  Future<ObjectResponse<VerifyOtpResponse>> verifyOtp(@Body() VerifyOtp body);

  // ========================== User ==========================
  @PATCH('/user')
  Future<ObjectResponse<UserEntity>> updateProfile(
    @Body() FormData body,
  );

  @GET('/user/{userId}')
  Future<ObjectResponse<UserEntity>> getUserById(
    @Path('userId') String userId,
  );

  @POST('/user/follow/{userId}')
  Future<ObjectResponse> followUserById(
    @Path('userId') String userId,
  );

  @POST('/user/unfollow/{userId}')
  Future<ObjectResponse> unfollowUserById(
    @Path('userId') String userId,
  );

  @GET('/user/followers/{userId}')
  Future<ObjectResponse<ArrayResponse<UserEntity>>> getFollowers(
    @Path('userId') String userId,
  );

  @GET('/user/followings/{userId}')
  Future<ObjectResponse<ArrayResponse<UserEntity>>> getFollowings(
    @Path('userId') String userId,
  );

  // ========================== Video ==========================
  @GET('/video/trending')
  Future<ObjectResponse<ArrayResponse<Video>>> getTrendingVideos();

  @POST('/video/{videoId}/like')
  Future<ObjectResponse> likeVideoById(
    @Path('videoId') String videoId,
  );

  @DELETE('/video/{videoId}/like')
  Future<ObjectResponse> unlikeVideoById(
    @Path('videoId') String videoId,
  );

  @GET('/video/{videoId}/comment')
  Future<ObjectResponse<ArrayResponse<Comment>>> getCommentsByVideoId(
    @Path('videoId') String videoId,
  );
}
