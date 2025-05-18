import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:babilon/presentation/pages/user/cubit/user_cubit.dart';
import 'package:babilon/presentation/pages/user/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:babilon/core/application/models/response/notification/notification.dart'
    as notification_model;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationItem extends StatefulWidget {
  final notification_model.Notification notification;
  final VoidCallback onTap;
  final UserCubit userCubit;

  const NotificationItem({
    Key? key,
    required this.notification,
    required this.onTap,
    required this.userCubit,
  }) : super(key: key);

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  @override
  void initState() {
    super.initState();
    widget.userCubit.getUserById(widget.notification.userId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) => {},
      listenWhen: (previous, current) =>
          previous.getUserStatus != current.getUserStatus,
      buildWhen: (previous, current) =>
          previous.getUserStatus != current.getUserStatus,
      builder: (context, state) {
        if (state.getUserStatus != LoadStatus.SUCCESS) {
          // loading
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return GestureDetector(
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // User Avatar
                ProfileAvatar(
                  avatar: state.user!.avatar,
                  size: 30.r,
                ),
                const SizedBox(width: 12),
                // Notification Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.notification.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.notification.body,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.notification.imageUrl != null)
                  SizedBox(
                    height: 70.h,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.notification.imageUrl!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
