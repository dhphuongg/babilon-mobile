import 'dart:io';

import 'package:babilon/core/application/repositories/app_cubit/app_cubit.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/di.dart';
import 'package:babilon/presentation/pages/search/search_screen.dart';
import 'package:babilon/presentation/pages/home/cubit/video_cubit.dart';
import 'package:babilon/presentation/pages/home/home_screen.dart';
import 'package:babilon/presentation/pages/notifications/notifications_screen.dart';
import 'package:babilon/presentation/pages/user/cubit/user_cubit.dart';
import 'package:babilon/presentation/pages/user/profile_screen.dart';
import 'package:babilon/presentation/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  late AppCubit _appCubit;
  final ValueNotifier<int> _currentPageIndex = ValueNotifier<int>(0);
  late PageController pageController;

  final List<Widget> _screens = [
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            return VideoCubit(videoRepository: getIt());
          },
        ),
        BlocProvider(
          create: (context) {
            return UserCubit(
              userRepository: getIt(),
              videoRepository: getIt(),
            );
          },
        ),
      ],
      child: const HomeScreen(),
    ),
    const SearchScreen(),
    // const RecordVideoScreen(), // Placeholder for FAB
    const NotificationsScreen(),
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            return UserCubit(
              userRepository: getIt(),
              videoRepository: getIt(),
            );
          },
        ),
      ],
      child: const ProfileScreen(),
    ),
  ];

  void _onPageChanged() {
    if (_currentPageIndex.value != 0) {
      _appCubit.pauseVideo();
    } else {
      _appCubit.playVideo();
    }
    pageController.jumpToPage(_currentPageIndex.value);
  }

  @override
  void initState() {
    super.initState();

    _appCubit = getIt<AppCubit>();
    pageController = PageController(initialPage: 0);
    _currentPageIndex.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: _screens.map((screen) => screen).toList(),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          top: 10.h,
          bottom: Platform.isIOS ? MediaQuery.of(context).padding.bottom : 10.h,
          // left: 20.w,
          // right: 20.w,
        ),
        decoration: const BoxDecoration(
          // color: AppColors.black,
          border: Border(
            top: BorderSide(
              color: AppColors.grayF5,
              width: 0.3,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildNavItem(0, Icons.home, 'Trang chủ'),
            _buildNavItem(1, Icons.search_outlined, 'Tìm kiếm'),
            Container(
              width: 60.w,
              height: 35.h,
              decoration: BoxDecoration(
                color: AppColors.grayF5,
                borderRadius: BorderRadius.circular(10),
              ),
              child: GestureDetector(
                onTap: () {
                  // _currentPageIndex.value = 2;
                  Navigator.pushNamed(context, RouteName.recordVideo);
                },
                child: const Icon(
                  Icons.add,
                  size: 32,
                  color: AppColors.main,
                ), // Icon ở giữa
              ),
            ),
            _buildNavItem(2, Icons.notifications, 'Thông báo'),
            _buildNavItem(3, Icons.person, 'Hồ sơ'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    return InkWell(
      onTap: () => setState(() => _currentPageIndex.value = index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: _currentPageIndex.value == index
                  ? AppColors.main
                  : AppColors.gray,
            ),
            Text(label,
                style: TextStyle(
                    color: _currentPageIndex.value == index
                        ? AppColors.main
                        : AppColors.gray,
                    fontSize: 10)),
          ]),
    );
  }
}
