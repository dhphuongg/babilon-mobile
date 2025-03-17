import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/presentation/pages/friends/friends_screen.dart';
import 'package:babilon/presentation/pages/home/home_screen.dart';
import 'package:babilon/presentation/pages/notifications/notifications_screen.dart';
import 'package:babilon/presentation/pages/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const FriendsScreen(),
    const Center(), // Placeholder for FAB
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add action here
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home, 'Home'),
            _buildNavItem(1, Icons.people, 'Friends'),
            const SizedBox(width: 48), // Space for FAB
            _buildNavItem(3, Icons.notifications, 'Notifications'),
            _buildNavItem(4, Icons.person, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Center(
          child: Icon(
            icon,
            color: _selectedIndex == index ? AppColors.main : Colors.grey,
          ),
        ),
      ),
    );
  }
}
