import 'package:babilon/core/application/models/response/user/user_public.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:babilon/presentation/pages/profile/cubit/user_cubit.dart';
import 'package:babilon/presentation/pages/profile/widgets/profile_avatar.dart';
import 'package:babilon/presentation/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late bool isFollowing = false;
  late bool isFollower = false;
  late UserCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<UserCubit>(context);
    isFollowing = widget.user.isFollowing;
    isFollower = widget.user.isFollower;
  }

  Future<void> _onFollowTap() async {
    if (_cubit.state.followStatus == LoadStatus.LOADING) {
      return;
    }
    if (isFollowing) {
      await _cubit.unfollowUserById(widget.user.id);
      setState(() {
        isFollowing = false;
      });
    } else {
      await _cubit.followUserById(widget.user.id);
      setState(() {
        isFollowing = true;
      });
    }
  }

  Widget _buildFollowButton() {
    if (widget.user.isMe) {
      return const SizedBox.shrink();
    } else if (isFollowing) {
      return GestureDetector(
        onTap: _onFollowTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.grayF5,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            isFollower ? 'Bạn bè' : 'Đã theo dõi',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: _onFollowTap,
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
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteName.user,
          arguments: widget.user.id,
        );
      },
      child: Container(
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
      ),
    );
  }
}
