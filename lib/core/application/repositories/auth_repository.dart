import 'package:babilon/core/application/api/object_response.dart';
import 'package:babilon/core/application/models/request/auth/change_password.dart';
import 'package:babilon/core/application/models/request/auth/login_request.dart';
import 'package:babilon/core/application/models/request/auth/register.dart';
import 'package:babilon/core/application/models/request/auth/reset_password.dart';
import 'package:babilon/core/application/models/request/otp/request.dart';
import 'package:babilon/core/application/models/request/otp/verify.dart';
import 'package:babilon/core/application/models/response/login/login.dart';
import 'package:babilon/core/application/models/response/otp/verify.dart';

abstract class AuthRepository {
  Future<ObjectResponse<LoginResponse>> login(LoginRequest body);
  Future<ObjectResponse<dynamic>> requestOtp(RequestOtpDto body);
  Future<ObjectResponse<dynamic>> register(RegisterRequest body);
  Future<ObjectResponse<dynamic>> logout();
  Future<ObjectResponse<VerifyOtpResponse>> verifyOtp(VerifyOtp body);
  Future<ObjectResponse<dynamic>> resetPassword(ResetPassword body);
  Future<ObjectResponse<dynamic>> changePassword(ChangePassword body);
}
