import 'package:babilon/core/domain/enum/otp_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'request.g.dart';

@JsonSerializable()
class RequestOtpDto {
  final String email;
  final OtpType type;

  RequestOtpDto({
    required this.email,
    required this.type,
  });

  factory RequestOtpDto.fromJson(Map<String, dynamic> json) =>
      _$RequestOtpDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RequestOtpDtoToJson(this);
}
