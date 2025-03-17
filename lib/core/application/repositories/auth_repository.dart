import 'package:babilon/core/application/api/object_response.dart';
import 'package:babilon/core/application/models/request/login/login_request.dart';
import 'package:babilon/core/application/models/response/login/login.dart';

abstract class IAuthRepository {
  Future<ObjectResponse<LoginResponse>> login(LoginRequest body);
}
