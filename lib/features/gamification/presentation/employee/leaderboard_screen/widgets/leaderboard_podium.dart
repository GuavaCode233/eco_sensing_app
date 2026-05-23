import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';
import '../../../../models/ranking_entry.dart';
import '../../../../providers/rankings_provider.dart';

/// 前三名獎台式佈局
class LeaderboardPodium extends ConsumerWidget {
  const LeaderboardPodium({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final department = ref.watch(selectedDepartmentProvider);
    final rankings = ref.watch(departmentRankingsProvider(department));
    final metric = getDepartmentMetric(department);

    final topThree = rankings.where((e) => e.rank <= 3).toList()
      ..sort((a, b) => a.rank.compareTo(b.rank));

    if (topThree.length < 3) return const SizedBox.shrink();

    final second = topThree.firstWhere((e) => e.rank == 2);
    final first = topThree.firstWhere((e) => e.rank == 1);
    final third = topThree.firstWhere((e) => e.rank == 3);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: _PodiumSlot(
              entry: second,
              metric: metric,
              podiumHeight: 72,
              accentColor: AppColors.silver,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _PodiumSlot(
              entry: first,
              metric: metric,
              podiumHeight: 96,
              accentColor: AppColors.gold,
              isWinner: true,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _PodiumSlot(
              entry: third,
              metric: metric,
              podiumHeight: 56,
              accentColor: AppColors.bronze,
            ),
          ),
        ],
      ),
    );
  }
}

class _PodiumSlot extends StatelessWidget {
  const _PodiumSlot({
    required this.entry,
    required this.metric,
    required this.podiumHeight,
    required this.accentColor,
    this.isWinner = false,
  });

  final RankingEntry entry;
  final DepartmentMetric metric;
  final double podiumHeight;
  final Color accentColor;
  final bool isWinner;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _AvatarCircle(
          initials: entry.avatarInitials,
          accentColor: accentColor,
          size: isWinner ? 52 : 44,
          showStar: entry.isCurrentUser,
        ),
        const SizedBox(height: 8),
        Text(
          entry.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${entry.value.toStringAsFixed(1)} ${metric.unit}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.starbucksGreen,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: podiumHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                accentColor.withValues(alpha: 0.35),
                accentColor.withValues(alpha: 0.12),
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            border: Border.all(color: accentColor.withValues(alpha: 0.4)),
          ),
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            '${entry.rank}',
            style: TextStyle(
              fontSize: isWinner ? 28 : 22,
              fontWeight: FontWeight.w700,
              color: accentColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({
    required this.initials,
    required this.accentColor,
    required this.size,
    this.showStar = false,
  });

  final String initials;
  final Color accentColor;
  final double size;
  final bool showStar;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: accentColor.withValues(alpha: 0.15),
            border: Border.all(color: accentColor, width: 2),
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: size * 0.28,
              color: AppColors.starbucksGreen,
            ),
          ),
        ),
        if (showStar)
          const Positioned(
            right: -4,
            top: -4,
            child: Icon(Icons.star, size: 16, color: AppColors.gold),
          ),
      ],
    );
  }
}
