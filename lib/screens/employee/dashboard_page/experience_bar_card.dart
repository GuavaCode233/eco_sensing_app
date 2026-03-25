import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/current_user_provider.dart';

class ExperienceBarCard extends ConsumerWidget {
  const ExperienceBarCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(currentUserProvider); // 從 provider 獲取用戶資料

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
            _buildExperienceBarCard(context, userProfile: userProfile),
      ],
    );
  }

    Widget _buildExperienceBarCard(BuildContext context, {required userProfile}) {
    // 經驗值進度卡
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
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '⚡ 經驗值',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '${userProfile.totalExp} / 500',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildExperienceBar(context, userProfile: userProfile),
        ],
      ),
    );
  }

  Widget _buildExperienceBar(BuildContext context, {required userProfile}) {
    // 經驗值進度條
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(4),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: FractionallySizedBox(
          alignment: Alignment.topLeft,
          widthFactor: 0.7, // The progress value (e.g., 0.7 for 70%)
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Colors.blue,
                  Color.fromARGB(255, 142, 221, 252),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
