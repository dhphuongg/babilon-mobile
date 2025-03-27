part of 'auth_cubit.dart';

enum RegisterStep { form, otp }

class AuthState extends Equatable {
  final LoadStatus? loginStatus;
  final String? errLogin;

  final String? errRegister;
  final RegisterStep currentStep;
  final LoadStatus? requestRegisterStatus;
  final LoadStatus? registerStatus;

  const AuthState({
    this.loginStatus,
    this.errLogin = '',
    this.errRegister = '',
    this.currentStep = RegisterStep.form,
    this.requestRegisterStatus,
    this.registerStatus,
  });

  AuthState copyWith({
    LoadStatus? loginStatus,
    String? errLogin,
    String? errRegister,
    RegisterStep? currentStep,
    LoadStatus? requestRegisterStatus,
    LoadStatus? registerStatus,
  }) {
    return AuthState(
      loginStatus: loginStatus ?? this.loginStatus,
      errLogin: errLogin ?? this.errLogin,
      errRegister: errRegister ?? this.errRegister,
      currentStep: currentStep ?? this.currentStep,
      requestRegisterStatus:
          requestRegisterStatus ?? this.requestRegisterStatus,
      registerStatus: registerStatus ?? this.registerStatus,
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
      ];
}
