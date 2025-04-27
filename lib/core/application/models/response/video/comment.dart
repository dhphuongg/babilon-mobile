import 'package:babilon/core/application/models/response/video/video.dart';

class Comment {
  String id;
  String comment;
  DateTime createdAt;
  UserInVideo user;

  Comment({
    required this.id,
    required this.comment,
    required this.createdAt,
    required this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json['id'] as String,
        comment: json['comment'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        user: UserInVideo.fromJson(json['user'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'comment': comment,
        'createdAt': createdAt.toIso8601String(),
        'user': user.toJson(),
      };
}
