import 'package:babilon/core/application/repositories/live_repository.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/di.dart';
import 'package:babilon/presentation/pages/live/widgets/live_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatefulWidget {
  final String? userId;
  final bool? isLiving;
  final String? avatar;
  final double size;

  const ProfileAvatar({
    Key? key,
    this.userId,
    this.isLiving,
    this.avatar,
    this.size = 50,
  }) : super(key: key);

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget avatar = CircleAvatar(
      backgroundColor: AppColors.grayF5,
      radius: widget.size,
      backgroundImage: widget.avatar != null && widget.avatar!.isNotEmpty
          ? CachedNetworkImageProvider(widget.avatar!)
          : null,
      child: widget.avatar == null || widget.avatar!.isEmpty
          ? Icon(
              Icons.person,
              size: widget.size * 1.5,
              color: AppColors.black,
            )
          : null,
    );

    if (widget.isLiving == true && widget.userId != null) {
      return GestureDetector(
        onTap: () async {
          print('User ID: ${widget.userId}');
          final liveRepository = getIt<LiveRepository>();
          final response = await liveRepository.getByUserId(widget.userId!);
          // navigate to new screen with live list widget
          if (response.success && response.data != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LiveList(
                  lives: [response.data!],
                  initialIndex: 0,
                ),
              ),
            );
          }
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.red.withOpacity(_controller.value),
                  width: 2,
                ),
              ),
              child: child,
            );
          },
          child: avatar,
        ),
      );
    }

    return avatar;
  }
}
