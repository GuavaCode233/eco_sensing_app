import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';
import 'package:eco_sensing_app/core/theme/app_decorations.dart';
import '../../../../providers/rankings_provider.dart';

class DepartmentSelector extends ConsumerWidget {
  const DepartmentSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDept = ref.watch(selectedDepartmentProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: departments.map((dept) {
            final isSelected = selectedDept == dept;
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () {
                  ref
                      .read(selectedDepartmentProvider.notifier)
                      .selectDepartment(dept);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.greenAccent
                        : AppColors.white,
                    border: isSelected
                        ? null
                        : Border.all(color: AppColors.ceramic, width: 1),
                    borderRadius: BorderRadius.circular(AppDecorations.pillRadius),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    dept,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppColors.white : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
