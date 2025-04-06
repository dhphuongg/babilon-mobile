import 'package:babilon/core/application/api/array_response.dart';
import 'package:babilon/core/application/api/object_response.dart';
import 'package:babilon/core/application/models/response/user/user_profile.dart';
import 'package:babilon/core/application/models/response/user/user_public.dart';
import 'package:dio/dio.dart';

abstract class UserRepository {
  Future<ObjectResponse<UserProfile>> getUserProfile();

  Future<ObjectResponse<UserProfile>> updateProfile(FormData body);

  Future<ObjectResponse<ArrayResponse<UserPublic>>> getFollowers(String userId);

  Future<ObjectResponse<ArrayResponse<UserPublic>>> getFollowings(
      String userId);
}
