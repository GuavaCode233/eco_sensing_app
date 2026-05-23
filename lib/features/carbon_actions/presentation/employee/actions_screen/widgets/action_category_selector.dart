import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';
import 'package:eco_sensing_app/core/theme/app_decorations.dart';
import 'package:eco_sensing_app/features/carbon_actions/providers/action_tasks_provider.dart';

class ActionCategorySelector extends ConsumerWidget {
  const ActionCategorySelector({super.key});

  static const _allLabel = '全部';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedActionTaskCategoryProvider);
    final pendingCounts = ref.watch(pendingTaskCountProvider);
    final categories = [_allLabel, ...actionTaskCategories];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final label = categories[index];
          final isAll = label == _allLabel;
          final isSelected = isAll ? selected == null : selected == label;
          final pending = pendingCounts[isAll ? null : label] ?? 0;

          return GestureDetector(
            onTap: () {
              ref
                  .read(selectedActionTaskCategoryProvider.notifier)
                  .selectCategory(isAll ? null : label);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.greenAccent : AppColors.white,
                borderRadius: BorderRadius.circular(AppDecorations.pillRadius),
                border: Border.all(
                  color: isSelected ? AppColors.greenAccent : AppColors.ceramic,
                ),
                boxShadow: isSelected
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.14,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                  if (pending > 0) ...[
                    const SizedBox(width: 8),
                    _PendingBadge(
                      count: pending,
                      isSelected: isSelected,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PendingBadge extends StatelessWidget {
  const _PendingBadge({
    required this.count,
    required this.isSelected,
  });

  final int count;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.white.withValues(alpha: 0.22)
            : AppColors.greenLight,
        borderRadius: BorderRadius.circular(AppDecorations.pillRadius),
      ),
      alignment: Alignment.center,
      child: Text(
        '$count',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isSelected ? AppColors.white : AppColors.starbucksGreen,
        ),
      ),
    );
  }
}
