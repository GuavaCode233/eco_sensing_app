import 'package:eco_sensing_app/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/current_user_provider.dart';

class DashboardHeader extends ConsumerWidget {
  // 員工儀表板頂部背景與資訊
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(currentUserProvider); // 從 provider 獲取用戶資料

    return Container(
      padding: const EdgeInsets.all(16),
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  // 用戶信息區塊
                  _buildUserInfoCard(context, userProfile: userProfile),
                  const SizedBox(height: 18),

                  _buildExperienceBarCard(context, userProfile: userProfile),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 用戶信息卡片
  Widget _buildUserInfoCard(BuildContext context, {required userProfile}) {
    return Container(
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
                        '王小民', // TODO: 從 userProfile 獲取用戶名
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
                      value: '7', // TODO: 從 userProfile 獲取等級
                      backgroundColor: Colors.amber,
                      context: context,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    child: _buildInfoTile(
                      icon: Icons.eco_outlined,
                      label: '碳幣',
                      value: '1250', // TODO: 從 userProfile 獲取碳幣數量
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

  Widget _buildExperienceBarCard(BuildContext context, {required userProfile}) {
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
          _buildExperienceBar(context, userProfile: userProfile),
        ],
      ),
    );
  }

  Widget _buildExperienceBar(BuildContext context, {required userProfile}) {
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
}
