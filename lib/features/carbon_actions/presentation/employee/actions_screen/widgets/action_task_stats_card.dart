import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';
import 'package:eco_sensing_app/core/theme/app_decorations.dart';
import 'package:eco_sensing_app/core/widgets/app_card.dart';
import 'package:eco_sensing_app/features/carbon_actions/providers/action_tasks_provider.dart';

class ActionTaskStatsCard extends ConsumerWidget {
  const ActionTaskStatsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(actionTaskStatsProvider);
    final goalProgress = ref.watch(monthlyCo2GoalProgressProvider);
    final percent = (goalProgress.progress * 100).round();

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  label: '已完成',
                  value: '${stats.completedCount}',
                  icon: Icons.check_circle_outline,
                  color: AppColors.greenAccent,
                ),
              ),
              _divider(),
              Expanded(
                child: _StatItem(
                  label: 'EXP 獲得',
                  value: '${stats.totalExp}',
                  icon: Icons.local_fire_department_outlined,
                  color: AppColors.gold,
                ),
              ),
              _divider(),
              Expanded(
                child: _StatItem(
                  label: 'kg CO₂ 減少',
                  value: stats.totalCo2Kg.toStringAsFixed(1),
                  icon: Icons.eco_outlined,
                  color: AppColors.starbucksGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.ceramic),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '本月減碳目標',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${goalProgress.currentKg.toStringAsFixed(0)} / ${goalProgress.goalKg.toInt()} kg',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.starbucksGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDecorations.pillRadius),
            child: LinearProgressIndicator(
              value: goalProgress.progress,
              minHeight: 8,
              backgroundColor: AppColors.ceramic,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.greenAccent,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '已達成 $percent%，還差 ${goalProgress.remainingKg.toStringAsFixed(0)} kg',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 44,
      color: AppColors.ceramic,
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}
