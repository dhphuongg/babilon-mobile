import 'package:babilon/presentation/pages/app/app_screen.dart';
import 'package:babilon/presentation/pages/auth/change_password_screen.dart';
import 'package:babilon/presentation/pages/auth/cubit/auth_cubit.dart';
import 'package:babilon/presentation/pages/auth/register_screen.dart';
import 'package:babilon/presentation/pages/auth/reset_password_screen.dart';
import 'package:babilon/presentation/pages/root/root_screen.dart';
import 'package:babilon/presentation/pages/setting/setting_screen.dart';
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
        routeWidget = BlocProvider(
          create: (context) {
            return AuthCubit(authRepository: getIt());
          },
          child: const SettingScreen(),
        );
        break;

      case RouteName.app:
        routeWidget = const AppScreen();
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
