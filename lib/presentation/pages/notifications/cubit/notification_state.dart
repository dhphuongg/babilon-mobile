part of 'notification_cubit.dart';

class NotificationState extends Equatable {
  final List<Notification>? notifications;
  final String? error;
  final LoadStatus? getNotificationListStatus;

  const NotificationState({
    this.notifications,
    this.error,
    this.getNotificationListStatus,
  });

  NotificationState copyWith({
    List<Notification>? notifications,
    String? error,
    LoadStatus? getNotificationListStatus,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      error: error ?? this.error,
      getNotificationListStatus:
          getNotificationListStatus ?? this.getNotificationListStatus,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        notifications,
        error,
        getNotificationListStatus,
      ];
}
