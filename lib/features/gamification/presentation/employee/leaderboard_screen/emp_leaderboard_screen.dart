import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';
import 'package:eco_sensing_app/core/theme/app_decorations.dart';
import 'widgets/department_selector.dart';
import 'widgets/leaderboard_header.dart';
import 'widgets/leaderboard_podium.dart';
import 'widgets/metrics_info_card.dart';
import 'widgets/rankings_list.dart';

class LeaderboardPage extends ConsumerWidget {
  const LeaderboardPage({super.key});

  static const _cardOverlap = 40.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomInset = MediaQuery.of(context).padding.bottom +
        kBottomNavigationBarHeight +
        24;

    return Scaffold(
      backgroundColor: AppColors.neutralWarm,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: MediaQuery.of(context).padding.top + 20,
                bottom: 64,
              ),
              decoration: AppDecorations.featureBand(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '部門排行榜',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '與同事一起競逐減碳排名',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.white.withValues(alpha: 0.78),
                    ),
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -_cardOverlap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: LeaderboardHeader(),
                  ),
                  const SizedBox(height: 12),
                  const DepartmentSelector(),
                  const SizedBox(height: 12),
                  const MetricsInfoCard(),
                  const SizedBox(height: 20),
                  const LeaderboardPodium(),
                  const SizedBox(height: 16),
                  const RankingsList(),
                  SizedBox(height: bottomInset),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
