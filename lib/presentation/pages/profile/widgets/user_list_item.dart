import 'package:babilon/core/application/models/response/user/user_public.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/presentation/pages/profile/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserListItem extends StatefulWidget {
  final UserPublic user;
  final bool isFollowing;
  final VoidCallback? onFollowTap;

  const UserListItem({
    Key? key,
    required this.user,
    this.isFollowing = false,
    this.onFollowTap,
  }) : super(key: key);

  @override
  State<UserListItem> createState() => _UserListItemState();
}

class _UserListItemState extends State<UserListItem> {
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
          GestureDetector(
            onTap: widget.onFollowTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: widget.isFollowing ? AppColors.grayF5 : AppColors.main,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                widget.isFollowing ? 'Đang theo dõi' : 'Theo dõi',
                style: TextStyle(
                  color: widget.isFollowing ? Colors.black : Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
