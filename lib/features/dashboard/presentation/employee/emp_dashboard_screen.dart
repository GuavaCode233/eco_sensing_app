import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';
import 'package:eco_sensing_app/core/theme/app_decorations.dart';
import 'package:eco_sensing_app/features/dashboard/presentation/employee/widgets/experience_bar_card.dart';
import 'package:eco_sensing_app/features/dashboard/presentation/employee/widgets/carbon_composiotion_card.dart';
import 'package:eco_sensing_app/features/dashboard/presentation/employee/widgets/dashboard_header.dart';
import 'package:eco_sensing_app/features/dashboard/presentation/employee/widgets/dashboard_hero_metrics.dart';
import 'package:eco_sensing_app/features/dashboard/presentation/employee/widgets/daily_carbon_tip_card.dart';
import 'package:eco_sensing_app/features/dashboard/presentation/employee/widgets/recent_carbon_records_card.dart';
import '../../../auth/login_screen.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                top: MediaQuery.of(context).padding.top + 24,
                bottom: 48,
              ),
              decoration: AppDecorations.featureBand(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '儀表板',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '追蹤您的碳足跡與減碳進度',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.white.withValues(alpha: 0.78),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const DashboardHeroMetrics(),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -28),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DashboardHeader(),
                    const SizedBox(height: 16),
                    const ExperienceBarCard(),
                    const SizedBox(height: 12),
                    const DailyCarbonTipCard(),
                    const SizedBox(height: 16),
                    const CarbonCompositionCard(),
                    const SizedBox(height: 16),
                    const RecentCarbonRecordsCard(),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: const Text('登出'),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
