import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/rankings_provider.dart';

class MetricsInfoCard extends ConsumerWidget {
  const MetricsInfoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final department = ref.watch(selectedDepartmentProvider);
    final metric = getDepartmentMetric(department);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF6BD16).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFF6BD16).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 指標標題
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: const Color(0xFFF6BD16),
                ),
                const SizedBox(width: 8),
                Text(
                  '排行指標',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 指標說明
            Text(
              '${metric.label} (單位: ${metric.unit})',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),
            // 獎勵說明
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🏆 獎勵信息',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildRewardTile(
                    context,
                    '1st',
                    '200 碳幣',
                    color: const Color(0xFFF6BD16),
                  ),
                  const SizedBox(height: 6),
                  _buildRewardTile(
                    context,
                    '2nd',
                    '120 碳幣',
                    color: const Color(0xFFB0B7C3),
                  ),
                  const SizedBox(height: 6),
                  _buildRewardTile(
                    context,
                    '3rd',
                    '80 碳幣',
                    color: const Color(0xFFCD7F32),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 獎勵說明磚塊
  Widget _buildRewardTile(
    BuildContext context,
    String rank,
    String reward, {
    required Color color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
            const SizedBox(width: 8),
            Text(
              rank,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Text(
          reward,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
