/// 排行榜條目模型
class RankingEntry {
  final int rank;
  final String name;
  final String department;
  final double value; // 指標值（根據部門不同單位）
  final String avatarInitials; // 頭像首字母
  final int? medal; // 獎章等級：1=金、2=銀、3=銅
  final bool isCurrentUser;

  RankingEntry({
    required this.rank,
    required this.name,
    required this.department,
    required this.value,
    required this.avatarInitials,
    this.medal,
    this.isCurrentUser = false,
  });

  /// 從 JSON 創建實例
  factory RankingEntry.fromJson(Map<String, dynamic> json) {
    return RankingEntry(
      rank: json['rank'] as int,
      name: json['name'] as String,
      department: json['department'] as String,
      value: (json['value'] as num).toDouble(),
      avatarInitials: json['avatarInitials'] as String,
      medal: json['medal'] as int?,
      isCurrentUser: json['isCurrentUser'] as bool? ?? false,
    );
  }

  /// 轉換為 JSON
  Map<String, dynamic> toJson() => {
    'rank': rank,
    'name': name,
    'department': department,
    'value': value,
    'avatarInitials': avatarInitials,
    'medal': medal,
    'isCurrentUser': isCurrentUser,
  };
}
