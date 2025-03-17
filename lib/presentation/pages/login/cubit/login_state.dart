part of 'login_cubit.dart';

class LoginState extends Equatable {
  final String email;
  final String? emailValidate;
  final String password;
  final String? passwordValidate;
  final bool isEnable;

  final LoadStatus? loginStatus;
  final ErrorResponse? errLogin;

  const LoginState(
      {this.email = "",
      this.emailValidate,
      this.password = "",
      this.passwordValidate,
      this.isEnable = false,
      this.loginStatus,
      this.errLogin});

  LoginState copyWith({
    String? email,
    String? emailValidate,
    String? password,
    String? passwordValidate,
    bool? isEnable,
    LoadStatus? loginStatus,
    ErrorResponse? errLogin,
  }) {
    return LoginState(
      email: email ?? this.email,
      emailValidate: emailValidate ?? this.emailValidate,
      password: password ?? this.password,
      passwordValidate: passwordValidate ?? this.passwordValidate,
      isEnable: isEnable ?? this.isEnable,
      loginStatus: loginStatus ?? this.loginStatus,
      errLogin: errLogin ?? this.errLogin,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        email,
        emailValidate,
        password,
        passwordValidate,
        isEnable,
        loginStatus,
        errLogin,
      ];
}
