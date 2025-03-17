import 'package:json_annotation/json_annotation.dart';

part 'error_response.g.dart';
@JsonSerializable()
class ErrorResponse {
  int? code;
  String? message;
  String? details;
  dynamic validationErrors;

  ErrorResponse({
    this.code,
    this.message,
    this.details,
    this.validationErrors,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
    code: json["code"],
    message: json["message"],
    details: json["details"],
    validationErrors: json["validationErrors"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "details": details,
    "validationErrors": validationErrors,
  };
}