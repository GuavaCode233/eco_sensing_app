import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';
import 'package:eco_sensing_app/core/theme/app_decorations.dart';
import 'package:eco_sensing_app/features/gamification/providers/game_config_provider.dart';
import 'package:eco_sensing_app/features/gamification/providers/rankings_provider.dart';
import '../../../../providers/current_user_provider.dart';

/// 4 格綠色系指標卡：等級、EXP（含進度）、碳幣、部門排名
class ProfileStatsGrid extends ConsumerWidget {
  const ProfileStatsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final expPerLevel = ref.watch(expPerLevelProvider);
    final ranking = ref.watch(currentUserRankingProvider);
    final progress = (user.totalExp / expPerLevel).clamp(0.0, 1.0);
    final nextLevel = user.level + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '等級與獎勵',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatTile(
                label: '目前等級',
                value: 'Lv.${user.level}',
                bgColor: AppColors.greenAccent.withValues(alpha: 0.12),
                borderColor: AppColors.greenAccent.withValues(alpha: 0.25),
                valueColor: AppColors.starbucksGreen,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatTile(
                label: '獎勵貨幣',
                value: '${user.tokens}',
                bgColor: AppColors.starbucksGreen.withValues(alpha: 0.1),
                borderColor: AppColors.starbucksGreen.withValues(alpha: 0.22),
                valueColor: AppColors.greenAccent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _ExpStatTile(
                exp: user.totalExp,
                expPerLevel: expPerLevel,
                nextLevel: nextLevel,
                progress: progress,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatTile(
                label: '部門排名',
                value: ranking != null ? '第 ${ranking.rank} 名' : '—',
                bgColor: AppColors.greenLight.withValues(alpha: 0.65),
                borderColor: AppColors.greenAccent.withValues(alpha: 0.2),
                valueColor: AppColors.starbucksGreen,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.bgColor,
    required this.borderColor,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color bgColor;
  final Color borderColor;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDecorations.cardRadius),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpStatTile extends StatelessWidget {
  const _ExpStatTile({
    required this.exp,
    required this.expPerLevel,
    required this.nextLevel,
    required this.progress,
  });

  final int exp;
  final int expPerLevel;
  final int nextLevel;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.greenUplift.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDecorations.cardRadius),
        border: Border.all(color: AppColors.greenUplift.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '經驗值',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$exp',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.starbucksGreen,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDecorations.pillRadius),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.ceramic,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.greenAccent,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$exp / $expPerLevel → Lv.$nextLevel',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.starbucksGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
