class Video {
  String id;
  String title;
  String url;
  String hlsUrl;
  String thumbnail;
  int width;
  int height;
  double duration;
  double size;
  bool commentable;
  DateTime createdAt;
  DateTime updatedAt;
  int likesCount;
  int viewsCount;
  int commentsCount;
  bool isLiked;
  UserInVideo user;

  Video({
    required this.id,
    required this.title,
    required this.url,
    required this.hlsUrl,
    required this.thumbnail,
    required this.width,
    required this.height,
    required this.duration,
    required this.size,
    required this.commentable,
    required this.createdAt,
    required this.updatedAt,
    required this.likesCount,
    required this.viewsCount,
    required this.commentsCount,
    required this.isLiked,
    required this.user,
  });

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        id: json['id'] as String,
        title: json['title'] as String,
        url: json['url'] as String,
        hlsUrl: json['hlsUrl'] as String,
        thumbnail: json['thumbnail'] as String,
        width: json['width'] as int,
        height: json['height'] as int,
        duration: json['duration'] + 0.0,
        size: json['size'] + 0.0,
        commentable: json['commentable'] as bool,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        likesCount: json['likesCount'] as int,
        viewsCount: json['viewsCount'] as int,
        commentsCount: json['commentsCount'] as int,
        isLiked: json['isLiked'] as bool,
        user: UserInVideo.fromJson(json['user'] as Map<String, dynamic>),
      );
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'url': url,
        'hlsUrl': hlsUrl,
        'thumbnail': thumbnail,
        'width': width,
        'height': height,
        'duration': duration,
        'size': size,
        'commentable': commentable,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'likesCount': likesCount,
        'commentsCount': commentsCount,
        'isLiked': isLiked,
        'user': user.toJson(),
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
  bool isLiving;

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
    required this.isLiving,
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
        isLiving: json['isLiving'] as bool,
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
        'isLiving': isLiving,
      };
}
