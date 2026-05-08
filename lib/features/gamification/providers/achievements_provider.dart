import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/achievement.dart';

/// 所有可能的成就列表
final allAchievementsProvider = Provider<List<Achievement>>((ref) {
  return [
    Achievement(
      id: 1,
      icon: 'directions_bus',
      title: '大眾運輸達人',
      description: '搭乘大眾運輸 30 次',
      earned: true,
      displayed: true,
    ),
    Achievement(
      id: 2,
      icon: 'two_wheeler',
      title: '自行車愛好者',
      description: '騎自行車上班 20 次',
      earned: true,
      displayed: true,
    ),
    Achievement(
      id: 3,
      icon: 'directions_walk',
      title: '健身步行者',
      description: '步行或跑步上班 15 次',
      earned: false,
      displayed: false,
    ),
    Achievement(
      id: 4,
      icon: 'recycling',
      title: '垃圾分類大師',
      description: '進行垃圾分類 50 次',
      earned: true,
      displayed: true,
    ),
    Achievement(
      id: 5,
      icon: 'local_drink',
      title: '綠色飲品守護者',
      description: '使用可重複使用水杯 100 次',
      earned: false,
      displayed: false,
    ),
    Achievement(
      id: 6,
      icon: 'shopping_bag',
      title: '環保購物者',
      description: '購物使用自備袋 40 次',
      earned: true,
      displayed: false,
    ),
    Achievement(
      id: 7,
      icon: 'lightbulb',
      title: '節能先鋒',
      description: '使用LED燈泡',
      earned: true,
      displayed: true,
    ),
    Achievement(
      id: 8,
      icon: 'ac_unit',
      title: '溫度調整者',
      description: '調整空調溫度 50 次',
      earned: false,
      displayed: false,
    ),
    Achievement(
      id: 9,
      icon: 'restaurant',
      title: '綠色美食家',
      description: '減少肉類攝取 20 次',
      earned: false,
      displayed: false,
    ),
    Achievement(
      id: 10,
      icon: 'description',
      title: '無紙辦公倡導者',
      description: '發起或參與無紙化辦公計劃',
      earned: true,
      displayed: true,
    ),
  ];
});

/// 用戶成就列表（管理已獲得和展示狀態）
final userAchievementsProvider =
    NotifierProvider<UserAchievementsNotifier, List<Achievement>>(() {
      return UserAchievementsNotifier();
    });

/// 用戶成就狀態管理器
class UserAchievementsNotifier extends Notifier<List<Achievement>> {
  @override
  List<Achievement> build() {
    // 初始狀態為所有成就列表，未來可改為從後端 API 獲取用戶的成就狀態
    final allAchievements = ref.watch(allAchievementsProvider);
    return allAchievements;
  }

  /// 切換成就展示狀態
  void toggleAchievementDisplay(int achievementId) {
    state = state.map((achievement) {
      if (achievement.id == achievementId && achievement.earned) {
        return achievement.copyWith(displayed: !achievement.displayed);
      }
      return achievement;
    }).toList();
  }

  /// 設定成就展示狀態
  void setAchievementDisplay(int achievementId, bool display) {
    state = state.map((achievement) {
      if (achievement.id == achievementId && achievement.earned) {
        return achievement.copyWith(displayed: display);
      }
      return achievement;
    }).toList();
  }

  /// 獲得新成就（後端會呼叫此方法）
  void unlockAchievement(int achievementId) {
    state = state.map((achievement) {
      if (achievement.id == achievementId) {
        return achievement.copyWith(earned: true);
      }
      return achievement;
    }).toList();
  }

  /// 重置所有成就（測試用）
  void resetAll(List<Achievement> newAchievements) {
    state = newAchievements;
  }
}

/// 已獲得的成就列表 provider（只讀）
final earnedAchievementsProvider = Provider<List<Achievement>>((ref) {
  final achievements = ref.watch(userAchievementsProvider);
  return achievements.where((a) => a.earned).toList();
});

/// 未獲得的成就列表 provider（只讀）
final unlockedAchievementsProvider = Provider<List<Achievement>>((ref) {
  final achievements = ref.watch(userAchievementsProvider);
  return achievements.where((a) => !a.earned).toList();
});

/// 展示中的成就列表 provider（只讀）
final displayedAchievementsProvider = Provider<List<Achievement>>((ref) {
  final achievements = ref.watch(userAchievementsProvider);
  return achievements.where((a) => a.displayed).toList();
});
