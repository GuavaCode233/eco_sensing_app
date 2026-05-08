import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/achievements_tab.dart';
import 'widgets/profile_info_tab.dart';
import 'widgets/settings_tab.dart';

// 索引 4: 個人頁面，資料維護、系統設定
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 頂部漸變背景 - 藍色
          Container(
            height: 240 + MediaQuery.of(context).padding.top,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF5B8FF9), Color(0xFF4A7FD9)],
              ),
            ),
          ),
          // 頁面內容
          SafeArea(
            child: Column(
              children: [
                // 頁面標題
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '個人中心',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Tab 頭部
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: const Color(0xFF5B8FF9),
                      unselectedLabelColor: Colors.grey[600],
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      indicator: BoxDecoration(
                        color: const Color(0xFF5B8FF9).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.person),
                              const SizedBox(width: 6),
                              const Text('資料'),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.emoji_events),
                              const SizedBox(width: 6),
                              const Text('成就'),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.settings),
                              const SizedBox(width: 6),
                              const Text('設定'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Tab 內容
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      // 資料標籤
                      ProfileInfoTab(),
                      // 成就標籤
                      AchievementsTab(),
                      // 設定標籤
                      SettingsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
