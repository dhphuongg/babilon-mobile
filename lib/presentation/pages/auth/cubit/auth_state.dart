part of 'auth_cubit.dart';

enum RegisterStep { form, otp }

class AuthState extends Equatable {
  final LoadStatus? loginStatus;
  final String? errLogin;

  final String? errRegister;
  final RegisterStep currentStep;
  final LoadStatus? requestRegisterStatus;
  final LoadStatus? registerStatus;

  final String? errResetPassword;
  final LoadStatus? requestResetPasswordStatus;
  final LoadStatus? resetPasswordVerifyOtpStatus;
  final LoadStatus? resetPasswordStatus;

  const AuthState({
    this.loginStatus,
    this.errLogin,
    this.errRegister,
    this.currentStep = RegisterStep.form,
    this.requestRegisterStatus,
    this.registerStatus,
    this.errResetPassword,
    this.requestResetPasswordStatus,
    this.resetPasswordVerifyOtpStatus,
    this.resetPasswordStatus,
  });

  AuthState copyWith({
    LoadStatus? loginStatus,
    String? errLogin,
    String? errRegister,
    RegisterStep? currentStep,
    LoadStatus? requestRegisterStatus,
    LoadStatus? registerStatus,
    String? errResetPassword,
    LoadStatus? requestResetPasswordStatus,
    LoadStatus? resetPasswordVerifyOtpStatus,
    LoadStatus? resetPasswordStatus,
  }) {
    return AuthState(
      loginStatus: loginStatus ?? this.loginStatus,
      errLogin: errLogin ?? this.errLogin,
      errRegister: errRegister ?? this.errRegister,
      currentStep: currentStep ?? this.currentStep,
      requestRegisterStatus:
          requestRegisterStatus ?? this.requestRegisterStatus,
      registerStatus: registerStatus ?? this.registerStatus,
      errResetPassword: errResetPassword ?? this.errResetPassword,
      requestResetPasswordStatus:
          requestResetPasswordStatus ?? this.requestResetPasswordStatus,
      resetPasswordVerifyOtpStatus:
          resetPasswordVerifyOtpStatus ?? this.resetPasswordVerifyOtpStatus,
      resetPasswordStatus: resetPasswordStatus ?? this.resetPasswordStatus,
    );
  }

  @override
  List<Object?> get props => [
        loginStatus,
        errLogin,
        errRegister,
        currentStep,
        requestRegisterStatus,
        registerStatus,
        errResetPassword,
        requestResetPasswordStatus,
        resetPasswordVerifyOtpStatus,
        resetPasswordStatus,
      ];
}
