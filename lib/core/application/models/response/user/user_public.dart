import 'package:babilon/core/application/models/entities/user.entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_public.g.dart';

@JsonSerializable()
class UserPublic extends UserEntity {
  final bool isMe;
  final bool isFollower;
  final bool isFollowing;

  UserPublic({
    required String id,
    required String username,
    required String fullName,
    String? avatar,
    String? signature,
    int? followerCount,
    int? followingCount,
    this.isMe = false,
    this.isFollower = false,
    this.isFollowing = false,
  }) : super(
          id: id,
          username: username,
          fullName: fullName,
          avatar: avatar,
          signature: signature,
          followerCount: followerCount ?? 0,
          followingCount: followingCount ?? 0,
        );

  UserPublic copyWith({
    String? id,
    String? username,
    String? fullName,
    String? avatar,
    String? signature,
    int? followerCount,
    int? followingCount,
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
        followerCount: followerCount ?? this.followerCount,
        followingCount: followingCount ?? this.followingCount,
        isMe: isMe ?? this.isMe,
        isFollower: isFollower ?? this.isFollower,
        isFollowing: isFollowing ?? this.isFollowing,
      );

  factory UserPublic.fromJson(Map<String, dynamic> json) =>
      _$UserPublicFromJson(json);

  Map<String, dynamic> toJson() => _$UserPublicToJson(this);
}
