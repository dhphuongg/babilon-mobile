import 'package:babilon/core/application/models/response/user/user.entity.dart';
import 'package:babilon/core/domain/enum/user.dart';
import 'package:babilon/presentation/pages/user/cubit/user_cubit.dart';
import 'package:babilon/presentation/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileStats extends StatefulWidget {
  final UserCubit cubit;
  final UserEntity user;

  const ProfileStats({
    super.key,
    required this.cubit,
    required this.user,
  });

  @override
  State<ProfileStats> createState() => _ProfileStatsState();
}

class _ProfileStatsState extends State<ProfileStats> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildProfileStat(SocialGraphType.following),
        Container(
          height: 25.h,
          width: 1,
          color: Colors.grey.withOpacity(0.3),
          margin: const EdgeInsets.symmetric(horizontal: 24),
        ),
        _buildProfileStat(SocialGraphType.followers),
      ],
    );
  }

  Widget _buildProfileStat(SocialGraphType type) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.pushNamed(
          context,
          RouteName.socialGraph,
          arguments: {
            'user': widget.user,
            'initialTabIndex': type == SocialGraphType.following ? 0 : 1,
          },
        );
        if (result == true) {
          await widget.cubit.loadUserProfile();
        }
      },
      child: Column(
        children: [
          Text(
            '${type == SocialGraphType.followers ? widget.user.followerCount : widget.user.followingCount}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            type == SocialGraphType.followers ? 'Follower' : 'Đã follow',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
