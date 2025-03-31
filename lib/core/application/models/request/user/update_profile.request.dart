import 'package:json_annotation/json_annotation.dart';

part 'update_profile.request.g.dart';

@JsonSerializable()
class UpdateProfileRequest {
  String? username;
  String? fullName;
  String? signature;
  String? avatar;

  UpdateProfileRequest({
    this.username,
    this.fullName,
    this.signature,
    this.avatar,
  });

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileRequestToJson(this);
}
