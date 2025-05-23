import 'package:babilon/core/application/models/request/auth/change_password.dart';
import 'package:babilon/core/application/models/request/auth/register.dart';
import 'package:babilon/core/application/models/request/auth/reset_password.dart';
import 'package:babilon/core/application/models/request/otp/request.dart';
import 'package:babilon/core/application/models/request/otp/verify.dart';
import 'package:babilon/core/application/models/response/login/login.dart';
import 'package:babilon/core/application/repositories/auth_repository.dart';
import 'package:babilon/core/domain/enum/otp_type.dart';
import 'package:equatable/equatable.dart';
import 'package:babilon/core/application/models/request/auth/login_request.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:babilon/core/domain/resources/client_provider.dart';
import 'package:babilon/core/domain/utils/logger.dart';
import 'package:babilon/core/domain/utils/share_preferences.dart';
import 'package:babilon/core/domain/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(const AuthState());

  Future<void> login(LoginRequest body) async {
    try {
      emit(state.copyWith(loginStatus: LoadStatus.LOADING));

      final response = await authRepository.login(body);

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

  void changeStep(RegisterStep step) {
    emit(state.copyWith(currentStep: step));
  }

  Future<void> requestRegister(String email) async {
    try {
      emit(state.copyWith(
        errRegister: null,
        requestRegisterStatus: LoadStatus.LOADING,
      ));

      final response = await authRepository
          .requestOtp(RequestOtpDto(email: email, type: OtpType.REGISTER));

      if (response.success) {
        emit(state.copyWith(
          requestRegisterStatus: LoadStatus.SUCCESS,
          currentStep: RegisterStep.otp,
        ));
      } else {
        emit(state.copyWith(
          requestRegisterStatus: LoadStatus.FAILURE,
          errRegister: response.error,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        requestRegisterStatus: LoadStatus.FAILURE,
        errRegister: e.toString(),
      ));
    }
  }

  Future<void> register(RegisterRequest body) async {
    try {
      emit(state.copyWith(
        errRegister: '',
        registerStatus: LoadStatus.LOADING,
      ));
      final response = await authRepository.register(body);

      if (response.success) {
        emit(state.copyWith(
          errRegister: '',
          registerStatus: LoadStatus.SUCCESS,
        ));
      } else {
        emit(state.copyWith(
          registerStatus: LoadStatus.FAILURE,
          errRegister: response.error,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        errRegister: e.toString(),
      ));
    }
  }

  void clearError() {
    emit(state.copyWith(errRegister: null));
  }

  Future<void> logout() async {
    try {
      await authRepository.logout();
      await SharedPreferencesHelper.removeByKey(
        SharedPreferencesHelper.ACCESS_TOKEN,
      );
      await SharedPreferencesHelper.removeByKey(
        SharedPreferencesHelper.REFRESH_TOKEN,
      );
      await RestClientProvider.init(forceInit: true);
    } catch (e) {
      AppLogger.instance.error(e);
    }
  }

  Future<void> requestResetPassword(String email) async {
    try {
      emit(
        state.copyWith(
          errResetPassword: '',
          requestResetPasswordStatus: LoadStatus.LOADING,
        ),
      );

      final response = await authRepository.requestOtp(
        RequestOtpDto(
          email: email,
          type: OtpType.PASSWORD_RESET,
        ),
      );

      if (response.success) {
        emit(state.copyWith(
          requestResetPasswordStatus: LoadStatus.SUCCESS,
          currentStep: RegisterStep.otp,
        ));
      } else {
        emit(state.copyWith(
          requestResetPasswordStatus: LoadStatus.FAILURE,
          errResetPassword: response.error,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        requestResetPasswordStatus: LoadStatus.FAILURE,
        errResetPassword: e.toString(),
      ));
    }
  }

  Future<String?> verifyOtp(VerifyOtp body) async {
    try {
      emit(
        state.copyWith(
          errResetPassword: '',
          resetPasswordVerifyOtpStatus: LoadStatus.LOADING,
        ),
      );

      final response = await authRepository.verifyOtp(body);

      if (response.success && response.data?.authToken != null) {
        emit(state.copyWith(
          resetPasswordVerifyOtpStatus: LoadStatus.SUCCESS,
        ));
        return response.data?.authToken;
      } else {
        emit(state.copyWith(
          resetPasswordVerifyOtpStatus: LoadStatus.FAILURE,
          errResetPassword: response.error,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        resetPasswordVerifyOtpStatus: LoadStatus.FAILURE,
        errResetPassword: e.toString(),
      ));
    }
    return '';
  }

  Future<void> resetPassword(ResetPassword body) async {
    try {
      emit(state.copyWith(
        errResetPassword: '',
        resetPasswordStatus: LoadStatus.LOADING,
      ));

      final response = await authRepository.resetPassword(body);

      if (response.success) {
        emit(state.copyWith(
          resetPasswordStatus: LoadStatus.SUCCESS,
        ));
      } else {
        emit(state.copyWith(
          resetPasswordStatus: LoadStatus.FAILURE,
          errResetPassword: response.error,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        resetPasswordStatus: LoadStatus.FAILURE,
        errResetPassword: e.toString(),
      ));
    }
  }

  Future<void> changePassword(ChangePassword body) async {
    try {
      emit(state.copyWith(
        errChangePassword: '',
        changePasswordStatus: LoadStatus.LOADING,
      ));

      final response = await authRepository.changePassword(body);
      if (response.success) {
        emit(state.copyWith(
          errChangePassword: '',
          changePasswordStatus: LoadStatus.SUCCESS,
        ));
      } else {
        emit(state.copyWith(
          changePasswordStatus: LoadStatus.FAILURE,
          errChangePassword: response.error,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        changePasswordStatus: LoadStatus.FAILURE,
        errChangePassword: e.toString(),
      ));
    }
  }
}
