class Video {
  String id;
  String title;
  String url;
  String hlsUrl;
  String thumbnail;
  int duration;
  int width;
  int height;
  bool commentable;
  DateTime createdAt;
  UserInVideo user;
  int likesCount;
  int commentsCount;

  Video({
    required this.id,
    required this.title,
    required this.url,
    required this.hlsUrl,
    required this.thumbnail,
    required this.duration,
    required this.width,
    required this.height,
    required this.commentable,
    required this.createdAt,
    required this.user,
    required this.likesCount,
    required this.commentsCount,
  });

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        id: json['id'] as String,
        title: json['title'] as String,
        url: json['url'] as String,
        hlsUrl: json['hlsUrl'] as String,
        thumbnail: json['thumbnail'] as String,
        duration: json['duration'] as int,
        width: json['width'] as int,
        height: json['height'] as int,
        commentable: json['commentable'] as bool,
        createdAt: DateTime.parse(json['createdAt'] as String),
        user: UserInVideo.fromJson(json['user'] as Map<String, dynamic>),
        likesCount: json['likesCount'] as int,
        commentsCount: json['commentsCount'] as int,
      );
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'url': url,
        'hlsUrl': hlsUrl,
        'thumbnail': thumbnail,
        'duration': duration,
        'width': width,
        'height': height,
        'commentable': commentable,
        'createdAt': createdAt.toIso8601String(),
        'user': user.toJson(),
        'likesCount': likesCount,
        'commentsCount': commentsCount,
      };
}

class UserInVideo {
  String id;
  String username;
  String fullName;
  String? avatar;
  int followerCount;
  int followingCount;
  bool isMe;
  bool isFollower;
  bool isFollowing;

  UserInVideo({
    required this.id,
    required this.username,
    required this.fullName,
    this.avatar,
    required this.followerCount,
    required this.followingCount,
    required this.isMe,
    required this.isFollower,
    required this.isFollowing,
  });

  factory UserInVideo.fromJson(Map<String, dynamic> json) => UserInVideo(
        id: json['id'] as String,
        username: json['username'] as String,
        fullName: json['fullName'] as String,
        avatar: json['avatar'] as String?,
        followerCount: json['followerCount'] as int,
        followingCount: json['followingCount'] as int,
        isMe: json['isMe'] as bool,
        isFollower: json['isFollower'] as bool,
        isFollowing: json['isFollowing'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'fullName': fullName,
        'avatar': avatar,
        'followerCount': followerCount,
        'followingCount': followingCount,
        'isMe': isMe,
        'isFollower': isFollower,
        'isFollowing': isFollowing,
      };
}
