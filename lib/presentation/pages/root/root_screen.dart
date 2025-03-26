import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/storages/global_storages.dart';
import 'package:babilon/core/domain/utils/check_connection_util.dart';
import 'package:babilon/core/domain/utils/share_preferences.dart';
import 'package:babilon/presentation/routes/route_name.dart';
import 'package:flutter/material.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  initState() {
    // TODO: implement initState
    super.initState();
    _checkInternetConnect();
    _checkToken();
  }

  _checkInternetConnect() async {
    GlobalStorage.hasInternetConnect = await checkInternetConnection();
  }

  Future<void> _checkToken() async {
    final String token = await SharedPreferencesHelper.getStringValue(
        SharedPreferencesHelper.ACCESS_TOKEN);
    try {
      if (token.isNotEmpty) {
        if (mounted) Navigator.popAndPushNamed(context, RouteName.app);
      } else {
        if (mounted) Navigator.popAndPushNamed(context, RouteName.login);
      }
    } catch (e) {
      if (mounted) Navigator.popAndPushNamed(context, RouteName.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Image(
          image: AssetImage('assets/images/logo-image.png'),
        ),
      ),
    );
  }
}
