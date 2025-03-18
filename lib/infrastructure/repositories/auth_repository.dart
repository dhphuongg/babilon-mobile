import 'package:babilon/core/application/api/object_response.dart';
import 'package:babilon/core/application/models/request/login/login_request.dart';
import 'package:babilon/core/application/models/response/login/login.dart';
import 'package:babilon/core/application/repositories/auth_repository.dart';
import 'package:babilon/core/domain/resources/client_provider.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl();

  @override
  Future<ObjectResponse<LoginResponse>> login(LoginRequest body) {
    return RestClientProvider.apiClient!.login(body);
  }
}
