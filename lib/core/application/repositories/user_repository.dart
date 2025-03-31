import 'package:babilon/core/application/api/object_response.dart';
import 'package:babilon/core/application/models/request/user/update_profile.request.dart';
import 'package:babilon/core/application/models/response/user/user_profile.dart';

abstract class UserRepository {
  Future<ObjectResponse<UserProfile>> getUserProfile();

  Future<ObjectResponse<UserProfile>> updateProfile(UpdateProfileRequest body);
}
