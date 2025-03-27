import 'package:json_annotation/json_annotation.dart';

part 'reset_password.g.dart';

@JsonSerializable()
class ResetPassword {
  String newPassword;
  String token;

  ResetPassword({
    required this.newPassword,
    required this.token,
  });

  ResetPassword copyWith({
    String? newPassword,
    String? token,
  }) {
    return ResetPassword(
      newPassword: newPassword ?? this.newPassword,
      token: token ?? this.token,
    );
  }

  factory ResetPassword.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordToJson(this);
}
