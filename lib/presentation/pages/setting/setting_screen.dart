import 'package:babilon/core/application/common/widgets/app_snack_bar.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/presentation/pages/auth/cubit/auth_cubit.dart';
import 'package:babilon/presentation/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late AuthCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<AuthCubit>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _cubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left_rounded,
            size: 32,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Cài đặt'),
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
                // TODO: Navigate to account settings
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
              icon: Icons.logout_rounded,
              title: 'Đăng xuất',
              textColor: Colors.red,
              onTap: () async {
                final bool? confirm = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text(
                      'Đăng xuất',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    content: const Text(
                      'Bạn có chắc chắn muốn đăng xuất không?',
                      style: TextStyle(fontSize: 16),
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
                        child: Text(
                          'Đăng xuất',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await _cubit.logout();
                  if (mounted) {
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
