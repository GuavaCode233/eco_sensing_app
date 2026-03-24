import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../screens/auth/login_screen.dart'; // 引入登入頁面，登出後會導航回這裡
import '../../providers/current_user_provider.dart';

class DashboardPage extends ConsumerWidget {
  // 模擬用戶數據
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(currentUserProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // 頂部漸變背景
            Container(
              height: 200 + MediaQuery.of(context).padding.top,
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
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 用戶信息區塊
                    _buildUserInfoCard(),
                    const SizedBox(height: 18),

                    _buildExperienceBarCard(),
                    const SizedBox(height: 18),
                    // 碳排數據卡片
                    _buildCarbonEmissionCard(),
                    const SizedBox(height: 18),

                    // 登出按鈕
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(
                            color: Color(0xFF5B8FF9),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          '登出',
                          style: TextStyle(
                            color: Color(0xFF5B8FF9),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 用戶信息卡片
  Widget _buildUserInfoCard(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   color: Theme.of(context).colorScheme.surface,
      //   borderRadius: BorderRadius.circular(20),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withValues(alpha: 0.1),
      //       blurRadius: 20,
      //       offset: const Offset(0, 10),
      //     ),
      //   ],
      // ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 用戶名、等級和碳幣信息
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 28,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '歡迎,',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        userName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: _buildInfoTile(
                      icon: Icons.star,
                      label: 'Lv.',
                      value: userProfile.level,
                      backgroundColor: Colors.amber,
                      context: context,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    child: _buildInfoTile(
                      icon: Icons.eco_outlined,
                      label: '碳幣',
                      value: '$tokens',
                      backgroundColor: Colors.green,
                      context: context,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 信息磚塊
  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color backgroundColor,
    required BuildContext context,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: backgroundColor.withValues(alpha: 0.7)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: backgroundColor, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: backgroundColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceBarCard(BuildContext context) {
    // 經驗值進度卡
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '⚡ 經驗值',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildExperienceBar(context),
        ],
      ),
    );
  }

  Widget _buildExperienceBar(BuildContext context) {
    // 經驗值進度條
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(4),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: FractionallySizedBox(
          alignment: Alignment.topLeft,
          widthFactor: 0.7, // The progress value (e.g., 0.7 for 70%)
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Colors.blue,
                  Color.fromARGB(255, 142, 221, 252),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCarbonEmissionCard(BuildContext context) {
    // 碳排數據卡片（圓餅圖）
    final double travelEmission = 45.5;
    final double wasteEmission = 12.3;
    final double totalEmission = travelEmission + wasteEmission;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '月度碳排組成',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // 圓餅圖
          Center(
            child: SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: Colors.blue.shade400,
                      value: travelEmission,
                      title:
                          '${(travelEmission / totalEmission * 100).toStringAsFixed(1)}%',
                      radius: 80,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      color: Colors.green.shade400,
                      value: wasteEmission,
                      title:
                          '${(wasteEmission / totalEmission * 100).toStringAsFixed(1)}%',
                      radius: 80,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                  centerSpaceRadius: 0,
                  sectionsSpace: 3,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 圖例和數據
          Row(
            children: [
              Expanded(
                child: _buildEmissionLegend(
                  label: '差旅',
                  value: '${travelEmission.toStringAsFixed(1)} kg',
                  color: Colors.blue.shade400,
                  context: context,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildEmissionLegend(
                  label: '廢棄物',
                  value: '${wasteEmission.toStringAsFixed(1)} kg',
                  color: Colors.green.shade400,
                  context: context,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 總計
          Container(
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '本月總碳排量',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${totalEmission.toStringAsFixed(1)} kg',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmissionLegend({
    // 碳排圖例
    required String label,
    required String value,
    required Color color,
    required BuildContext context,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
