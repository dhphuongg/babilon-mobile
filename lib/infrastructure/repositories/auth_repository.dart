import 'package:babilon/core/application/api/object_response.dart';
import 'package:babilon/core/application/models/request/auth/login_request.dart';
import 'package:babilon/core/application/models/request/auth/register.dart';
import 'package:babilon/core/application/models/request/otp/request.dart';
import 'package:babilon/core/application/models/response/login/login.dart';
import 'package:babilon/core/application/repositories/auth_repository.dart';
import 'package:babilon/core/domain/resources/client_provider.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl();

  @override
  Future<ObjectResponse<LoginResponse>> login(LoginRequest body) {
    return RestClientProvider.apiClient!.login(body);
  }

  @override
  Future<ObjectResponse<void>> requestOtp(RequestOtpDto body) {
    return RestClientProvider.apiClient!.requestOtp(body);
  }

  @override
  Future<ObjectResponse> register(RegisterRequest body) {
    return RestClientProvider.apiClient!.register(body);
  }

  @override
  Future<ObjectResponse<void>> logout() {
    return RestClientProvider.apiClient!.logout();
  }
}
