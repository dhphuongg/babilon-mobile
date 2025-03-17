import 'package:json_annotation/json_annotation.dart';

part 'login.g.dart';

@JsonSerializable()
class LoginResponse {
  final String? accessToken;
  final String? encryptedAccessToken;
  final int? expireInSeconds;
  final int? userId;
  final List<String?>? roleName;
  String? companyName;
  int? projectId;
  int? prospectId;
  String? firstName;
  String? lastName;

  LoginResponse({
    this.accessToken,
    this.encryptedAccessToken,
    this.expireInSeconds,
    this.userId,
    this.roleName,
    this.companyName,
    this.projectId,
    this.prospectId,
    this.firstName,
    this.lastName,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
