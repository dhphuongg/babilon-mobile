import 'package:babilon/core/domain/enum/role.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login.g.dart';

@JsonSerializable()
class LoginResponse {
  final String? accessToken;
  final String? refreshToken;
  final Role? role;

  LoginResponse({
    this.accessToken,
    this.refreshToken,
    this.role,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
