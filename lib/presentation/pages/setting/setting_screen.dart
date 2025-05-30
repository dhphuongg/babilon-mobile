import 'package:babilon/core/application/common/widgets/app_snack_bar.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/constants/app_text_styles.dart';
import 'package:babilon/presentation/pages/auth/cubit/auth_cubit.dart';
import 'package:babilon/presentation/pages/user/cubit/user_cubit.dart';
import 'package:babilon/presentation/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late AuthCubit _autCubit;
  late UserCubit _userCubit;

  @override
  void initState() {
    super.initState();
    _autCubit = BlocProvider.of<AuthCubit>(context);
    _userCubit = BlocProvider.of<UserCubit>(context);
    _userCubit.loadUserProfile();
  }

  @override
  void dispose() {
    super.dispose();
    _autCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text('Cài đặt', style: AppStyle.bold18black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            _buildSettingItem(
              icon: Icons.person_outline,
              title: 'Tài khoản',
              onTap: () {
                // TODO: Account settings
              },
            ),
            _buildSettingItem(
              icon: Icons.share_outlined,
              title: 'Chia sẻ',
              onTap: () {
                // TODO: Share app
              },
            ),
            _buildSettingItem(
              icon: Icons.lock_outline,
              title: 'Đổi mật khẩu',
              onTap: () {
                Navigator.pushNamed(context, RouteName.changePassword);
              },
            ),
            _buildSettingItem(
              icon: Icons.logout_rounded,
              title: 'Đăng xuất',
              textColor: Colors.red,
              onTap: () async {
                final bool? confirm = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    backgroundColor: AppColors.white,
                    title: const Text('Đăng xuất'),
                    content: const Text(
                      'Bạn có chắc chắn muốn đăng xuất không?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text(
                          'Hủy',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text(
                          'Đăng xuất',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await _autCubit.logout();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RouteName.login,
                      (route) => false,
                    );
                  }
                  AppSnackBar.showSuccess('Đăng xuất thành công');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? AppColors.black,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: textColor ?? AppColors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: textColor ?? AppColors.black,
      ),
      onTap: onTap,
    );
  }
}
