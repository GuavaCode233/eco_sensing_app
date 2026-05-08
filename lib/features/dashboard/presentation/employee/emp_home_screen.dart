import 'package:eco_sensing_app/features/carbon_actions/presentation/employee/scan_screen/scan_page.dart';
import 'package:flutter/material.dart';

import 'emp_dashboard_screen.dart';
import '../../../carbon_actions/presentation/employee/actions_screen/actions_screen.dart';
import '../../../gamification/presentation/employee/leaderboard_screen/emp_leaderboard_screen.dart';
import '../../../user/presentation/employee/profile_screen/emp_profile_screen.dart';

// 員工首頁
class EmployeeHomePage extends StatefulWidget {
  const EmployeeHomePage({super.key});

  @override
  State<EmployeeHomePage> createState() => _EmployeeHomePageState();
}

class _EmployeeHomePageState extends State<EmployeeHomePage> {
  // 目前的頁面索引
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(), // 索引 0: 主畫面，儀表板
    const IReduceCarbonPage(), // 索引 1: i減碳，減碳活動/任務推薦頁面
    const ScanPage(), // 索引 2: 掃描頁面
    const LeaderboardPage(), // 索引 3: 部門內排行榜
    const ProfilePage(), // 索引 4: 個人頁面，資料維護、系統設定
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // 更新選中的頁面索引
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body 根據目前的 _selectedIndex，從清單中拿出對應的頁面來顯示
      body: _pages[_selectedIndex],

      // 底部導覽列 - TanAI 設計風格
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFFAFAFC),
        elevation: 2,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF5B8FF9), // 主藍色
        unselectedItemColor: const Color(0xFFB0B7C3), // 淺灰色
        // 這裡放你的五個按鈕
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline), // 儀表板圖示
            activeIcon: Icon(Icons.pie_chart), // 選中時變成實心圖示
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
    );
  }
}
