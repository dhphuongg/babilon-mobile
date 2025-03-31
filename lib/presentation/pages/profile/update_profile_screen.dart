import 'package:babilon/core/application/models/entities/user.entity.dart';
import 'package:babilon/core/application/models/request/user/update_profile.request.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/constants/app_padding.dart';
import 'package:babilon/core/domain/constants/app_text_styles.dart';
import 'package:babilon/presentation/pages/profile/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileScreen extends StatefulWidget {
  final UserEntity user;

  const UpdateProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late UserCubit _cubit;
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _signatureController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<UserCubit>(context);
    _cubit.loadUserProfile();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _fullNameController.dispose();
    _signatureController.dispose();
    _cubit.close();
  }

  Future<void> _updateAvatar() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (!mounted) return;
      await _cubit.updateProfile(
        UpdateProfileRequest(avatar: image.path),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text('Sửa hồ sơ', style: AppStyle.bold18black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
        child: Column(
          children: [
            GestureDetector(
              onTap: _updateAvatar,
              child: CircleAvatar(
                backgroundColor: AppColors.grayF5,
                radius: 50.w,
                backgroundImage: widget.user.avatar != null
                    ? CachedNetworkImageProvider(widget.user.avatar ?? '')
                    : null,
                child: widget.user.avatar == null
                    ? Icon(
                        Icons.person,
                        size: 50.w,
                        color: AppColors.black,
                      )
                    : null,
              ),
            ),
            SizedBox(height: 40.h),
            // username
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ID: ', style: AppStyle.regular16black),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.user.username,
                      style: AppStyle.regular16black,
                    ),
                    SizedBox(width: 5.w),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.gray,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30.h),
            // full name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Họ và tên: ', style: AppStyle.regular16black),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.user.fullName,
                      style: AppStyle.regular16black,
                    ),
                    SizedBox(width: 5.w),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.gray,
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 30.h),
            // signature
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tiểu sử: ', style: AppStyle.regular16black),
                Row(
                  children: [
                    SizedBox(
                      width: 150.w,
                      child: Text(
                        widget.user.signature ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: AppStyle.regular16black,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.gray,
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
