import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'i_reduce_carbon_page.dart';
import 'leaderboard_page.dart';
import 'profile_page.dart';

// 員工首頁
class EmployeeHomePage extends StatefulWidget {

  const EmployeeHomePage({
    super.key,
  });

  @override
  State<EmployeeHomePage> createState() => _EmployeeHomePageState();
}

class _EmployeeHomePageState extends State<EmployeeHomePage> {
  // 目前的頁面索引
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),  // 索引 0: 主畫面，儀表板
    const IReduceCarbonPage(), // 索引 1: i減碳，減碳活動/任務推薦頁面
    const LeaderboardPage(), // 索引 2: 部門內排行榜
    const ProfilePage(), // 索引 3: 個人頁面，資料維護、系統設定
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
      
      // 底部導覽列
      bottomNavigationBar: BottomNavigationBar(
        // 重要！當按鈕超過 3 個時，必須加上 fixed，否則按鈕會變成白色隱形
        type: BottomNavigationBarType.fixed, 
        
        backgroundColor: Colors.white, // 底部列的背景色
        currentIndex: _selectedIndex, // 告訴導覽列現在是亮哪一顆按鈕
        onTap: _onItemTapped, // 點擊時呼叫上面的方法
        
        // 設定顏色 (對應你的設計圖)
        selectedItemColor: Colors.blueAccent, // 選中時的顏色 (藍色)
        unselectedItemColor: Colors.grey.shade400, // 未選中時的顏色 (灰色)
        
        // 這裡放你的四個按鈕
        items: const[
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