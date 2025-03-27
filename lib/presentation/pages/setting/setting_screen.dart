import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
              onTap: () {
                // TODO: Implement logout
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
