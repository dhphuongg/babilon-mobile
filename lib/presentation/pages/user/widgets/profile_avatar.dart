import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatefulWidget {
  final String? avatar;
  final double size;

  const ProfileAvatar({
    Key? key,
    this.avatar,
    this.size = 50,
  }) : super(key: key);

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: AppColors.grayF5,
      radius: widget.size,
      backgroundImage: widget.avatar != null && widget.avatar!.isNotEmpty
          // ? CachedNetworkImageProvider(StringUtils.getImgUrl(widget.avatar!))
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
  }
}
