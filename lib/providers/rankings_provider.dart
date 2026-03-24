import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ranking_entry.dart';

/// 各部門的動態指標說明
enum DepartmentMetric {
  businessTravel('差旅減碳量', 'kg'),
  powerSaving('用電節省量', 'kWh'),
  paperReduction('用紙減少量', '張'),
  wasteReduction('廢棄物減量', 'kg'),
  vehicleCarbon('車輛碳減量', 'kg');

  final String label;
  final String unit;

  const DepartmentMetric(this.label, this.unit);
}

/// 部門清單
const departments = ['業務部', '研發部', '人資部', '行銷部', '物流部'];

/// 獲取指定部門的指標類型
DepartmentMetric getDepartmentMetric(String department) {
  switch (department) {
    case '業務部':
      return DepartmentMetric.businessTravel;
    case '研發部':
      return DepartmentMetric.powerSaving;
    case '人資部':
      return DepartmentMetric.paperReduction;
    case '行銷部':
      return DepartmentMetric.wasteReduction;
    case '物流部':
      return DepartmentMetric.vehicleCarbon;
    default:
      return DepartmentMetric.businessTravel;
  }
}

/// 當前選中的部門 provider
final selectedDepartmentProvider =
    StateNotifierProvider<SelectedDepartmentNotifier, String>((ref) {
      return SelectedDepartmentNotifier('業務部');
    });

/// 部門選擇狀態管理器
class SelectedDepartmentNotifier extends StateNotifier<String> {
  SelectedDepartmentNotifier(super.initialState);

  /// 切換部門
  void selectDepartment(String department) {
    if (departments.contains(department)) {
      state = department;
    }
  }
}

/// 各部門排行榜數據 provider
final departmentRankingsProvider = Provider.family<List<RankingEntry>, String>((
  ref,
  department,
) {
  // 模擬數據：基於不同部門生成排行
  return _generateMockRankings(department);
});

/// 生成模擬排行數據
List<RankingEntry> _generateMockRankings(String department) {
  final mockData = {
    '業務部': [
      RankingEntry(
        rank: 1,
        name: '陳大同',
        department: '業務部',
        value: 18.4,
        avatarInitials: 'CD',
        medal: 1,
      ),
      RankingEntry(
        rank: 2,
        name: '林小美',
        department: '業務部',
        value: 16.2,
        avatarInitials: 'LX',
        medal: 2,
      ),
      RankingEntry(
        rank: 3,
        name: '王小明',
        department: '業務部',
        value: 14.8,
        avatarInitials: 'WX',
        medal: 3,
        isCurrentUser: true,
      ),
      RankingEntry(
        rank: 4,
        name: '孫志偉',
        department: '業務部',
        value: 12.1,
        avatarInitials: 'SZ',
      ),
      RankingEntry(
        rank: 5,
        name: '黃美琪',
        department: '業務部',
        value: 11.3,
        avatarInitials: 'HM',
      ),
    ],
    '研發部': [
      RankingEntry(
        rank: 1,
        name: '李騰宇',
        department: '研發部',
        value: 128.5,
        avatarInitials: 'LT',
        medal: 1,
      ),
      RankingEntry(
        rank: 2,
        name: '王小明',
        department: '研發部',
        value: 115.2,
        avatarInitials: 'WX',
        medal: 2,
        isCurrentUser: true,
      ),
      RankingEntry(
        rank: 3,
        name: '張三豐',
        department: '研發部',
        value: 102.8,
        avatarInitials: 'ZS',
        medal: 3,
      ),
    ],
    '人資部': [
      RankingEntry(
        rank: 1,
        name: '劉詩語',
        department: '人資部',
        value: 245.0,
        avatarInitials: 'LS',
        medal: 1,
      ),
      RankingEntry(
        rank: 2,
        name: '王小明',
        department: '人資部',
        value: 198.3,
        avatarInitials: 'WX',
        medal: 2,
        isCurrentUser: true,
      ),
      RankingEntry(
        rank: 3,
        name: '陳美玲',
        department: '人資部',
        value: 175.6,
        avatarInitials: 'CM',
        medal: 3,
      ),
    ],
    '行銷部': [
      RankingEntry(
        rank: 1,
        name: '郭曉曼',
        department: '行銷部',
        value: 8.5,
        avatarInitials: 'GX',
        medal: 1,
      ),
      RankingEntry(
        rank: 2,
        name: '王小明',
        department: '行銷部',
        value: 6.2,
        avatarInitials: 'WX',
        medal: 2,
        isCurrentUser: true,
      ),
      RankingEntry(
        rank: 3,
        name: '余品樂',
        department: '行銷部',
        value: 5.1,
        avatarInitials: 'YP',
        medal: 3,
      ),
    ],
    '物流部': [
      RankingEntry(
        rank: 1,
        name: '保安東',
        department: '物流部',
        value: 32.6,
        avatarInitials: 'BA',
        medal: 1,
      ),
      RankingEntry(
        rank: 2,
        name: '王小明',
        department: '物流部',
        value: 28.4,
        avatarInitials: 'WX',
        medal: 2,
        isCurrentUser: true,
      ),
      RankingEntry(
        rank: 3,
        name: '黎家樂',
        department: '物流部',
        value: 25.7,
        avatarInitials: 'LJ',
        medal: 3,
      ),
    ],
  };

  return mockData[department] ?? [];
}

/// 當前用戶在選定部門的排名 provider
final currentUserRankingProvider = Provider<RankingEntry?>((ref) {
  final department = ref.watch(selectedDepartmentProvider);
  final rankings = ref.watch(departmentRankingsProvider(department));
  return rankings.firstWhere(
    (entry) => entry.isCurrentUser,
    orElse: () => RankingEntry(
      rank: 0,
      name: '未知',
      department: department,
      value: 0.0,
      avatarInitials: '？',
    ),
  );
});
