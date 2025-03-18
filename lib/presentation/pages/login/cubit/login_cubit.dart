import 'package:babilon/core/application/models/response/login/login.dart';
import 'package:babilon/core/application/models/response/user/user_profile.dart';
import 'package:babilon/core/application/repositories/app_cubit/app_cubit.dart';
import 'package:babilon/core/application/repositories/auth_repository.dart';
import 'package:babilon/di.dart';
import 'package:equatable/equatable.dart';
import 'package:babilon/core/application/api/error_response.dart';
import 'package:babilon/core/application/models/request/login/login_request.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:babilon/core/domain/resources/client_provider.dart';
import 'package:babilon/core/domain/utils/logger.dart';
import 'package:babilon/core/domain/utils/share_preferrences.dart';
import 'package:babilon/core/domain/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;
  final AppCubit _appCubit = getIt<AppCubit>();

  LoginCubit({required this.authRepository}) : super(const LoginState());

  void onChangeEmail(String email) {
    String emailValidate = "";
    if (email.trim().isEmpty) {
      emailValidate = "Yêu cầu nhập email";
    }
    emit(state.copyWith(email: email.trim(), emailValidate: emailValidate));
    onCheckEnableButton();
  }

  void onChangePassword(String password) {
    String passwordValidate = "";
    if (password.trim().isEmpty) {
      passwordValidate = "Yêu cầu nhập mật khẩu";
    }
    if (password.length < 6) {
      passwordValidate = "Mật khẩu phải có ít nhất 6 ký tự";
    }
    emit(state.copyWith(
        password: password.trim(), passwordValidate: passwordValidate));
    onCheckEnableButton();
  }

  void onCheckEnableButton() {
    final isEnable = state.emailValidate?.isEmpty == true &&
        state.passwordValidate?.isEmpty == true;
    emit(state.copyWith(isEnable: isEnable));
  }

  Future<void> login() async {
    try {
      emit(state.copyWith(loginStatus: LoadStatus.LOADING));

      final response = await authRepository.login(LoginRequest(
        userNameOrEmailAddress: state.email,
        password: state.password,
      ));

      if (response.isSuccess || response.result != null) {
        await saveLoggedInSession(response.result!);
        _appCubit.saveUserProfile(UserProfile(
          userId: response.result?.userId ?? 0,
          companyName: response.result?.companyName ?? '',
          projectId: response.result?.projectId ?? 0,
          prospectId: response.result?.prospectId ?? 0,
          firstName: response.result?.firstName ?? '',
          lastName: response.result?.lastName ?? '',
        ));
        emit(state.copyWith(
          loginStatus: LoadStatus.SUCCESS,
        ));
      } else {
        emit(state.copyWith(
          loginStatus: LoadStatus.FAILURE,
          errLogin: response.error,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
          loginStatus: LoadStatus.FAILURE,
          errLogin: ErrorResponse(message: e.toString())));
    }
  }

  Future<void> saveLoggedInSession(LoginResponse res) async {
    try {
      await SharedPreferencesHelper.saveStringValue(
          SharedPreferencesHelper.ACCESS_TOKEN, res.accessToken ?? "");
      await SharedPreferencesHelper.saveStringValue(
          SharedPreferencesHelper.USER_ID, res.userId.toString());
      await SharedPreferencesHelper.saveStringValue(
          SharedPreferencesHelper.PROJECT_ID, res.projectId.toString());
      await SharedPreferencesHelper.saveStringValue(
          SharedPreferencesHelper.PROSPECT_ID, res.prospectId.toString());
      await SharedPreferencesHelper.saveStringValue(
          SharedPreferencesHelper.FIRST_NAME, res.firstName ?? "");
      await SharedPreferencesHelper.saveStringValue(
          SharedPreferencesHelper.LAST_NAME, res.lastName ?? "");
      await SharedPreferencesHelper.saveStringValue(
          SharedPreferencesHelper.COMPANY_NAME, res.companyName ?? "");
      await RestClientProvider.init(forceInit: true);
    } catch (e) {
      AppLogger.instance.error(e);
    }
  }

  Future<String> getAccessToken() async {
    final String token = await SharedPreferencesHelper.getStringValue(
        SharedPreferencesHelper.ACCESS_TOKEN);
    return token;
  }
}
