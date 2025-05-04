import 'package:babilon/core/application/models/response/user/user.entity.dart';
import 'package:babilon/core/application/models/response/video/video.dart';
import 'package:babilon/presentation/pages/app/app_screen.dart';
import 'package:babilon/presentation/pages/auth/change_password_screen.dart';
import 'package:babilon/presentation/pages/auth/cubit/auth_cubit.dart';
import 'package:babilon/presentation/pages/auth/register_screen.dart';
import 'package:babilon/presentation/pages/auth/reset_password_screen.dart';
import 'package:babilon/presentation/pages/edit_video/edit_video_screen.dart';
import 'package:babilon/presentation/pages/home/cubit/video_cubit.dart';
import 'package:babilon/presentation/pages/post_video/cubit/post_video_cubit.dart';
import 'package:babilon/presentation/pages/post_video/post_video_screen.dart';
import 'package:babilon/presentation/pages/record_video/record_video_screen.dart';
import 'package:babilon/presentation/pages/user/social_graph_screen.dart';
import 'package:babilon/presentation/pages/root/root_screen.dart';
import 'package:babilon/presentation/pages/setting/setting_screen.dart';
import 'package:babilon/presentation/pages/user/cubit/user_cubit.dart';
import 'package:babilon/presentation/pages/user/update_profile_screen.dart';
import 'package:babilon/presentation/pages/user/user_screen.dart';
import 'package:babilon/presentation/pages/user/user_videos_screen.dart';
import 'package:flutter/material.dart';
import 'package:babilon/di.dart';
import 'package:babilon/presentation/pages/auth/login_screen.dart';
import 'package:babilon/presentation/routes/route_name.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRoutes {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    Widget initialWidget = const RootScreen();
    Widget routeWidget = initialWidget;

    switch (routeSettings.name) {
      case RouteName.rootScreen:
        routeWidget = const RootScreen();
        break;

      // register
      case RouteName.register:
        routeWidget = BlocProvider(
          create: (context) {
            return AuthCubit(authRepository: getIt());
          },
          child: const RegisterScreen(),
        );
        break;

      // login
      case RouteName.login:
        routeWidget = BlocProvider(
          create: (context) {
            return AuthCubit(authRepository: getIt());
          },
          child: const LoginScreen(),
        );
        break;

      // reset password
      case RouteName.resetPassword:
        routeWidget = BlocProvider(
          create: (context) {
            return AuthCubit(authRepository: getIt());
          },
          child: const ResetPasswordScreen(),
        );
        break;

      // change password
      case RouteName.changePassword:
        routeWidget = BlocProvider(
          create: (context) {
            return AuthCubit(authRepository: getIt());
          },
          child: const ChangePasswordScreen(),
        );
        break;

      // setting
      case RouteName.setting:
        routeWidget = MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) {
                return AuthCubit(authRepository: getIt());
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
          child: const SettingScreen(),
        );
        break;

      // update profile
      case RouteName.updateProfile:
        final UserEntity user = routeSettings.arguments as UserEntity;

        routeWidget = BlocProvider(
          create: (context) {
            return UserCubit(
              userRepository: getIt(),
              videoRepository: getIt(),
            );
          },
          child: UpdateProfileScreen(user: user),
        );
        break;

      // social graph
      case RouteName.socialGraph:
        final args = routeSettings.arguments as Map<String, dynamic>;

        final user = args['user'] as UserEntity;
        final initialTabIndex = args['initialTabIndex'] as int;

        routeWidget = BlocProvider(
          create: (context) {
            return UserCubit(
              userRepository: getIt(),
              videoRepository: getIt(),
            );
          },
          child: SocialGraphScreen(
            user: user,
            initialTabIndex: initialTabIndex,
          ),
        );
        break;

      // user
      case RouteName.user:
        final userId = routeSettings.arguments as String;

        routeWidget = MultiBlocProvider(
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
          child: UserScreen(userId: userId),
        );
        break;

      // record video
      case RouteName.recordVideo:
        routeWidget = const RecordVideoScreen();
        break;

      // edit video
      case RouteName.editVideo:
        final args = routeSettings.arguments as Map<String, dynamic>;
        routeWidget = EditVideoScreen(
          videoPath: args['videoPath'],
          maxDuration: args['maxDuration'],
        );
        break;

      // post video
      case RouteName.postVideo:
        final args = routeSettings.arguments as Map<String, dynamic>;
        final videoPath = args['videoPath'] as String;
        routeWidget = BlocProvider(
          create: (context) {
            return PostVideoCubit(videoRepository: getIt());
          },
          child: PostVideoScreen(videoPath: videoPath),
        );
        break;

      case RouteName.app:
        routeWidget = const AppScreen();
        break;

      // user videos
      case RouteName.userVideos:
        final args = routeSettings.arguments as Map<String, dynamic>;
        final videos = args['videos'] as List<Video>;
        final initialVideoIndex = args['initialVideoIndex'] as int? ?? 0;

        routeWidget = MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) {
                return VideoCubit(
                  videoRepository: getIt(),
                );
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
          child: UserVideosScreen(
            videos: videos,
            initialVideoIndex: initialVideoIndex,
          ),
        );
        break;

      default:
        routeWidget;
        break;
    }
    return MaterialPageRoute(
      builder: (_) => routeWidget,
      settings: routeSettings,
    );
  }
}
