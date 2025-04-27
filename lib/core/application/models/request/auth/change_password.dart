import 'package:json_annotation/json_annotation.dart';

part 'change_password.g.dart';

@JsonSerializable()
class ChangePassword {
  String currentPassword;
  String newPassword;

  ChangePassword({
    required this.currentPassword,
    required this.newPassword,
  });

  factory ChangePassword.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordToJson(this);
}
