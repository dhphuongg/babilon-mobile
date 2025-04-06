import 'package:json_annotation/json_annotation.dart';

part 'user_public.g.dart';

@JsonSerializable()
class UserPublic {
  String id;
  String username;
  String? avatar;
  String? signature;
  String fullName;

  UserPublic({
    required this.id,
    required this.username,
    required this.avatar,
    required this.signature,
    required this.fullName,
  });

  UserPublic copyWith({
    String? id,
    String? username,
    String? avatar,
    String? signature,
    String? fullName,
  }) =>
      UserPublic(
        id: id ?? this.id,
        username: username ?? this.username,
        avatar: avatar ?? this.avatar,
        signature: signature ?? this.signature,
        fullName: fullName ?? this.fullName,
      );

  factory UserPublic.fromJson(Map<String, dynamic> json) =>
      _$UserPublicFromJson(json);

  Map<String, dynamic> toJson() => _$UserPublicToJson(this);
}
