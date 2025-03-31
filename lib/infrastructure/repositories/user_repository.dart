import 'package:babilon/core/application/api/object_response.dart';
import 'package:babilon/core/application/models/request/user/update_profile.request.dart';
import 'package:babilon/core/application/models/response/user/user_profile.dart';
import 'package:babilon/core/application/repositories/user_repository.dart';
import 'package:babilon/core/domain/resources/client_provider.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<ObjectResponse<UserProfile>> getUserProfile() {
    return RestClientProvider.apiClient!.getUserProfile();
  }

  @override
  Future<ObjectResponse<UserProfile>> updateProfile(UpdateProfileRequest body) {
    return RestClientProvider.apiClient!.updateProfile(body);
  }
}
