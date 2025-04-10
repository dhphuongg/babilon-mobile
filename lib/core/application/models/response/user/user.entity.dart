class UserEntity {
  final String id;
  final String username;
  final String fullName;
  final String? avatar;
  final String? signature;
  final int followerCount;
  final int followingCount;
  final bool isMe;
  final bool isFollower;
  final bool isFollowing;

  UserEntity({
    required this.id,
    required this.username,
    required this.fullName,
    this.avatar,
    this.signature,
    this.followerCount = 0,
    this.followingCount = 0,
    this.isMe = false,
    this.isFollower = false,
    this.isFollowing = false,
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
      isMe: json['isMe'] ?? false,
      isFollower: json['isFollower'] ?? false,
      isFollowing: json['isFollowing'] ?? false,
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
      'isMe': isMe,
      'isFollower': isFollower,
      'isFollowing': isFollowing,
    };
  }
}
