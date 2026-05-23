import 'package:eco_sensing_app/features/carbon_actions/presentation/employee/scan_screen/scan_page.dart';
import 'package:flutter/material.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';
import 'emp_dashboard_screen.dart';
import '../../../carbon_actions/presentation/employee/actions_screen/actions_screen.dart';
import '../../../gamification/presentation/employee/leaderboard_screen/emp_leaderboard_screen.dart';
import '../../../user/presentation/employee/profile_screen/emp_profile_screen.dart';

class EmployeeHomePage extends StatefulWidget {
  const EmployeeHomePage({super.key});

  @override
  State<EmployeeHomePage> createState() => _EmployeeHomePageState();
}

class _EmployeeHomePageState extends State<EmployeeHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const IReduceCarbonPage(),
    const ScanPage(),
    const LeaderboardPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart_outline),
              activeIcon: Icon(Icons.pie_chart),
              label: '儀表板',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.eco_outlined),
              activeIcon: Icon(Icons.eco),
              label: 'i減碳',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner_rounded),
              activeIcon: Icon(Icons.qr_code_scanner_rounded),
              label: '掃描',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard_outlined),
              activeIcon: Icon(Icons.leaderboard),
              label: '排行榜',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: '個人',
            ),
          ],
        ),
      ),
    );
  }
}
