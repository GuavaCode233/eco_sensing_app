import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';
import 'package:eco_sensing_app/core/theme/app_decorations.dart';

class RewardCard extends ConsumerWidget {
  const RewardCard({super.key});

  static void show(BuildContext context) {
    showDialog(context: context, builder: (context) => const RewardCard());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Container(
          decoration: AppDecorations.card(),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                _buildHeader(context),
                const SizedBox(height: 24),

                // Monthly Total CO2
                _buildTotalCo2Section(),
                const SizedBox(height: 24),

                // Month-over-month comparison
                _buildComparisonSection(),
                const SizedBox(height: 24),

                // Emissions breakdown
                _buildEmissionsBreakdown(),
                const SizedBox(height: 24),

                // Rewards section
                _buildRewardsSection(),
                const SizedBox(height: 16),

                // Close button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.starbucksGreen,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '確認',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '2025年5月 碳排紀錄',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.close, color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTotalCo2Section() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.greenLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.starbucksGreen.withValues(alpha: 0.2),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            '本月總排碳量',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Text(
                '125.8',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppColors.starbucksGreen,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'kg CO₂e',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.neutralCool,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(
            Icons.trending_down,
            color: AppColors.starbucksGreen,
            size: 24,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '相較上月',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text(
                    '↓ 12.5%',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.starbucksGreen,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.starbucksGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '減少排碳',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.starbucksGreen,
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _buildEmissionsBreakdown() {
    const emissions = [
      {'name': '商務差旅', 'value': 62.4, 'icon': Icons.flight_takeoff},
      {'name': '廢棄物', 'value': 28.1, 'icon': Icons.delete_outline},
      {'name': '電梯搭乘', 'value': 18.6, 'icon': Icons.elevator},
      {'name': '數位能耗', 'value': 16.7, 'icon': Icons.computer},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '碳排紀錄明細',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...emissions.asMap().entries.map((entry) {
          final item = entry.value as Map<String, dynamic>;
          final isLast = entry.key == emissions.length - 1;
          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
            child: _buildEmissionItem(
              icon: item['icon'] as IconData,
              name: item['name'] as String,
              value: item['value'] as double,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildEmissionItem({
    required IconData icon,
    required String name,
    required double value,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.greenLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.starbucksGreen, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '$value kg CO₂e',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.starbucksGreen.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '${(value / 125.8 * 100).toStringAsFixed(1)}%',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.starbucksGreen,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRewardsSection() {
    return Container(
      decoration: AppDecorations.rewardsBand(),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            '本月獲得獎勵',
            style: TextStyle(fontSize: 14, color: AppColors.white),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRewardItem(
                icon: Icons.star_rounded,
                label: '經驗值',
                value: '+450',
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.white.withValues(alpha: 0.2),
              ),
              _buildRewardItem(
                icon: Icons.monetization_on,
                label: '碳幣',
                value: '+85',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRewardItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.white),
        ),
      ],
    );
  }
}
