import 'package:babilon/core/application/api/array_response.dart';
import 'package:babilon/core/application/api/object_response.dart';
import 'package:babilon/core/application/models/response/user/user_profile.dart';
import 'package:babilon/core/application/models/response/user/user_public.dart';
import 'package:babilon/core/application/repositories/user_repository.dart';
import 'package:babilon/core/domain/resources/client_provider.dart';
import 'package:dio/dio.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<ObjectResponse<UserProfile>> getUserProfile() {
    return RestClientProvider.apiClient!.getUserProfile();
  }

  @override
  Future<ObjectResponse<UserProfile>> updateProfile(FormData body) {
    return RestClientProvider.apiClient!.updateProfile(body);
  }

  @override
  Future<ObjectResponse<ArrayResponse<UserPublic>>> getFollowers(
      String userId) {
    return RestClientProvider.apiClient!.getFollowers(userId);
  }

  @override
  Future<ObjectResponse<ArrayResponse<UserPublic>>> getFollowings(
      String userId) {
    return RestClientProvider.apiClient!.getFollowings(userId);
  }

  @override
  Future<ObjectResponse> followUser(String userId) {
    return RestClientProvider.apiClient!.followUserById(userId);
  }

  @override
  Future<ObjectResponse> unfollowUser(String userId) {
    return RestClientProvider.apiClient!.unfollowUserById(userId);
  }
}
