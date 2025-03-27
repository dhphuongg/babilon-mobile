import 'package:json_annotation/json_annotation.dart';

part 'verify.g.dart';

@JsonSerializable()
class VerifyOtpResponse {
  final String authToken;

  VerifyOtpResponse({
    required this.authToken,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpResponseToJson(this);
}
