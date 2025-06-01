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
    required this.likedVideos,
  });

  final UserCubit cubit;
  final UserEntity user;
  final List<Video> videos;
  final List<Video> likedVideos;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  late bool isFollowing = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    isFollowing = widget.user.isFollowing;
    _tabController = TabController(
      length: widget.user.isMe ? 2 : 1,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          userId: widget.user.id,
          isLiving: !widget.user.isMe && widget.user.isLiving,
          avatar: widget.user.avatar,
          size: 45.w,
        ),
        const SizedBox(height: 16),
        // User Info Section
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 48.w),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  widget.user.fullName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              width: 48.w,
              child: Align(
                alignment: Alignment.centerLeft,
                child: widget.user.isMe ? _buildEditButton() : null,
              ),
            ),
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
        // Stats Section
        ProfileStats(cubit: widget.cubit, user: widget.user),
        if (!widget.user.isMe)
          SizedBox(
            width: 140.w,
            child: _buildFollowButton(),
          ),
        Text(
          widget.user.signature ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        SizedBox(height: 16.h),

        // Tab Bar (chỉ hiển thị khi có 2 tabs)
        if (widget.user.isMe)
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: const [
              Tab(text: 'Videos'),
              Tab(text: 'Liked'),
            ],
          ),

        // Tab Bar View hoặc Single View
        Expanded(
          child: widget.user.isMe
              ? TabBarView(
                  controller: _tabController,
                  children: [
                    SingleChildScrollView(
                      child: UserVideoList(videos: widget.videos),
                    ),
                    SingleChildScrollView(
                      child: UserVideoList(videos: widget.likedVideos),
                    ),
                  ],
                )
              : SingleChildScrollView(
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
