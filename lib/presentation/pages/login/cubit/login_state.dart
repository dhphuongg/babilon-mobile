part of 'login_cubit.dart';

class LoginState extends Equatable {
  final String emailOrUsername;
  final String? emailValidate;
  final String password;
  final String? passwordValidate;
  final bool isEnable;

  final LoadStatus? loginStatus;
  final String? errLogin;

  const LoginState(
      {this.emailOrUsername = "",
      this.emailValidate,
      this.password = "",
      this.passwordValidate,
      this.isEnable = false,
      this.loginStatus,
      this.errLogin});

  LoginState copyWith({
    String? emailOrUsername,
    String? emailValidate,
    String? password,
    String? passwordValidate,
    bool? isEnable,
    LoadStatus? loginStatus,
    String? errLogin,
  }) {
    return LoginState(
      emailOrUsername: emailOrUsername ?? this.emailOrUsername,
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
        emailOrUsername,
        emailValidate,
        password,
        passwordValidate,
        isEnable,
        loginStatus,
        errLogin,
      ];
}
