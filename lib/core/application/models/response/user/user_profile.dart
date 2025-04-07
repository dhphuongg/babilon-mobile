import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile {
  String id;
  String username;
  String fullName;
  String email;
  String? avatar;
  String? signature;
  UserProfileStats stats;

  UserProfile({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    this.avatar,
    this.signature,
    required this.stats,
  });

  UserProfile copyWith({
    String? id,
    String? username,
    String? fullName,
    String? normalizedName,
    String? email,
    dynamic avatar,
    dynamic signature,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserProfileStats? stats,
  }) =>
      UserProfile(
        id: id ?? this.id,
        username: username ?? this.username,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        avatar: avatar ?? this.avatar,
        signature: signature ?? this.signature,
        stats: stats ?? this.stats,
      );

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}

@JsonSerializable()
class UserProfileStats {
  int followerCount;
  int followingCount;

  UserProfileStats({
    required this.followerCount,
    required this.followingCount,
  });

  UserProfileStats copyWith({
    int? followerCount,
    int? followingCount,
  }) =>
      UserProfileStats(
        followerCount: followerCount ?? this.followerCount,
        followingCount: followingCount ?? this.followingCount,
      );

  factory UserProfileStats.fromJson(Map<String, dynamic> json) =>
      _$UserProfileStatsFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileStatsToJson(this);
}
