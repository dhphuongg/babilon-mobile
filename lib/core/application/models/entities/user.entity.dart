import 'package:babilon/core/application/models/response/user/user_profile.dart';

class UserEntity {
  final String id;
  final String username;
  final String fullName;
  final String? avatar;
  final String? signature;
  final int followerCount;
  final int followingCount;

  UserEntity({
    required this.id,
    required this.username,
    required this.fullName,
    this.avatar,
    this.signature,
    this.followerCount = 0,
    this.followingCount = 0,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      username: json['username'],
      fullName: json['fullName'],
      avatar: json['avatar'],
      signature: json['signature'],
      followerCount: json['followerCount'],
      followingCount: json['followingCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'fullName': fullName,
      'avatar': avatar,
      'signature': signature,
      'followerCount': followerCount,
      'followingCount': followingCount,
    };
  }

  static UserEntity fromUserProfile(UserProfile userProfile) {
    return UserEntity(
      id: userProfile.id,
      username: userProfile.username,
      fullName: userProfile.fullName,
      avatar: userProfile.avatar,
      signature: userProfile.signature,
      followerCount: userProfile.stats.followerCount,
      followingCount: userProfile.stats.followingCount,
    );
  }
}
