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
  UserProfileCount count;

  UserProfile({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    this.avatar,
    this.signature,
    required this.count,
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
    UserProfileCount? count,
  }) =>
      UserProfile(
        id: id ?? this.id,
        username: username ?? this.username,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        avatar: avatar ?? this.avatar,
        signature: signature ?? this.signature,
        count: count ?? this.count,
      );

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}

@JsonSerializable()
class UserProfileCount {
  int followers;
  int followings;

  UserProfileCount({
    required this.followers,
    required this.followings,
  });

  UserProfileCount copyWith({
    int? followers,
    int? followings,
  }) =>
      UserProfileCount(
        followers: followers ?? this.followers,
        followings: followings ?? this.followings,
      );

  factory UserProfileCount.fromJson(Map<String, dynamic> json) =>
      _$UserProfileCountFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileCountToJson(this);
}
