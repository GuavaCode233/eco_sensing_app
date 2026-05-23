import 'package:flutter/material.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';

class DashboardHeroMetrics extends StatelessWidget {
  const DashboardHeroMetrics({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricChip(
            label: '較上月',
            value: '-12%',
            valueColor: AppColors.greenLight,
            icon: Icons.trending_down_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricChip(
            label: '月目標',
            value: '60 kg',
            valueColor: AppColors.white,
            icon: Icons.flag_outlined,
          ),
        ),
      ],
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.icon,
  });

  final String label;
  final String value;
  final Color valueColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.white.withValues(alpha: 0.85)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.white.withValues(alpha: 0.72),
                    fontSize: 11,
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: valueColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
