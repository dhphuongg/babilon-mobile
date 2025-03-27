import 'package:babilon/core/domain/enum/otp_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verify.g.dart';

@JsonSerializable()
class VerifyOtp {
  final String email;
  final OtpType type;
  final String otpCode;

  VerifyOtp({
    required this.email,
    required this.type,
    required this.otpCode,
  });

  factory VerifyOtp.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpToJson(this);
}
