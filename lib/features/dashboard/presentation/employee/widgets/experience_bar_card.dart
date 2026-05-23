import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';
import 'package:eco_sensing_app/core/theme/app_decorations.dart';
import 'package:eco_sensing_app/core/widgets/app_card.dart';
import 'package:eco_sensing_app/features/gamification/providers/game_config_provider.dart';
import 'package:eco_sensing_app/features/user/providers/current_user_provider.dart';

class ExperienceBarCard extends ConsumerWidget {
  const ExperienceBarCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(currentUserProvider);
    final expPerLevel = ref.watch(expPerLevelProvider);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '經驗值',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '${userProfile.totalExp} / $expPerLevel EXP',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDecorations.pillRadius),
            child: LinearProgressIndicator(
              value: (userProfile.totalExp / expPerLevel).clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: AppColors.ceramic,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.greenAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
