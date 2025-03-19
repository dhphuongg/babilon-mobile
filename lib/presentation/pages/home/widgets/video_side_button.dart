import 'package:babilon/core/domain/utils/string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideoSideButton extends StatefulWidget {
  const VideoSideButton({super.key});

  @override
  State<VideoSideButton> createState() => _VideoSideButtonState();
}

class _VideoSideButtonState extends State<VideoSideButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeController;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _likeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
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
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              image: const DecorationImage(
                image: NetworkImage('https://picsum.photos/200'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          _buildActionButton(
            icon: _isLiked ? Icons.favorite : Icons.favorite,
            onTap: _handleLikePressed,
            label: StringUtils.formatNumber(123000),
            iconColor: _isLiked ? Colors.red : Colors.white,
            isLikeButton: true,
          ),
          _buildActionButton(
            icon: Icons.comment_rounded,
            onTap: () {},
            label: StringUtils.formatNumber(1234),
          ),
          _buildActionButton(
            icon: Icons.share,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
