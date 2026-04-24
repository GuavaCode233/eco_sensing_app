import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/rankings_provider.dart';

class DepartmentSelector extends ConsumerWidget {
  const DepartmentSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDept = ref.watch(selectedDepartmentProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        ? const Color(0xFF5B8FF9)
                        : const Color(0xFFFAFAFC),
                    border: isSelected
                        ? null
                        : Border.all(color: const Color(0xFFEEF0F4), width: 1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    dept,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
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
