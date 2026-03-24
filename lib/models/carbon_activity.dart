/// 減碳活動/任務模型
class CarbonActivity {
  final int id;
  final String icon;
  final String category;
  final String title;
  final String description;
  final int exp;
  final int coins;
  final double co2; // 減碳量（公斤）
  final String difficulty; // 簡單、中等、困難

  CarbonActivity({
    required this.id,
    required this.icon,
    required this.category,
    required this.title,
    required this.description,
    required this.exp,
    required this.coins,
    required this.co2,
    required this.difficulty,
  });

  /// 從 JSON 創建實例
  factory CarbonActivity.fromJson(Map<String, dynamic> json) {
    return CarbonActivity(
      id: json['id'] as int,
      icon: json['icon'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      exp: json['exp'] as int,
      coins: json['coins'] as int,
      co2: (json['co2'] as num).toDouble(),
      difficulty: json['difficulty'] as String,
    );
  }

  /// 轉換為 JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'icon': icon,
    'category': category,
    'title': title,
    'description': description,
    'exp': exp,
    'coins': coins,
    'co2': co2,
    'difficulty': difficulty,
  };
}
