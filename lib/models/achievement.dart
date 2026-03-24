/// 成就模型
class Achievement {
  final int id;
  final String icon;
  final String title;
  final String description;
  final bool earned; // 是否已獲得
  final bool displayed; // 是否展示在檔案上

  Achievement({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
    required this.earned,
    required this.displayed,
  });

  /// 從 JSON 創建實例
  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as int,
      icon: json['icon'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      earned: json['earned'] as bool,
      displayed: json['displayed'] as bool,
    );
  }

  /// 轉換為 JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'icon': icon,
    'title': title,
    'description': description,
    'earned': earned,
    'displayed': displayed,
  };

  /// 複製成就並修改特定屬性
  Achievement copyWith({
    int? id,
    String? icon,
    String? title,
    String? description,
    bool? earned,
    bool? displayed,
  }) {
    return Achievement(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      title: title ?? this.title,
      description: description ?? this.description,
      earned: earned ?? this.earned,
      displayed: displayed ?? this.displayed,
    );
  }
}
