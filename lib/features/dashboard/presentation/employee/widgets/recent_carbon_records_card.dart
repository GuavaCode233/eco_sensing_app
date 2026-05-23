import 'package:flutter/material.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';
import 'package:eco_sensing_app/core/widgets/app_card.dart';

class CarbonRecord {
  const CarbonRecord({
    required this.title,
    required this.subtitle,
    required this.amountKg,
    required this.isReduction,
  });

  final String title;
  final String subtitle;
  final double amountKg;
  final bool isReduction;
}

class RecentCarbonRecordsCard extends StatelessWidget {
  const RecentCarbonRecordsCard({super.key});

  static const _records = [
    CarbonRecord(
      title: '出差',
      subtitle: '台北 → 高雄',
      amountKg: 8.2,
      isReduction: false,
    ),
    CarbonRecord(
      title: '廢棄物回收',
      subtitle: '辦公室資源回收',
      amountKg: 1.5,
      isReduction: true,
    ),
    CarbonRecord(
      title: '通勤',
      subtitle: '開車',
      amountKg: 4.1,
      isReduction: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '近期碳排紀錄',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ...List.generate(_records.length, (index) {
            final record = _records[index];
            return Column(
              children: [
                if (index > 0) ...[
                  const Divider(height: 20, color: AppColors.ceramic),
                ],
                _RecordRow(record: record),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _RecordRow extends StatelessWidget {
  const _RecordRow({required this.record});

  final CarbonRecord record;

  @override
  Widget build(BuildContext context) {
    final amountColor = record.isReduction
        ? AppColors.greenAccent
        : AppColors.textPrimary;
    final prefix = record.isReduction ? '-' : '';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.greenLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _iconForRecord(record.title),
            size: 18,
            color: AppColors.starbucksGreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${record.title} — ${record.subtitle}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Text(
          '$prefix${record.amountKg.toStringAsFixed(1)} kg',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: amountColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  IconData _iconForRecord(String title) {
    switch (title) {
      case '出差':
        return Icons.flight_takeoff;
      case '廢棄物回收':
        return Icons.recycling;
      case '通勤':
        return Icons.directions_car_outlined;
      default:
        return Icons.eco_outlined;
    }
  }
}
