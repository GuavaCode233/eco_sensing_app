import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';
import '../../../../providers/current_user_provider.dart';

/// 深綠 header 內的用戶識別區：頭像、名字、Email、等級與碳幣
class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({super.key});

  String _initials(String name) {
    if (name.isEmpty) return '?';
    return name.substring(0, 1);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white.withValues(alpha: 0.18),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.45),
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            _initials(user.displayName),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.displayName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.email,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.white.withValues(alpha: 0.78),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _HeaderBadge(
                    icon: Icons.star_rounded,
                    label: 'Lv.${user.level}',
                    color: AppColors.gold,
                  ),
                  _HeaderBadge(
                    icon: Icons.monetization_on_outlined,
                    label: '碳幣 ${user.tokens}',
                    color: AppColors.greenLight,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderBadge extends StatelessWidget {
  const _HeaderBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
