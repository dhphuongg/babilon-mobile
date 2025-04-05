import 'package:babilon/core/application/models/response/user/user_profile.dart';

class UserEntity {
  final String id;
  final String username;
  final String fullName;
  final String email;
  final String? avatar;
  final String? signature;
  final int followers;
  final int followings;

  UserEntity({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    this.avatar,
    this.signature,
    this.followers = 0,
    this.followings = 0,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      username: json['username'],
      fullName: json['fullName'],
      email: json['email'],
      avatar: json['avatar'],
      signature: json['signature'],
      followers: json['followers'],
      followings: json['followings'],
    );
  }

  static UserEntity fromUserProfile(UserProfile userProfile) {
    return UserEntity(
      id: userProfile.id,
      username: userProfile.username,
      fullName: userProfile.fullName,
      email: userProfile.email,
      avatar: userProfile.avatar,
      signature: userProfile.signature,
      followers: userProfile.count.followers,
      followings: userProfile.count.followings,
    );
  }
}
