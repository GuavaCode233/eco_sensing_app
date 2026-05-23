import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';
import 'package:eco_sensing_app/core/theme/app_decorations.dart';
import '../../../providers/action_tasks_provider.dart';
import 'widgets/action_category_selector.dart';
import 'widgets/action_task_card.dart';
import 'widgets/action_task_stats_card.dart';

/// 索引 1: i減碳，減碳活動/任務推薦頁面
class IReduceCarbonPage extends ConsumerWidget {
  const IReduceCarbonPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(filteredActionTasksProvider);

    return Scaffold(
      backgroundColor: AppColors.neutralWarm,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: MediaQuery.of(context).padding.top + 20,
              bottom: 40,
            ),
            decoration: AppDecorations.featureBand(),
            child: Text(
              'i減碳',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -24),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ActionTaskStatsCard(),
            ),
          ),
          const SizedBox(height: 4),
          const ActionCategorySelector(),
          const SizedBox(height: 12),
          Expanded(
            child: tasks.isEmpty
                ? _EmptyCategoryHint()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ActionTaskCard(
                          task: task,
                          onInfoPressed: () {
                            _showTaskExplanation(context, task);
                          },
                          onTaskPressed: () {
                            _handleTaskAction(context, task);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showTaskExplanation(BuildContext context, dynamic task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.greenLight,
                  borderRadius: BorderRadius.circular(AppDecorations.cardRadius),
                ),
                child: Icon(
                  _getIconData(task.icon),
                  color: AppColors.greenAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  task.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.explanation,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.greenLight,
                  borderRadius: BorderRadius.circular(AppDecorations.cardRadius),
                  border: Border.all(
                    color: AppColors.greenAccent.withValues(alpha: 0.2),
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _RewardColumn(
                      icon: Icons.local_fire_department,
                      label: '經驗值',
                      value: '${task.exp}',
                      color: AppColors.gold,
                    ),
                    _RewardColumn(
                      icon: Icons.monetization_on,
                      label: '遊戲幣',
                      value: '${task.coins}',
                      color: AppColors.greenAccent,
                    ),
                    _RewardColumn(
                      icon: Icons.eco_outlined,
                      label: 'CO₂',
                      value: '${task.co2ReductionKg} kg',
                      color: AppColors.starbucksGreen,
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('關閉'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDecorations.cardRadius),
          ),
        );
      },
    );
  }

  void _handleTaskAction(BuildContext context, dynamic task) {
    if (!task.isNavigable) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('此功能正在開發中，敬請期待')));
      return;
    }

    if (task.navigationRoute == '/scan') {
      Navigator.pushNamed(
        context,
        '/scan',
        arguments: {'taskTitle': task.title, 'taskId': task.id},
      );
    }
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

class _RewardColumn extends StatelessWidget {
  const _RewardColumn({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _EmptyCategoryHint extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(selectedActionTaskCategoryProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: AppColors.textSecondary),
            const SizedBox(height: 12),
            Text(
              '此類別暫無任務',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (category != null) ...[
              const SizedBox(height: 4),
              Text(
                '「$category」相關任務即將推出',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
