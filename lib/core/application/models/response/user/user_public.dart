import 'package:json_annotation/json_annotation.dart';

part 'user_public.g.dart';

@JsonSerializable()
class UserPublic {
  final String id;
  final String username;
  final String fullName;
  final String? avatar;
  final String? signature;
  final bool isMe;
  final bool isFollower;
  final bool isFollowing;

  UserPublic({
    required this.id,
    required this.username,
    required this.fullName,
    this.avatar,
    this.signature,
    this.isMe = false,
    this.isFollower = false,
    this.isFollowing = false,
  });

  UserPublic copyWith({
    String? id,
    String? username,
    String? fullName,
    String? avatar,
    String? signature,
    bool? isMe,
    bool? isFollower,
    bool? isFollowing,
  }) =>
      UserPublic(
        id: id ?? this.id,
        username: username ?? this.username,
        fullName: fullName ?? this.fullName,
        avatar: avatar ?? this.avatar,
        signature: signature ?? this.signature,
        isMe: isMe ?? this.isMe,
        isFollower: isFollower ?? this.isFollower,
        isFollowing: isFollowing ?? this.isFollowing,
      );

  factory UserPublic.fromJson(Map<String, dynamic> json) =>
      _$UserPublicFromJson(json);

  Map<String, dynamic> toJson() => _$UserPublicToJson(this);
}
