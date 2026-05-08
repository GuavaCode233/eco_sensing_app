import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/department_selector.dart';
import 'widgets/leaderboard_header.dart';
import 'widgets/metrics_info_card.dart';
import 'widgets/rankings_list.dart';

// 索引 3: 部門內排行榜
class LeaderboardPage extends ConsumerWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          // 頂部漸變背景 - 黃金色
          Container(
            height: 200 + MediaQuery.of(context).padding.top,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF6BD16), Color(0xFFE0A010)], // 黃金漸變
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
                    '部門排行榜',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                // 個人排名卡片
                const LeaderboardHeader(),
                const SizedBox(height: 16),
                // 部門選擇器
                const DepartmentSelector(),
                const SizedBox(height: 16),
                // 指標信息卡片
                const MetricsInfoCard(),
                const SizedBox(height: 16),
                // 排行清單
                const RankingsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
