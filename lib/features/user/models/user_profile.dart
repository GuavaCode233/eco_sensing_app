/// 用戶資料模型
class UserProfile {
  final String displayName; // 顯示名稱
  final String name; // 真實名稱
  final String account; // 帳號
  final String email;
  final String phone;
  final String company; // 所屬公司（鎖定，不可修改）
  final String department; // 所屬部門（鎖定，不可修改）
  final int level; // 目前等級
  final int totalExp; // 總經驗值
  final int tokens; // 已獲得獎勵貨幣

  UserProfile({
    required this.displayName,
    required this.name,
    required this.account,
    required this.email,
    required this.phone,
    required this.company,
    required this.department,
    required this.level,
    required this.totalExp,
    required this.tokens,
  });

  /// 從 JSON 創建實例
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      displayName: json['displayName'] as String,
      name: json['name'] as String,
      account: json['account'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      company: json['company'] as String,
      department: json['department'] as String,
      level: json['level'] as int,
      totalExp: json['totalExp'] as int,
      tokens: json['tokens'] as int,
    );
  }

  /// 轉換為 JSON
  Map<String, dynamic> toJson() => {
    'displayName': displayName,
    'name': name,
    'account': account,
    'email': email,
    'phone': phone,
    'company': company,
    'department': department,
    'level': level,
    'totalExp': totalExp,
    'tokens': tokens,
  };

  /// 複製用戶資料並修改特定屬性
  UserProfile copyWith({
    String? displayName,
    String? name,
    String? account,
    String? email,
    String? phone,
    String? company,
    String? department,
    int? level,
    int? totalExp,
    int? tokens,
  }) {
    return UserProfile(
      displayName: displayName ?? this.displayName,
      name: name ?? this.name,
      account: account ?? this.account,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      company: company ?? this.company,
      department: department ?? this.department,
      level: level ?? this.level,
      totalExp: totalExp ?? this.totalExp,
      tokens: tokens ?? this.tokens,
    );
  }
}
