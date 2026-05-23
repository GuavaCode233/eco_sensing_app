/// 可執行的減碳任務模型
class ActionTask {
  final int id;
  final String icon; // Material icon name
  final String title; // 任務名稱
  final String description; // 任務描述
  final String explanation; // 任務說明（pop-up用）
  final String category; // 任務類別：交通、廢棄物、能源、飲食、辦公
  final int exp; // 可獲得經驗值
  final int coins; // 可獲得貨幣
  final double co2ReductionKg; // 完成後預估減碳量 (kg CO₂)
  final bool isNavigable; // 是否可點擊進入（有動作）
  final String? navigationRoute; // 導向的路由

  ActionTask({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
    required this.explanation,
    required this.category,
    required this.exp,
    required this.coins,
    required this.co2ReductionKg,
    required this.isNavigable,
    this.navigationRoute,
  });

  /// 從 JSON 創建實例
  factory ActionTask.fromJson(Map<String, dynamic> json) {
    return ActionTask(
      id: json['id'] as int,
      icon: json['icon'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      explanation: json['explanation'] as String,
      category: json['category'] as String,
      exp: json['exp'] as int,
      coins: json['coins'] as int,
      co2ReductionKg: (json['co2ReductionKg'] as num).toDouble(),
      isNavigable: json['isNavigable'] as bool,
      navigationRoute: json['navigationRoute'] as String?,
    );
  }

  /// 轉換為 JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'icon': icon,
    'title': title,
    'description': description,
    'explanation': explanation,
    'category': category,
    'exp': exp,
    'coins': coins,
    'co2ReductionKg': co2ReductionKg,
    'isNavigable': isNavigable,
    'navigationRoute': navigationRoute,
  };

  /// 複製任務並修改特定屬性
  ActionTask copyWith({
    int? id,
    String? icon,
    String? title,
    String? description,
    String? explanation,
    String? category,
    int? exp,
    int? coins,
    double? co2ReductionKg,
    bool? isNavigable,
    String? navigationRoute,
  }) {
    return ActionTask(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      title: title ?? this.title,
      description: description ?? this.description,
      explanation: explanation ?? this.explanation,
      category: category ?? this.category,
      exp: exp ?? this.exp,
      coins: coins ?? this.coins,
      co2ReductionKg: co2ReductionKg ?? this.co2ReductionKg,
      isNavigable: isNavigable ?? this.isNavigable,
      navigationRoute: navigationRoute ?? this.navigationRoute,
    );
  }
}
