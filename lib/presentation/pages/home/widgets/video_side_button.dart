import 'package:babilon/core/application/common/widgets/app_snack_bar.dart';
import 'package:babilon/core/application/models/response/video/video.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:babilon/core/domain/utils/string.dart';
import 'package:babilon/presentation/pages/user/cubit/user_cubit.dart';
import 'package:babilon/presentation/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideoSideButton extends StatefulWidget {
  final Video video;
  const VideoSideButton({super.key, required this.video});

  @override
  State<VideoSideButton> createState() => _VideoSideButtonState();
}

class _VideoSideButtonState extends State<VideoSideButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeController;
  bool _isLiked = false;

  late UserCubit _userCubit;
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _userCubit = BlocProvider.of<UserCubit>(context);
    _likeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _isFollowing = !widget.video.user.isMe && widget.video.user.isFollowing;
  }

  void _handleLikePressed() async {
    setState(() => _isLiked = !_isLiked);
    if (_isLiked) {
      _likeController.forward(from: 0.0);
      await Future.delayed(const Duration(milliseconds: 100));
      _likeController.reverse();
    }
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    String? label,
    Color? iconColor,
    bool isLikeButton = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: ScaleTransition(
              scale: isLikeButton
                  ? Tween<double>(begin: 1.0, end: 1.5).animate(
                      CurvedAnimation(
                        parent: _likeController,
                        curve: Curves.easeInOut,
                      ),
                    )
                  : const AlwaysStoppedAnimation(1.0),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: 0.0,
                  end: isLikeButton && _isLiked ? 1.0 : 0.0,
                ),
                duration: const Duration(milliseconds: 200),
                builder: (context, value, child) {
                  return Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.3),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor ?? Colors.white,
                      size: 25.w,
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label ?? '',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _likeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20.h,
      right: 10.w,
      child: Column(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            margin: EdgeInsets.only(bottom: 20.h),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      RouteName.user,
                      arguments: widget.video.user.id,
                    );
                    if (result == true) {
                      await _userCubit.getUserById(widget.video.user.id);
                      _isFollowing = !_userCubit.state.user!.isMe &&
                          _userCubit.state.user!.isFollowing;
                      setState(() {});
                    }
                  },
                  child: Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      image: DecorationImage(
                        image: NetworkImage(
                          widget.video.user.avatar ??
                              'https://picsum.photos/200',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                BlocConsumer<UserCubit, UserState>(
                  listenWhen: (previous, current) =>
                      previous.followStatus != current.followStatus,
                  buildWhen: (previous, current) =>
                      previous.followStatus != current.followStatus,
                  listener: (context, state) {
                    if (state.followStatus == LoadStatus.SUCCESS) {
                      // Handle success
                      AppSnackBar.showSuccess('Followed successfully');
                      _isFollowing = true;
                    }
                  },
                  builder: (context, state) {
                    return !_isFollowing
                        ? Positioned(
                            bottom: -10.h,
                            left: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                _userCubit.followUserById(widget.video.user.id);
                              },
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 20.w,
                                  height: 20.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.pink,
                                    border: Border.all(
                                        color: Colors.white, width: 1.5),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 16.w,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
          _buildActionButton(
            icon: _isLiked ? Icons.favorite : Icons.favorite,
            onTap: _handleLikePressed,
            label: StringUtils.formatNumber(widget.video.likesCount),
            iconColor: _isLiked ? Colors.red : Colors.white,
            isLikeButton: true,
          ),
          _buildActionButton(
            icon: Icons.comment_rounded,
            onTap: () {},
          ),
          // _buildActionButton(
          //   icon: Icons.share,
          //   onTap: () {},
          // ),
          SizedBox(height: 75.h)
        ],
      ),
    );
  }
}
