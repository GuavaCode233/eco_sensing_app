import 'package:flutter/material.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';

/// 今日減碳行動提示（模擬每日輪播）
class DailyCarbonTipCard extends StatelessWidget {
  const DailyCarbonTipCard({super.key});

  static const _tips = [
    '搭乘大眾運輸可減少 2.3 kg 碳排',
    '自備環保杯可減少 0.3 kg 碳排',
    '選擇視訊會議可減少 5.1 kg 差旅碳排',
    '關閉未使用電源可減少 0.8 kg 碳排',
  ];

  String get _todayTip {
    final dayIndex = DateTime.now().day % _tips.length;
    return _tips[dayIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.greenLight.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greenAccent.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline,
            size: 20,
            color: AppColors.starbucksGreen,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: '今日建議：',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.starbucksGreen,
                    ),
                  ),
                  TextSpan(text: _todayTip),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
