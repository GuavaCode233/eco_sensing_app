import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';
import 'package:eco_sensing_app/core/theme/app_decorations.dart';
import 'package:eco_sensing_app/features/carbon_actions/models/action_task.dart';
import 'package:eco_sensing_app/features/carbon_actions/providers/action_tasks_provider.dart';

class ActionTaskCard extends ConsumerWidget {
  const ActionTaskCard({
    super.key,
    required this.task,
    this.onInfoPressed,
    this.onTaskPressed,
  });

  final ActionTask task;
  final VoidCallback? onInfoPressed;
  final VoidCallback? onTaskPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedIds = ref.watch(completedActionTasksProvider);
    final todayCompleted = ref.watch(todayCompletedActionTasksProvider);
    final isCompleted = completedIds.contains(task.id);
    final isTodayCompleted = todayCompleted.contains(task.id);

    return Opacity(
      opacity: isCompleted ? 0.72 : 1,
      child: Container(
        decoration: AppDecorations.card().copyWith(
          color: isCompleted ? AppColors.neutralCool : AppColors.white,
          border: Border.all(
            color: isCompleted
                ? AppColors.greenAccent.withValues(alpha: 0.35)
                : task.isNavigable
                ? AppColors.greenAccent.withValues(alpha: 0.25)
                : AppColors.ceramic,
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? AppColors.greenLight
                              : task.isNavigable
                              ? AppColors.greenLight
                              : AppColors.neutralCool,
                          borderRadius: BorderRadius.circular(
                            AppDecorations.cardRadius,
                          ),
                        ),
                        child: Icon(
                          _getIconData(task.icon),
                          size: 28,
                          color: isCompleted
                              ? AppColors.starbucksGreen
                              : task.isNavigable
                              ? AppColors.greenAccent
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    task.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                if (isCompleted)
                                  _CompletionBadge(
                                    label: isTodayCompleted
                                        ? '今日已完成'
                                        : '已完成',
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              task.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onInfoPressed,
                  icon: const Icon(Icons.info_outline),
                  iconSize: 20,
                  color: AppColors.textSecondary,
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildRewardChip(
                    context,
                    icon: Icons.local_fire_department,
                    label: 'EXP',
                    value: '${task.exp}',
                    color: AppColors.gold,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildRewardChip(
                    context,
                    icon: Icons.monetization_on,
                    label: 'Coins',
                    value: '${task.coins}',
                    color: AppColors.greenAccent,
                  ),
                ),
              ],
            ),
            if (isCompleted) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: AppColors.greenAccent,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isTodayCompleted ? '今日減碳成果已記錄' : '本月成果已計入',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.greenAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ] else if (task.isNavigable) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onTaskPressed,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDecorations.pillRadius,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_forward, size: 18),
                      SizedBox(width: 8),
                      Text(
                        '進行任務',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.neutralCool,
                  borderRadius: BorderRadius.circular(AppDecorations.cardRadius),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Icon(Icons.build, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '功能開發中',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRewardChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    final iconMap = {
      'flight_takeoff': Icons.flight_takeoff,
      'elevator': Icons.elevator,
      'delete_outline': Icons.delete_outline,
      'restaurant': Icons.restaurant,
      'description': Icons.description,
      'directions_bus': Icons.directions_bus,
      'two_wheeler': Icons.two_wheeler,
      'directions_car': Icons.directions_car_outlined,
      'directions_walk': Icons.directions_walk,
      'recycling': Icons.recycling,
      'local_drink': Icons.local_drink,
      'shopping_bag': Icons.shopping_bag,
      'lightbulb': Icons.lightbulb,
      'ac_unit': Icons.ac_unit,
    };
    return iconMap[iconName] ?? Icons.task;
  }
}

class _CompletionBadge extends StatelessWidget {
  const _CompletionBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.greenAccent,
        borderRadius: BorderRadius.circular(AppDecorations.pillRadius),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
