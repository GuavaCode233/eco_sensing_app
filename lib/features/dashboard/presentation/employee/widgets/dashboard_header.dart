import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';
import 'package:eco_sensing_app/core/theme/app_decorations.dart';
import 'package:eco_sensing_app/core/widgets/app_card.dart';
import '../../../../user/providers/current_user_provider.dart';

class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(currentUserProvider);

    return AppCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.greenLight,
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    size: 28,
                    color: AppColors.starbucksGreen,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '歡迎回來',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        userProfile.displayName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildInfoTile(
                icon: Icons.star_rounded,
                label: 'Lv.',
                value: userProfile.level.toString(),
                accentColor: AppColors.gold,
                context: context,
              ),
              const SizedBox(height: 8),
              _buildInfoTile(
                icon: Icons.eco_outlined,
                label: '碳幣',
                value: userProfile.tokens.toString(),
                accentColor: AppColors.greenAccent,
                context: context,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color accentColor,
    required BuildContext context,
  }) {
    return Container(
      decoration: AppDecorations.pillChip(color: accentColor),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: accentColor, size: 18),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
