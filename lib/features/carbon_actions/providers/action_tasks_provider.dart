import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/action_task.dart';

/// i減碳頁面可選類別（「全部」為 null）
const actionTaskCategories = ['交通', '廢棄物', '能源', '飲食', '辦公'];

/// 本月減碳目標 (kg CO₂)
const monthlyCo2GoalKg = 30.0;

/// 所有可執行的減碳任務列表
final availableActionTasksProvider = Provider<List<ActionTask>>((ref) {
  return [
    ActionTask(
      id: 1,
      icon: 'flight_takeoff',
      title: '商務差旅',
      description: '記錄和上傳商務差旅相關單據',
      explanation:
          '通過掃描或上傳差旅相關單據（如機票、高鐵票、飛行里程等），系統將自動計算相應的碳排放量，並實時更新您的碳足跡。',
      category: '交通',
      exp: 50,
      coins: 30,
      co2ReductionKg: 10.0,
      isNavigable: true,
      navigationRoute: '/scan',
    ),
    ActionTask(
      id: 6,
      icon: 'directions_bus',
      title: '搭乘大眾運輸',
      description: '記錄搭乘捷運、公車或高鐵',
      explanation:
          '記錄日常搭乘大眾運輸的行程，系統將依交通方式與距離估算減碳量，並累計至本月成果。',
      category: '交通',
      exp: 20,
      coins: 10,
      co2ReductionKg: 2.3,
      isNavigable: true,
      navigationRoute: '/scan',
    ),
    ActionTask(
      id: 7,
      icon: 'two_wheeler',
      title: '騎腳踏車通勤',
      description: '記錄今日騎腳踏車或電動滑板車通勤',
      explanation:
          '以腳踏車或電動滑板車取代開車通勤，可顯著降低交通碳排。完成後將自動計入本月減碳成果。',
      category: '交通',
      exp: 20,
      coins: 10,
      co2ReductionKg: 2.5,
      isNavigable: false,
      navigationRoute: null,
    ),
    ActionTask(
      id: 8,
      icon: 'directions_car',
      title: '共乘通勤',
      description: '與同事共乘或使用共乘服務',
      explanation:
          '記錄共乘通勤行程，系統將依乘客人數分攤碳排，並換算為您的減碳貢獻。',
      category: '交通',
      exp: 15,
      coins: 8,
      co2ReductionKg: 1.8,
      isNavigable: false,
      navigationRoute: null,
    ),
    ActionTask(
      id: 3,
      icon: 'delete_outline',
      title: '辦公室廢棄物',
      description: '上傳辦公室廢棄物相關文件和統計數據',
      explanation:
          '上傳辦公室廢棄物的重量、類別等信息，系統將自動計算對應的碳排放量。此功能正在開發中，敬請期待。',
      category: '廢棄物',
      exp: 40,
      coins: 25,
      co2ReductionKg: 8.0,
      isNavigable: false,
      navigationRoute: null,
    ),
    ActionTask(
      id: 2,
      icon: 'elevator',
      title: '電梯搭乘',
      description: '記錄每日搭乘電梯次數',
      explanation:
          '通過記錄日常搭乘電梯的次數，系統將基於樓層高度計算相應的碳排放數據。此功能正在開發中，敬請期待。',
      category: '能源',
      exp: 15,
      coins: 8,
      co2ReductionKg: 2.1,
      isNavigable: false,
      navigationRoute: null,
    ),
    ActionTask(
      id: 4,
      icon: 'restaurant',
      title: '餐飲碳排',
      description: '上傳餐飲相關單據和菜品信息',
      explanation:
          '通過上傳餐飲單據和菜品照片，系統將基於食物類別和份量估算碳排放量。幫助您瞭解飲食習慣對碳足跡的影響。',
      category: '飲食',
      exp: 35,
      coins: 20,
      co2ReductionKg: 3.5,
      isNavigable: true,
      navigationRoute: '/scan',
    ),
    ActionTask(
      id: 5,
      icon: 'description',
      title: '無紙化辦公',
      description: '優先使用電子文件，減少紙張列印',
      explanation:
          '記錄並追蹤無紙化辦公行為，系統將估算因減少列印而避免的碳排放。此功能正在開發中，敬請期待。',
      category: '辦公',
      exp: 20,
      coins: 12,
      co2ReductionKg: 0.8,
      isNavigable: false,
      navigationRoute: null,
    ),
  ];
});

