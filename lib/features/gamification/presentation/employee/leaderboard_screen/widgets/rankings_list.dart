import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';
import 'package:eco_sensing_app/core/theme/app_decorations.dart';
import '../../../../models/ranking_entry.dart';
import '../../../../providers/rankings_provider.dart';

/// 第 4 名起的精簡列表
class RankingsList extends ConsumerWidget {
  const RankingsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final department = ref.watch(selectedDepartmentProvider);
    final rankings = ref.watch(departmentRankingsProvider(department));
    final metric = getDepartmentMetric(department);
    final rest = rankings.where((e) => e.rank > 3).toList();

    if (rest.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: rest.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return _RankingRow(
          ranking: rest[index],
          metric: metric,
        );
      },
    );
  }
}

class _RankingRow extends StatelessWidget {
  const _RankingRow({
    required this.ranking,
    required this.metric,
  });

  final RankingEntry ranking;
  final DepartmentMetric metric;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: AppDecorations.card().copyWith(
        color: ranking.isCurrentUser
            ? AppColors.greenLight.withValues(alpha: 0.45)
            : AppColors.white,
        border: ranking.isCurrentUser
            ? Border.all(color: AppColors.greenAccent.withValues(alpha: 0.35))
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '${ranking.rank}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.greenLight,
            ),
            alignment: Alignment.center,
            child: Text(
              ranking.avatarInitials,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.starbucksGreen,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              ranking.name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            '${ranking.value.toStringAsFixed(1)} ${metric.unit}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.starbucksGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
