import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';
import '../../../../../gamification/models/achievement.dart';
import '../../../../../gamification/providers/achievements_provider.dart';

class AchievementsTab extends ConsumerStatefulWidget {
  const AchievementsTab({super.key});

  static const _unlockedBg = Color(0xFFE8F5E9);
  static const _unlockedBorder = Color(0xFFA5D6A7);
  static const _iconBg = Color(0xFFC8E6C9);
  static const _achievementGreen = Color(0xFF2E7D32);

  @override
  ConsumerState<AchievementsTab> createState() => _AchievementsTabState();
}

class _AchievementsTabState extends ConsumerState<AchievementsTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isEditingShowcase = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allAchievements = ref.watch(userAchievementsProvider);
    final earnedCount = allAchievements.where((a) => a.earned).length;
    final displayedCount = allAchievements.where((a) => a.displayed).length;
    final totalCount = allAchievements.length;
    final remaining = totalCount - earnedCount;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: _UnlockSummary(
            earnedCount: earnedCount,
            totalCount: totalCount,
            remaining: remaining,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.neutralCool,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.greenAccent,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.card_membership, size: 18),
                      const SizedBox(width: 6),
                      Text('我的成就 ($earnedCount)'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.collections, size: 18),
                      const SizedBox(width: 6),
                      Text('展示櫃 ($displayedCount)'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildAchievementsTab(allAchievements),
              _buildShowcaseTab(allAchievements),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementsTab(List<Achievement> achievements) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.15,
            ),
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final achievement = achievements[index];
              return _buildAchievementCard(
                achievement,
                onToggleDisplay: () {
                  ref
                      .read(userAchievementsProvider.notifier)
                      .toggleAchievementDisplay(achievement.id);
                },
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildShowcaseTab(List<Achievement> allAchievements) {
    final displayedAchievements =
        allAchievements.where((a) => a.displayed).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '目前展示 ${displayedAchievements.length} 項成就',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isEditingShowcase = !_isEditingShowcase;
                    });
                  },
                  child: Text(_isEditingShowcase ? '完成' : '編輯'),
                ),
              ],
            ),
          ),
          if (displayedAchievements.isEmpty)
            Container(
              decoration: BoxDecoration(
                color: AppColors.neutralCool,
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(Icons.collections, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    '還沒有展示任何成就',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '前往「我的成就」選擇要展示的成就',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.15,
              ),
              itemCount: displayedAchievements.length,
              itemBuilder: (context, index) {
                final achievement = displayedAchievements[index];
                return _buildShowcaseCard(
                  achievement,
                  isEditing: _isEditingShowcase,
                  onToggleDisplay: () {
                    ref
                        .read(userAchievementsProvider.notifier)
                        .toggleAchievementDisplay(achievement.id);
                  },
                );
              },
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(
    Achievement achievement, {
    required VoidCallback onToggleDisplay,
  }) {
    final earned = achievement.earned;
    // ignore: deprecated_member_use — 依設計規格使用 surfaceVariant
    final lockedBg =
        Theme.of(context).colorScheme.surfaceVariant.withValues(alpha: 0.6);
    final progress = _lockedProgress(achievement);

    return Container(
      decoration: BoxDecoration(
        color: earned ? AchievementsTab._unlockedBg : lockedBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: earned ? AchievementsTab._unlockedBorder : AppColors.ceramic,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: earned
                      ? AchievementsTab._iconBg
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIconData(achievement.icon),
                  size: 22,
                  color: earned
                      ? AchievementsTab._achievementGreen
                      : Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                achievement.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: earned ? null : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                achievement.description,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
              const Spacer(),
              if (!earned && progress != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress.current / progress.target,
                    minHeight: 4,
                    backgroundColor: AppColors.ceramic,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AchievementsTab._achievementGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${progress.current}/${progress.target} 次',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AchievementsTab._achievementGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ] else if (earned)
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.scale(
                        scale: 0.75,
                        child: Switch(
                          value: achievement.displayed,
                          onChanged: (_) => onToggleDisplay(),
                          activeTrackColor: AchievementsTab._achievementGreen,
                          activeThumbColor: Colors.white,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      if (achievement.displayed)
                        const Text(
                          '展示中',
                          style: TextStyle(
                            fontSize: 10,
                            color: AchievementsTab._achievementGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
          if (earned)
            const Positioned(
              top: 0,
              right: 0,
              child: _CircleBadge(icon: Icons.check),
            ),
        ],
      ),
    );
  }

  Widget _buildShowcaseCard(
    Achievement achievement, {
    required bool isEditing,
    required VoidCallback onToggleDisplay,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AchievementsTab._unlockedBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AchievementsTab._unlockedBorder,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AchievementsTab._iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIconData(achievement.icon),
                  size: 22,
                  color: AchievementsTab._achievementGreen,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                achievement.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                achievement.description,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
              if (isEditing) ...[
                const Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: onToggleDisplay,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: AppColors.textSecondary,
                    ),
                    child: const Text('移除', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ],
          ),
          if (!isEditing)
            const Positioned(
              top: 0,
              right: 0,
              child: _CircleBadge(icon: Icons.star, iconSize: 10),
            ),
        ],
      ),
    );
  }

  /// UI-only：從描述文字推算未解鎖成就的展示進度
  ({int current, int target})? _lockedProgress(Achievement achievement) {
    if (achievement.earned) return null;
    final match = RegExp(r'(\d+)').firstMatch(achievement.description);
    if (match == null) return null;
    final target = int.parse(match.group(1)!);
    if (target <= 1) return (current: 0, target: target);
    final current = ((achievement.id * 11 + 7) % target).clamp(1, target - 1);
    return (current: current, target: target);
  }

  IconData _getIconData(String iconName) {
    const iconMap = {
      'directions_bus': Icons.directions_bus,
      'two_wheeler': Icons.two_wheeler,
      'directions_walk': Icons.directions_walk,
      'recycling': Icons.recycling,
      'local_drink': Icons.local_drink,
      'shopping_bag': Icons.shopping_bag,
      'lightbulb': Icons.lightbulb,
      'ac_unit': Icons.ac_unit,
      'restaurant': Icons.restaurant,
      'description': Icons.description,
    };
    return iconMap[iconName] ?? Icons.star;
  }
}

class _UnlockSummary extends StatelessWidget {
  const _UnlockSummary({
    required this.earnedCount,
    required this.totalCount,
    required this.remaining,
  });

  final int earnedCount;
  final int totalCount;
  final int remaining;

  @override
  Widget build(BuildContext context) {
    final progress = totalCount > 0 ? earnedCount / totalCount : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '已解鎖 $earnedCount / $totalCount',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AchievementsTab._achievementGreen,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: AppColors.ceramic,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AchievementsTab._achievementGreen,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '還差 $remaining 個解鎖全部',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _CircleBadge extends StatelessWidget {
  const _CircleBadge({
    required this.icon,
    this.iconSize = 12,
  });

  final IconData icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: const BoxDecoration(
        color: AchievementsTab._achievementGreen,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: iconSize, color: Colors.white),
    );
  }
}
