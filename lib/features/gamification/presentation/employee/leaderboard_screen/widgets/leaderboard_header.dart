import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/rankings_provider.dart';

class LeaderboardHeader extends ConsumerWidget {
  const LeaderboardHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserRanking = ref.watch(currentUserRankingProvider);
    final department = ref.watch(selectedDepartmentProvider);
    final metric = getDepartmentMetric(department);

    return Stack(
      children: [
        // 頂部漸變背景 - 黃金色
        Container(
          height: 240 + MediaQuery.of(context).padding.top,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF6BD16), Color(0xFFE0A010)], // 黃金漸變
            ),
          ),
        ),
        // 頁面標題和個人排名卡片
        Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: MediaQuery.of(context).padding.top + 8,
            bottom: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 頁面標題
              Text(
                '部門排行榜',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              // 個人排名卡片
              _buildPersonalRankingCard(context, currentUserRanking, metric),
            ],
          ),
        ),
      ],
    );
  }

  /// 個人排名卡片
  Widget _buildPersonalRankingCard(
    BuildContext context,
    ranking,
    DepartmentMetric metric,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
        children: [
          // 排名和獎章
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '你的排名',
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '第 ${ranking.rank} 名',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFF6BD16),
                            ),
                      ),
                      const SizedBox(width: 12),
                      if (ranking.medal != null)
                        _buildMedalBadge(ranking.medal!),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    metric.label,
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${ranking.value.toStringAsFixed(1)} ${metric.unit}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5B8FF9),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 用戶名稱
          Text(
            ranking.name,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  /// 獎章徽章
  Widget _buildMedalBadge(int medal) {
    final medalColors = {
      1: Color(0xFFF6BD16), // 金色
      2: Color(0xFFB0B7C3), // 銀色
      3: Color(0xFFCD7F32), // 銅色
    };

    return Container(
      decoration: BoxDecoration(
        color: medalColors[medal] ?? Colors.grey,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: (medalColors[medal] ?? Colors.grey).withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Icon(Icons.emoji_events, size: 20, color: Colors.white),
    );
  }
}
