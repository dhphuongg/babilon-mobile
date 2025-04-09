import 'package:babilon/core/application/models/entities/user.entity.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/presentation/pages/profile/cubit/user_cubit.dart';
import 'package:babilon/presentation/pages/profile/widgets/profile_avatar.dart';
import 'package:babilon/presentation/pages/profile/widgets/profile_stats.dart';
import 'package:babilon/presentation/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Profile extends StatefulWidget {
  const Profile({
    super.key,
    required this.cubit,
    required this.user,
  });

  final UserCubit cubit;
  final UserEntity user;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
            Text(
              widget.user.fullName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
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
        const SizedBox(height: 12),
        Text(
          widget.user.signature ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 12),
        // Stats Section
        ProfileStats(cubit: widget.cubit, user: widget.user),
      ],
    );
  }
}
