import 'package:babilon/presentation/pages/home/home_screen.dart';
import 'package:babilon/presentation/pages/root/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:babilon/di.dart';
import 'package:babilon/presentation/pages/login/cubit/login_cubit.dart';
import 'package:babilon/presentation/pages/login/login_screen.dart';
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
      case RouteName.login:
        // login
        routeWidget = BlocProvider(
            create: (context) {
              return LoginCubit(authRepository: getIt());
            },
            child: const LoginScreen());
        break;
      case RouteName.home:
        routeWidget = const HomeScreen();
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
