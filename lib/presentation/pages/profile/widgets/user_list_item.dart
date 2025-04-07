import 'package:babilon/core/application/models/response/user/user_public.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/presentation/pages/profile/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserListItem extends StatefulWidget {
  final UserPublic user;
  final VoidCallback? onFollowTap;

  const UserListItem({
    Key? key,
    required this.user,
    this.onFollowTap,
  }) : super(key: key);

  @override
  State<UserListItem> createState() => _UserListItemState();
}

class _UserListItemState extends State<UserListItem> {
  Widget _buildFollowButton() {
    if (widget.user.isMe) {
      return const SizedBox.shrink();
    } else if (widget.user.isFollowing && widget.user.isFollower) {
      return GestureDetector(
        onTap: widget.onFollowTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.grayF5,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: const Text(
            'Bạn bè',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    } else if (widget.user.isFollowing) {
      return GestureDetector(
        onTap: widget.onFollowTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.grayF5,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: const Text(
            'Đang theo dõi',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: widget.onFollowTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.main,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: const Text(
          'Theo dõi',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          // Avatar
          ProfileAvatar(
            avatar: widget.user.avatar,
            size: 25.w,
          ),
          SizedBox(width: 12.w),
          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.fullName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '@${widget.user.username}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          // Follow button
          _buildFollowButton(),
        ],
      ),
    );
  }
}
