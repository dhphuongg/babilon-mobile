import 'package:babilon/core/application/common/widgets/app_page_widget.dart';
import 'package:babilon/core/application/models/response/notification/notification.dart'
    as notification_model;
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:babilon/core/domain/enum/notification_type.dart';
import 'package:babilon/presentation/pages/notifications/cubit/notification_cubit.dart';
import 'package:babilon/presentation/pages/notifications/widget/notification_item.dart';
import 'package:babilon/presentation/pages/user/cubit/user_cubit.dart';
import 'package:babilon/presentation/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late NotificationCubit _notificationCubit;
  late UserCubit _userCubit;

  @override
  void initState() {
    _notificationCubit = BlocProvider.of<NotificationCubit>(context);
    _notificationCubit.getNotificationList();
    _userCubit = BlocProvider.of<UserCubit>(context);
    super.initState();
  }

  @override
  void dispose() {
    _notificationCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationCubit, NotificationState>(
      buildWhen: (previous, current) =>
          previous.getNotificationListStatus !=
          current.getNotificationListStatus,
      listenWhen: (previous, current) =>
          previous.getNotificationListStatus !=
          current.getNotificationListStatus,
      listener: (context, state) {
        if (state.getNotificationListStatus == LoadStatus.SUCCESS) {}
      },
      builder: (context, state) {
        return AppPageWidget(
          isLoading: state.getNotificationListStatus == LoadStatus.LOADING,
          appbar: AppBar(
            backgroundColor: AppColors.transparent,
            title: const Text('Thông báo'),
            centerTitle: true,
          ),
          body: ListView.builder(
            itemCount: state.notifications?.length ?? 0,
            itemBuilder: (context, index) {
              final notification = state.notifications![index];
              return NotificationItem(
                notification: notification,
                onTap: () => _handleNotificationTap(notification),
                userCubit: _userCubit,
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _handleNotificationTap(
    notification_model.Notification notification,
  ) async {
    switch (notification.type) {
      case NotificationType.FOLLOW:
        Navigator.pushNamed(
          context,
          RouteName.user,
          arguments: notification.userId,
        );
        break;
      case NotificationType.POST_VIDEO:
        final videos =
            await _userCubit.getListVideoByUserId(notification.userId);
        if (videos != null && videos.isNotEmpty && mounted) {
          Navigator.pushNamed(
            context,
            RouteName.userVideos,
            arguments: {
              'videos': videos
                  .where((video) => video.id == notification.videoId)
                  .toList(),
              'initialVideoIndex': 0,
            },
          );
        }
        break;
      case NotificationType.LIKE_VIDEO:
        final videos =
            await _userCubit.getListVideoByUserId(notification.receiverId);
        if (videos != null && videos.isNotEmpty && mounted) {
          Navigator.pushNamed(
            context,
            RouteName.userVideos,
            arguments: {
              'videos': videos
                  .where((video) => video.id == notification.videoId)
                  .toList(),
              'initialVideoIndex': 0,
            },
          );
        }
        break;
      case NotificationType.COMMENT_VIDEO:
        final videos =
            await _userCubit.getListVideoByUserId(notification.receiverId);
        if (videos != null && videos.isNotEmpty && mounted) {
          Navigator.pushNamed(
            context,
            RouteName.userVideos,
            arguments: {
              'videos': videos
                  .where((video) => video.id == notification.videoId)
                  .toList(),
              'initialVideoIndex': 0,
            },
          );
        }
        break;
      case NotificationType.SHARE_VIDEO:
        if (notification.videoId != null) {
          // Navigate to video detail screen
          // TODO: Add video detail route
        }
        break;
      case NotificationType.SYSTEM:
        // Handle system notifications if needed
        break;
    }
  }
}
