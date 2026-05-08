import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/ranking_entry.dart';
import '../../../../providers/rankings_provider.dart';

class RankingsList extends ConsumerWidget {
  const RankingsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final department = ref.watch(selectedDepartmentProvider);
    final rankings = ref.watch(departmentRankingsProvider(department));
    final metric = getDepartmentMetric(department);

    // 找出最大值用於進度條計算
    final maxValue = rankings.isNotEmpty
        ? rankings.map((e) => e.value).reduce((a, b) => a > b ? a : b)
        : 100.0;

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: rankings.length,
        itemBuilder: (context, index) {
          final ranking = rankings[index];
          final progressValue = ranking.value / maxValue;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildRankingCard(
              context,
              ranking,
              metric,
              progression: progressValue,
            ),
          );
        },
      ),
    );
  }

  /// 排行卡片
  Widget _buildRankingCard(
    BuildContext context,
    RankingEntry ranking,
    DepartmentMetric metric, {
    required double progression,
  }) {
    final medalColors = {
      1: Color(0xFFF6BD16),
      2: Color(0xFFB0B7C3),
      3: Color(0xFFCD7F32),
    };

    return Container(
      decoration: BoxDecoration(
        color: ranking.isCurrentUser
            ? const Color(0xFF5B8FF9).withValues(alpha: 0.08)
            : Colors.white,
        border: ranking.isCurrentUser
            ? Border.all(
                color: const Color(0xFF5B8FF9).withValues(alpha: 0.3),
                width: 1.5,
              )
            : null,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // 頂部：排名、用戶名、獎章
          Row(
            children: [
              // 排名號碼
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ranking.medal != null
                      ? medalColors[ranking.medal]
                      : Colors.grey[300],
                ),
                alignment: Alignment.center,
                child: Text(
                  '${ranking.rank}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ranking.medal != null ? Colors.white : Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // 用戶名稱
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // 頭像
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(
                              0xFF5B8FF9,
                            ).withValues(alpha: 0.1),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            ranking.avatarInitials,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF5B8FF9),
                                ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ranking.name,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                ranking.department,
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // 指標值
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    ranking.value.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5B8FF9),
                    ),
                  ),
                  Text(
                    metric.unit,
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // 進度條
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progression,
              minHeight: 6,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                ranking.medal == 1
                    ? const Color(0xFFF6BD16)
                    : ranking.medal == 2
                    ? const Color(0xFFB0B7C3)
                    : ranking.medal == 3
                    ? const Color(0xFFCD7F32)
                    : const Color(0xFF5B8FF9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
