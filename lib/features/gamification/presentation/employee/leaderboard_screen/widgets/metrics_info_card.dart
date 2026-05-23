import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';
import 'package:eco_sensing_app/core/theme/app_decorations.dart';
import '../../../../providers/rankings_provider.dart';

/// 排行指標 + 獎勵（橫排精簡版）
class MetricsInfoCard extends ConsumerWidget {
  const MetricsInfoCard({super.key});

  static const _rewards = [
    ('1st', '200碳幣', AppColors.gold),
    ('2nd', '120碳幣', AppColors.silver),
    ('3rd', '80碳幣', AppColors.bronze),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final department = ref.watch(selectedDepartmentProvider);
    final metric = getDepartmentMetric(department);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDecorations.cardRadius),
          border: Border.all(color: AppColors.ceramic),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${metric.label} · 單位 ${metric.unit}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    '獎勵：',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  ..._rewards.map(
                    (r) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _RewardBadge(
                        rank: r.$1,
                        reward: r.$2,
                        color: r.$3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RewardBadge extends StatelessWidget {
  const _RewardBadge({
    required this.rank,
    required this.reward,
    required this.color,
  });

  final String rank;
  final String reward;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDecorations.pillRadius),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        '$rank · $reward',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
