import 'package:babilon/core/domain/enum/notification_type.dart';

class Notification {
  final String id;
  final String userId;
  final String receiverId;
  final String title;
  final String body;
  final String? imageUrl;
  final NotificationType type;
  final String? videoId;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;

  Notification({
    required this.id,
    required this.userId,
    required this.receiverId,
    required this.title,
    required this.body,
    required this.imageUrl,
    required this.type,
    required this.videoId,
    required this.isRead,
    required this.readAt,
    required this.createdAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        id: json['id'] as String,
        userId: json['userId'] as String,
        receiverId: json['receiverId'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        imageUrl: json['imageUrl'] as String?,
        type: NotificationType.values.firstWhere(
            (e) => e.toString() == 'NotificationType.${json['type']}'),
        videoId: json['videoId'] as String?,
        isRead: json['isRead'] as bool,
        readAt: json['readAt'] != null ? DateTime.parse(json['readAt']) : null,
        createdAt: DateTime.parse(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'receiverId': receiverId,
        'title': title,
        'body': body,
        'imageUrl': imageUrl,
        'type': type.toString().split('.').last,
        'videoId': videoId,
        'isRead': isRead,
        'readAt': readAt?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
      };
}
