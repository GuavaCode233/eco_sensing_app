import 'package:flutter/material.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';
import 'package:eco_sensing_app/core/theme/app_decorations.dart';

enum UploadRecordStatus { completed, reviewing }

class RecentUploadRecord {
  const RecentUploadRecord({
    required this.title,
    required this.timeLabel,
    required this.detail,
    required this.status,
    this.expGain,
    this.co2Kg,
  });

  final String title;
  final String timeLabel;
  final String detail;
  final UploadRecordStatus status;
  final int? expGain;
  final double? co2Kg;
}

class RecentUploadsPanel extends StatefulWidget {
  const RecentUploadsPanel({
    super.key,
    required this.records,
    this.onViewAll,
  });

  final List<RecentUploadRecord> records;
  final VoidCallback? onViewAll;

  @override
  State<RecentUploadsPanel> createState() => _RecentUploadsPanelState();
}

class _RecentUploadsPanelState extends State<RecentUploadsPanel> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    if (widget.records.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDecorations.cardRadius),
        border: Border.all(color: AppColors.ceramic),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(AppDecorations.cardRadius),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Text(
                    '最近上傳',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: widget.onViewAll,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('查看全部'),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const Divider(height: 1, color: AppColors.ceramic),
            ...widget.records.map(
              (record) => _UploadRecordTile(record: record),
            ),
          ],
        ],
      ),
    );
  }
}

class _UploadRecordTile extends StatelessWidget {
  const _UploadRecordTile({required this.record});

  final RecentUploadRecord record;

  @override
  Widget build(BuildContext context) {
    final isReviewing = record.status == UploadRecordStatus.reviewing;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.greenLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isReviewing ? Icons.hourglass_top_outlined : Icons.receipt_long,
              color: AppColors.starbucksGreen,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${record.timeLabel} · ${record.detail}',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
          if (isReviewing)
            _StatusBadge(
              label: '審核中',
              color: AppColors.gold,
              background: AppColors.goldLightest,
            )
          else if (record.expGain != null)
            _StatusBadge(
              label: '+${record.expGain} EXP',
              color: AppColors.greenAccent,
              background: AppColors.greenLight,
            ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppDecorations.pillRadius),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
