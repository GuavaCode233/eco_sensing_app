import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/action_task.dart';

class ActionTaskCard extends ConsumerWidget {
  final ActionTask task;
  final VoidCallback? onInfoPressed;
  final VoidCallback? onTaskPressed;

  const ActionTaskCard({
    super.key,
    required this.task,
    this.onInfoPressed,
    this.onTaskPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: task.isNavigable ? onTaskPressed : null,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: task.isNavigable
                ? const Color(0xFF3DBF8A).withValues(alpha: 0.2)
                : Colors.grey[300]!,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 頂部：圖標、名稱和動作按鍵
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 左側：圖標和名稱
                Expanded(
                  child: Row(
                    children: [
                      // 任務圖標
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: task.isNavigable
                              ? const Color(0xFF3DBF8A).withValues(alpha: 0.1)
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _getIconData(task.icon),
                          size: 28,
                          color: task.isNavigable
                              ? const Color(0xFF3DBF8A)
                              : Colors.grey[400],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // 名稱和描述
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              task.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // 右側：說明按鍵
                IconButton(
                  onPressed: onInfoPressed,
                  icon: const Icon(Icons.info_outline),
                  iconSize: 20,
                  color: Colors.grey[500],
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 獎勵信息
            Row(
              children: [
                // 經驗值
                Expanded(
                  child: _buildRewardChip(
                    context,
                    icon: Icons.local_fire_department,
                    label: 'EXP',
                    value: '${task.exp}',
                    color: const Color(0xFFF6BD16),
                  ),
                ),
                const SizedBox(width: 8),
                // 貨幣
                Expanded(
                  child: _buildRewardChip(
                    context,
                    icon: Icons.monetization_on,
                    label: 'Coins',
                    value: '${task.coins}',
                    color: const Color(0xFF3DBF8A),
                  ),
                ),
              ],
            ),
            if (task.isNavigable) ...[
              const SizedBox(height: 12),
              // 可操作標籤和按鍵
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onTaskPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3DBF8A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
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
              // 未開發提示
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Icon(Icons.build, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '功能開發中',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.grey[600],
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
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
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