/// 已完成的減碳任務 ID
final completedActionTasksProvider =
    NotifierProvider<CompletedActionTasksNotifier, Set<int>>(
      CompletedActionTasksNotifier.new,
    );

class CompletedActionTasksNotifier extends Notifier<Set<int>> {
  @override
  Set<int> build() => {1, 4, 7};

  void markAsCompleted(int taskId) {
    state = {...state, taskId};
  }

  void removeCompletion(int taskId) {
    state = state.where((id) => id != taskId).toSet();
  }
}

/// 今日完成的任務 ID（顯示「今日已完成」標籤）
final todayCompletedActionTasksProvider = Provider<Set<int>>((ref) {
  final completed = ref.watch(completedActionTasksProvider);
  return completed.where((id) => id == 7).toSet();
});

/// 目前選中的任務類別（null = 全部）
final selectedActionTaskCategoryProvider =
    NotifierProvider<SelectedActionTaskCategoryNotifier, String?>(
      SelectedActionTaskCategoryNotifier.new,
    );

class SelectedActionTaskCategoryNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void selectCategory(String? category) {
    state = category;
  }
}

/// 依類別篩選後的任務列表（未完成優先）
final filteredActionTasksProvider = Provider<List<ActionTask>>((ref) {
  final tasks = ref.watch(availableActionTasksProvider);
  final category = ref.watch(selectedActionTaskCategoryProvider);
  final completed = ref.watch(completedActionTasksProvider);

  final filtered = category == null
      ? tasks
      : tasks.where((task) => task.category == category).toList();

  final sorted = [...filtered]
    ..sort((a, b) {
      final aDone = completed.contains(a.id);
      final bDone = completed.contains(b.id);
      if (aDone == bDone) return a.id.compareTo(b.id);
      return aDone ? 1 : -1;
    });

  return sorted;
});

/// 各類別未完成任務數（null key = 全部）
final pendingTaskCountProvider = Provider<Map<String?, int>>((ref) {
  final tasks = ref.watch(availableActionTasksProvider);
  final completed = ref.watch(completedActionTasksProvider);

  int pendingFor(String? category) {
    return tasks
        .where(
          (t) =>
              (category == null || t.category == category) &&
              !completed.contains(t.id),
        )
        .length;
  }

  return {
    null: pendingFor(null),
    for (final category in actionTaskCategories) category: pendingFor(category),
  };
});

/// 減碳任務累計統計（所有已完成任務）
class ActionTaskStats {
  const ActionTaskStats({
    required this.completedCount,
    required this.totalExp,
    required this.totalCo2Kg,
  });

  final int completedCount;
  final int totalExp;
  final double totalCo2Kg;
}

final actionTaskStatsProvider = Provider<ActionTaskStats>((ref) {
  final tasks = ref.watch(availableActionTasksProvider);
  final completedIds = ref.watch(completedActionTasksProvider);
  final completedTasks = tasks.where((t) => completedIds.contains(t.id));

  return ActionTaskStats(
    completedCount: completedTasks.length,
    totalExp: completedTasks.fold(0, (sum, t) => sum + t.exp),
    totalCo2Kg: completedTasks.fold(0.0, (sum, t) => sum + t.co2ReductionKg),
  );
});

/// 本月減碳目標進度
class MonthlyCo2GoalProgress {
  const MonthlyCo2GoalProgress({
    required this.currentKg,
    required this.goalKg,
    required this.progress,
    required this.remainingKg,
  });

  final double currentKg;
  final double goalKg;
  final double progress;
  final double remainingKg;
}

final monthlyCo2GoalProgressProvider = Provider<MonthlyCo2GoalProgress>((ref) {
  final stats = ref.watch(actionTaskStatsProvider);
  final current = stats.totalCo2Kg;
  final goal = monthlyCo2GoalKg;
  final progress = (current / goal).clamp(0.0, 1.0);
  final remaining = (goal - current).clamp(0.0, goal);

  return MonthlyCo2GoalProgress(
    currentKg: current,
    goalKg: goal,
    progress: progress,
    remainingKg: remaining,
  );
});
