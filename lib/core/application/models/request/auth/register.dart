import 'package:json_annotation/json_annotation.dart';

part 'register.g.dart';

@JsonSerializable()
class RegisterRequest {
  final String email;
  final String username;
  final String fullName;
  final String password;
  final String otpCode;

  RegisterRequest({
    required this.email,
    required this.username,
    required this.fullName,
    required this.password,
    required this.otpCode,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
