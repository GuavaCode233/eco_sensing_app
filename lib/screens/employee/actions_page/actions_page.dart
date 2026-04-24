import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/action_tasks_provider.dart';
import 'action_task_card.dart';

// 索引 1: i減碳，減碳活動/任務推薦頁面
class IReduceCarbonPage extends ConsumerWidget {
  const IReduceCarbonPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(availableActionTasksProvider);

    return Scaffold(
      body: Stack(
        children: [
          // 頂部漸變背景
          Container(
            height: 200 + MediaQuery.of(context).padding.top,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3DBF8A), Color(0xFF1A9E6A)], // 綠色漸變
              ),
            ),
          ),
          // 頁面內容
          SafeArea(
            child: Column(
              children: [
                // 頁面標題
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'i減碳',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                // 任務列表
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        ...tasks.map(
                          (task) => Padding(
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
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
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
                  color: const Color(0xFF3DBF8A).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIconData(task.icon),
                  color: const Color(0xFF3DBF8A),
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
              // 獎勵信息
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF3DBF8A).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF3DBF8A).withValues(alpha: 0.2),
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          color: const Color(0xFFF6BD16),
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '經驗值',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${task.exp}',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFF6BD16),
                              ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(
                          Icons.monetization_on,
                          color: const Color(0xFF3DBF8A),
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '遊戲幣',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${task.coins}',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF3DBF8A),
                              ),
                        ),
                      ],
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
            borderRadius: BorderRadius.circular(14),
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

    // 路由導航至 scan 頁面
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
