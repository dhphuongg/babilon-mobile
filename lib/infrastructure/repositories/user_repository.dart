import 'package:babilon/core/application/api/array_response.dart';
import 'package:babilon/core/application/api/object_response.dart';
import 'package:babilon/core/application/models/response/user/user.entity.dart';
import 'package:babilon/core/application/repositories/user_repository.dart';
import 'package:babilon/core/domain/resources/client_provider.dart';
import 'package:dio/dio.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<ObjectResponse<UserEntity>> getUserProfile() {
    return RestClientProvider.apiClient!.getUserProfile();
  }

  @override
  Future<ObjectResponse<UserEntity>> updateProfile(FormData body) {
    return RestClientProvider.apiClient!.updateProfile(body);
  }

  @override
  Future<ObjectResponse<UserEntity>> getUserById(String userId) {
    return RestClientProvider.apiClient!.getUserById(userId);
  }

  @override
  Future<ObjectResponse<ArrayResponse<UserEntity>>> getFollowers(
      String userId) {
    return RestClientProvider.apiClient!.getFollowers(userId);
  }

  @override
  Future<ObjectResponse<ArrayResponse<UserEntity>>> getFollowings(
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

  @override
  Future<ObjectResponse<ArrayResponse<UserEntity>>> searchUsers(String q) {
    return RestClientProvider.apiClient!.searchUsers(q);
  }
}
