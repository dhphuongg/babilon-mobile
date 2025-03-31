import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileAvatar extends StatefulWidget {
  final String? avatar;
  const ProfileAvatar({Key? key, this.avatar}) : super(key: key);

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: AppColors.grayF5,
      radius: 50.w,
      backgroundImage: widget.avatar != null && widget.avatar!.isNotEmpty
          ? CachedNetworkImageProvider(widget.avatar!)
          : null,
      child: widget.avatar == null || widget.avatar!.isEmpty
          ? Icon(
              Icons.person,
              size: 50.w,
              color: AppColors.black,
            )
          : null,
    );
  }
}
