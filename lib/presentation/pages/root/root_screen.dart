import 'package:babilon/core/application/models/response/user/user_profile.dart';
import 'package:babilon/core/application/repositories/app_cubit/app_cubit.dart';
import 'package:babilon/core/domain/storages/global_storages.dart';
import 'package:babilon/core/domain/utils/check_connection_util.dart';
import 'package:babilon/core/domain/utils/share_preferrences.dart';
import 'package:babilon/di.dart';
import 'package:babilon/presentation/routes/route_name.dart';
import 'package:flutter/material.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late AppCubit _appCubit;
  @override
  initState() {
    // TODO: implement initState
    super.initState();
    _appCubit = getIt<AppCubit>();
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
        _appCubit.saveUserProfile(UserProfile(
          userId: int.parse(await SharedPreferencesHelper.getStringValue(
              SharedPreferencesHelper.USER_ID)),
          companyName: await SharedPreferencesHelper.getStringValue(
              SharedPreferencesHelper.COMPANY_NAME),
          projectId: int.parse(await SharedPreferencesHelper.getStringValue(
              SharedPreferencesHelper.PROJECT_ID)),
          prospectId: int.parse(await SharedPreferencesHelper.getStringValue(
              SharedPreferencesHelper.PROSPECT_ID)),
          firstName: await SharedPreferencesHelper.getStringValue(
              SharedPreferencesHelper.FIRST_NAME),
          lastName: await SharedPreferencesHelper.getStringValue(
              SharedPreferencesHelper.LAST_NAME),
        ));
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
      body: Center(
        child: Image(
          image: AssetImage('assets/images/logo.png'),
        ),
      ),
    );
  }
}
