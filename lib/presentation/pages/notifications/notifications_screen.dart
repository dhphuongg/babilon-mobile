import 'package:babilon/core/application/common/widgets/app_page_widget.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:babilon/core/domain/enum/notification_type.dart';
import 'package:babilon/presentation/pages/notifications/cubit/notification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late NotificationCubit _notificationCubit;
  @override
  void initState() {
    _notificationCubit = BlocProvider.of<NotificationCubit>(context);
    _notificationCubit.getNotificationList();
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
              return ListTile(
                title: Text(notification.title),
                subtitle: Text(notification.body),
              );
            },
          ),
        );
      },
    );
  }
}
