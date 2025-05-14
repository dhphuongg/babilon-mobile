import 'package:babilon/core/application/api/array_response.dart';
import 'package:babilon/core/application/api/object_response.dart';
import 'package:babilon/core/application/models/response/user/user.entity.dart';
import 'package:dio/dio.dart';

abstract class UserRepository {
  Future<ObjectResponse<UserEntity>> getUserProfile();

  Future<ObjectResponse<UserEntity>> updateProfile(FormData body);

  Future<ObjectResponse<UserEntity>> getUserById(String userId);

  Future<ObjectResponse<ArrayResponse<UserEntity>>> getFollowers(
    String userId,
  );

  Future<ObjectResponse<ArrayResponse<UserEntity>>> getFollowings(
    String userId,
  );

  Future<ObjectResponse> followUser(String userId);

  Future<ObjectResponse> unfollowUser(String userId);

  Future<ObjectResponse<ArrayResponse<UserEntity>>> searchUsers(
    String q,
  );
}
