import 'package:babilon/core/application/common/widgets/app_page_widget.dart';
import 'package:babilon/core/application/common/widgets/app_snack_bar.dart';
import 'package:babilon/core/application/models/entities/user.entity.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:babilon/core/domain/enum/user.dart';
import 'package:babilon/presentation/pages/profile/cubit/user_cubit.dart';
import 'package:babilon/presentation/pages/profile/widgets/profile_avatar.dart';
import 'package:babilon/presentation/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<UserCubit>(context);
    _cubit.loadUserProfile();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      buildWhen: (previous, current) =>
          previous.getProfileStatus != current.getProfileStatus,
      listenWhen: (previous, current) =>
          previous.getProfileStatus != current.getProfileStatus,
      listener: (context, state) {
        if (state.getProfileStatus == LoadStatus.FAILURE) {
          AppSnackBar.showError(state.error!);
        }
      },
      builder: (context, state) {
        return AppPageWidget(
          isLoading: state.getProfileStatus == LoadStatus.LOADING,
          appbar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.setting);
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: state.user != null
                  ? <Widget>[
                      // Avatar Section
                      ProfileAvatar(
                        avatar: state.user!.avatar,
                        size: 50.w,
                      ),
                      const SizedBox(height: 16),

                      // User Info Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.user!.fullName,
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
                                arguments: state.user,
                              );
                              if (result == true) {
                                await _cubit.loadUserProfile();
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
                        '@${state.user!.username}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.user!.signature ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Stats Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildStatColumn(
                            state.user!,
                            'Đã theo dõi',
                            state.user!.followingCount.toString(),
                            SocialGraphType.following,
                          ),
                          Container(
                            height: 25.h,
                            width: 1,
                            color: Colors.grey.withOpacity(0.3),
                            margin: const EdgeInsets.symmetric(horizontal: 24),
                          ),
                          _buildStatColumn(
                            state.user!,
                            'Người theo dõi',
                            state.user!.followerCount.toString(),
                            SocialGraphType.followers,
                          ),
                        ],
                      ),
                    ]
                  : [],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatColumn(
      UserEntity user, String label, String count, SocialGraphType type) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RouteName.socialGraph, arguments: {
          'user': user,
          'initialTabIndex': type == SocialGraphType.following ? 0 : 1,
        });
      },
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
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
