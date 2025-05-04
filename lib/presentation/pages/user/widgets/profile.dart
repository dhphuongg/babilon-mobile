import 'package:babilon/core/application/common/widgets/button/app_button.dart';
import 'package:babilon/core/application/models/response/user/user.entity.dart';
import 'package:babilon/core/application/models/response/video/video.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:babilon/presentation/pages/user/cubit/user_cubit.dart';
import 'package:babilon/presentation/pages/user/widgets/profile_avatar.dart';
import 'package:babilon/presentation/pages/user/widgets/profile_stats.dart';
import 'package:babilon/presentation/pages/user/widgets/user_video_list.dart';
import 'package:babilon/presentation/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Profile extends StatefulWidget {
  const Profile({
    super.key,
    required this.cubit,
    required this.user,
    required this.videos,
  });

  final UserCubit cubit;
  final UserEntity user;
  final List<Video> videos;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    isFollowing = widget.user.isFollowing;
  }

  Future<void> _onFollowTap() async {
    if (widget.cubit.state.followStatus == LoadStatus.LOADING) {
      return;
    }
    if (isFollowing) {
      await widget.cubit.unfollowUserById(widget.user.id);
      setState(() {
        isFollowing = false;
      });
    } else {
      await widget.cubit.followUserById(widget.user.id);
      setState(() {
        isFollowing = true;
      });
    }
  }

  Widget _buildFollowButton() {
    if (isFollowing) {
      return AppButton(
        disable: false,
        text: 'Đã theo dõi',
        onPressed: _onFollowTap,
        color: AppColors.grayF5,
        textStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      );
    }
    return AppButton(
      disable: false,
      text: 'Theo dõi',
      onPressed: _onFollowTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Avatar Section
        ProfileAvatar(
          avatar: widget.user.avatar,
          size: 50.w,
        ),
        const SizedBox(height: 16),
        // User Info Section
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 32.w),
            Expanded(
              child: Text(
                widget.user.fullName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (widget.user.isMe) _buildEditButton(),
            SizedBox(width: 32.w),
          ],
        ),

        // Username
        Text(
          '@${widget.user.username}',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 12),
        // Stats Section
        ProfileStats(cubit: widget.cubit, user: widget.user),
        const SizedBox(height: 16),
        if (!widget.user.isMe)
          SizedBox(
            width: 140.w,
            child: _buildFollowButton(),
          ),
        const SizedBox(height: 12),
        Text(
          widget.user.signature ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: UserVideoList(videos: widget.videos),
          ),
        ),
      ],
    );
  }

  Widget _buildEditButton() {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.pushNamed(
          context,
          RouteName.updateProfile,
          arguments: widget.user,
        );
        if (result == true) {
          await widget.cubit.loadUserProfile();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.grayF5,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Icon(
          Icons.edit_sharp,
          size: 16.w,
        ),
      ),
    );
  }
}
