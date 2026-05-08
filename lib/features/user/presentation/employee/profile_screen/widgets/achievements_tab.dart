import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../gamification/models/achievement.dart';
import '../../../../../gamification/providers/achievements_provider.dart';

class AchievementsTab extends ConsumerStatefulWidget {
  const AchievementsTab({super.key});

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
    final earnedAchievements = ref.watch(earnedAchievementsProvider);
    final displayedAchievements = earnedAchievements
        .where((a) => a.displayed)
        .toList();

    return Column(
      children: [
        // Tab 頭部
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF5B8FF9),
              unselectedLabelColor: Colors.grey[600],
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
                      const Icon(Icons.card_membership),
                      const SizedBox(width: 8),
                      Text('我的成就 (${earnedAchievements.length})'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.collections),
                      const SizedBox(width: 8),
                      Text('展示櫃 (${displayedAchievements.length})'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Tab 內容
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // 所有成就標籤
              _buildAchievementsTab(earnedAchievements),
              // 展示櫃標籤
              _buildShowcaseTab(earnedAchievements),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementsTab(List<Achievement> achievements) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
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
    final displayedAchievements = allAchievements
        .where((a) => a.displayed)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          // 展示櫃編輯按鈕
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '目前展示 ${displayedAchievements.length} 項成就',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                _isEditingShowcase
                    ? Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isEditingShowcase = false;
                              });
                            },
                            child: const Text('完成'),
                          ),
                        ],
                      )
                    : TextButton(
                        onPressed: () {
                          setState(() {
                            _isEditingShowcase = true;
                          });
                        },
                        child: const Text('編輯'),
                      ),
              ],
            ),
          ),
          if (displayedAchievements.isEmpty)
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(Icons.collections, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    '還沒有展示任何成就',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '前往「我的成就」選擇要展示的成就',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
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
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: achievement.displayed
              ? const Color(0xFF5B8FF9).withValues(alpha: 0.3)
              : Colors.grey[300]!,
          width: 1.5,
        ),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 成就圖標
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF5B8FF9).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getIconData(achievement.icon),
              size: 32,
              color: const Color(0xFF5B8FF9),
            ),
          ),
          const SizedBox(height: 8),
          // 成就名稱
          Text(
            achievement.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          // 成就描述
          Text(
            achievement.description,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          // 展示按鈕
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onToggleDisplay,
                style: ElevatedButton.styleFrom(
                  backgroundColor: achievement.displayed
                      ? const Color(0xFF5B8FF9)
                      : Colors.grey[300],
                  foregroundColor: achievement.displayed
                      ? Colors.white
                      : Colors.grey[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                ),
                child: Text(
                  achievement.displayed ? '已展示' : '展示',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
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
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFF6BD16).withValues(alpha: 0.3),
              width: 2,
            ),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 成就圖標
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6BD16).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getIconData(achievement.icon),
                  size: 32,
                  color: const Color(0xFFF6BD16),
                ),
              ),
              const SizedBox(height: 8),
              // 成就名稱
              Text(
                achievement.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              // 成就描述
              Text(
                achievement.description,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
              ),
              if (isEditing)
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onToggleDisplay,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.grey[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 6),
                      ),
                      child: const Text('移除', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (!isEditing)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF6BD16),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.star, size: 16, color: Colors.white),
            ),
          ),
      ],
    );
  }

  IconData _getIconData(String iconName) {
    final iconMap = {
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
