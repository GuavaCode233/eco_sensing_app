import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';
import 'package:eco_sensing_app/core/theme/app_decorations.dart';
import '../../../../models/ranking_entry.dart';
import '../../../../providers/rankings_provider.dart';

/// 個人排名浮動卡（疊在深綠 header 上）
class LeaderboardHeader extends ConsumerWidget {
  const LeaderboardHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserRanking = ref.watch(currentUserRankingProvider);
    final department = ref.watch(selectedDepartmentProvider);
    final rankings = ref.watch(departmentRankingsProvider(department));
    final metric = getDepartmentMetric(department);

    if (currentUserRanking == null) return const SizedBox.shrink();

    final gapToAbove = _gapToPreviousRank(currentUserRanking, rankings);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDecorations.cardRadius),
        boxShadow: AppDecorations.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$department · 你的排名',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '第 ${currentUserRanking.rank} 名',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.starbucksGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (currentUserRanking.medal != null) ...[
                      const SizedBox(height: 6),
                      _MedalBadge(medal: currentUserRanking.medal!),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    metric.label,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Text(
                    '${currentUserRanking.value.toStringAsFixed(1)} ${metric.unit}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.greenAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (gapToAbove != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.greenLight.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '距離第 ${currentUserRanking.rank - 1} 名還差 ${gapToAbove.toStringAsFixed(1)} ${metric.unit}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.starbucksGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  double? _gapToPreviousRank(RankingEntry current, List<RankingEntry> rankings) {
    if (current.rank <= 1) return null;
    final above = rankings.where((e) => e.rank == current.rank - 1);
    if (above.isEmpty) return null;
    return above.first.value - current.value;
  }
}

class _MedalBadge extends StatelessWidget {
  const _MedalBadge({required this.medal});

  final int medal;

  @override
  Widget build(BuildContext context) {
    final colors = {1: AppColors.gold, 2: AppColors.silver, 3: AppColors.bronze};
    final color = colors[medal] ?? AppColors.ceramic;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppDecorations.pillRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.emoji_events, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            'TOP $medal',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
