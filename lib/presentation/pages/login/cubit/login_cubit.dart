import 'package:babilon/core/application/models/response/login/login.dart';
import 'package:babilon/core/application/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:babilon/core/application/models/request/login/login_request.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:babilon/core/domain/resources/client_provider.dart';
import 'package:babilon/core/domain/utils/logger.dart';
import 'package:babilon/core/domain/utils/share_preferences.dart';
import 'package:babilon/core/domain/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;

  LoginCubit({required this.authRepository}) : super(const LoginState());

  void onChangeEmailOrUsername(String emailOrUsername) {
    String emailValidate = "";
    if (emailOrUsername.trim().isEmpty) {
      emailValidate = "Vui lòng nhập email hoặc tên đăng nhập";
    }
    emit(state.copyWith(
        emailOrUsername: emailOrUsername.trim(), emailValidate: emailValidate));
    onCheckEnableButton();
  }

  void onChangePassword(String password) {
    String passwordValidate = "";
    if (password.trim().isEmpty) {
      passwordValidate = "Vui lòng nhập mật khẩu";
    }
    // if (password.length < 6) {
    //   passwordValidate = "Mật khẩu phải có ít nhất 6 ký tự";
    // }
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
        emailOrUsername: state.emailOrUsername,
        password: state.password,
      ));

      if (response.isSuccess || response.data != null) {
        await saveLoggedInSession(response.data!);
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
      emit(
        state.copyWith(
          loginStatus: LoadStatus.FAILURE,
          errLogin: 'Đã xảy ra lỗi, vui lòng thử lại sau',
        ),
      );
    }
  }

  Future<void> saveLoggedInSession(LoginResponse res) async {
    try {
      await SharedPreferencesHelper.saveStringValue(
          SharedPreferencesHelper.ACCESS_TOKEN, res.accessToken ?? "");
      await SharedPreferencesHelper.saveStringValue(
          SharedPreferencesHelper.REFRESH_TOKEN, res.refreshToken ?? "");
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
