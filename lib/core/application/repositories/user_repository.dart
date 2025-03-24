import 'package:babilon/core/application/api/object_response.dart';
import 'package:babilon/core/application/models/response/user/user_profile.dart';

abstract class UserRepository {
  Future<ObjectResponse<UserProfile>> getUserProfile();
}
