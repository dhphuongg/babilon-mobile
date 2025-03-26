part of 'login_cubit.dart';

class LoginState extends Equatable {
  final LoadStatus? loginStatus;
  final String? errLogin;

  const LoginState({this.loginStatus, this.errLogin});

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
      loginStatus: loginStatus ?? this.loginStatus,
      errLogin: errLogin ?? this.errLogin,
    );
  }

  @override
  List<Object?> get props => [
        loginStatus,
        errLogin,
      ];
}
