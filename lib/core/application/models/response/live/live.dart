import 'package:babilon/core/application/models/response/video/video.dart';

class Live {
  final String id;
  final String title;
  final bool commentable;
  final String createdAt;
  final UserInVideo user;

  Live({
    required this.id,
    required this.title,
    required this.commentable,
    required this.createdAt,
    required this.user,
  });

  factory Live.fromJson(Map<String, dynamic> json) => Live(
        id: json['id'] as String,
        title: json['title'] as String,
        commentable: json['commentable'] as bool,
        createdAt: json['createdAt'] as String,
        user: UserInVideo.fromJson(json['user'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'commentable': commentable,
        'createdAt': createdAt,
        'user': user.toJson(),
      };
}
