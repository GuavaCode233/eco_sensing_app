import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/carbon_activity.dart';

/// 所有可執行的減碳活動列表
final allActivitiesProvider = Provider<List<CarbonActivity>>((ref) {
  return [
    // 交通類別
    CarbonActivity(
      id: 1,
      icon: 'directions_bus',
      category: '交通',
      title: '搭乘大眾運輸',
      description: '上班途中使用捷運、公車或火車',
      exp: 10,
      coins: 5,
      co2: 2.4,
      difficulty: '簡單',
    ),
    CarbonActivity(
      id: 2,
      icon: 'two_wheeler',
      category: '交通',
      title: '騎自行車上班',
      description: '騎自行車或電動滑板車代替開車',
      exp: 20,
      coins: 10,
      co2: 5.0,
      difficulty: '中等',
    ),
    CarbonActivity(
      id: 3,
      icon: 'directions_walk',
      category: '交通',
      title: '步行上班',
      description: '走路或跑步上班',
      exp: 25,
      coins: 12,
      co2: 6.0,
      difficulty: '困難',
    ),
    // 廢棄物類別
    CarbonActivity(
      id: 4,
      icon: 'recycling',
      category: '廢棄物',
      title: '進行垃圾分類',
      description: '正確分類可回收物品',
      exp: 8,
      coins: 4,
      co2: 1.2,
      difficulty: '簡單',
    ),
    CarbonActivity(
      id: 5,
      icon: 'local_drink',
      category: '廢棄物',
      title: '使用可重複使用水杯',
      description: '減少一次性杯子使用',
      exp: 5,
      coins: 2,
      co2: 0.5,
      difficulty: '簡單',
    ),
    CarbonActivity(
      id: 6,
      icon: 'shopping_bag',
      category: '廢棄物',
      title: '購物使用自備袋',
      description: '攜帶環保購物袋',
      exp: 6,
      coins: 3,
      co2: 0.8,
      difficulty: '簡單',
    ),
    // 能源類別
    CarbonActivity(
      id: 7,
      icon: 'lightbulb',
      category: '能源',
      title: '使用LED燈泡',
      description: '更換為省電LED燈泡',
      exp: 12,
      coins: 6,
      co2: 1.5,
      difficulty: '簡單',
    ),
    CarbonActivity(
      id: 8,
      icon: 'ac_unit',
      category: '能源',
      title: '調整空調溫度',
      description: '將空調設定提高1度',
      exp: 10,
      coins: 5,
      co2: 1.0,
      difficulty: '簡單',
    ),
    // 飲食類別
    CarbonActivity(
      id: 9,
      icon: 'restaurant',
      category: '飲食',
      title: '減少肉類攝取',
      description: '改為植物性蛋白餐點',
      exp: 15,
      coins: 7,
      co2: 2.5,
      difficulty: '中等',
    ),
    // 辦公類別
    CarbonActivity(
      id: 10,
      icon: 'description',
      category: '辦公',
      title: '減少用紙',
      description: '優先使用電子文件和無紙化辦公',
      exp: 10,
      coins: 5,
      co2: 0.5,
      difficulty: '簡單',
    ),
  ];
});

/// 用戶已完成的活動 ID 集合
final completedActivitiesProvider =
    StateNotifierProvider<CompletedActivitiesNotifier, Set<int>>((ref) {
      return CompletedActivitiesNotifier({});
    });

/// 完成活動狀態管理器
class CompletedActivitiesNotifier extends StateNotifier<Set<int>> {
  CompletedActivitiesNotifier(super.initialState);

  /// 標記活動為已完成
  void completeActivity(int activityId) {
    state = {...state, activityId};
  }

  /// 取消活動完成狀態
  void uncompleteActivity(int activityId) {
    state = state.where((id) => id != activityId).toSet();
  }

  /// 清除所有完成記錄（測試用）
  void clearAll() {
    state = {};
  }
}

/// 按分類篩選活動的 provider
final activitiesByCategoryProvider =
    StateNotifierProvider<CategoryFilterNotifier, String?>((ref) {
      return CategoryFilterNotifier(null);
    });

/// 分類篩選狀態管理器
class CategoryFilterNotifier extends StateNotifier<String?> {
  CategoryFilterNotifier(super.initialState);

  /// 設定篩選分類
  void setCategory(String? category) {
    state = category;
  }

  /// 清除篩選
  void clearFilter() {
    state = null;
  }
}
