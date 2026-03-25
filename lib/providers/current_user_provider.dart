import 'package:eco_sensing_app/providers/game_config_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';

class CurrentUserProvider extends Notifier<UserProfile> {
  @override
  UserProfile build() {
    // 初始化用戶資料，未來可改為從後端 API 獲取
    return UserProfile(
      displayName: '王小明',
      name: '王小明',
      account: 'wangxm',
      email: 'wangxm@example.com',
      phone: '0912-345-678',
      company: 'TanAI Green Solutions',
      department: '業務部',
      level: 7,
      totalExp: 430,
      tokens: 1250,
    );
  }

  void updateProfile({
    String? displayName,
    String? email,
    String? phone,
    String? account,
  }) {
    state = state.copyWith(
      displayName: displayName,
      email: email,
      phone: phone,
      account: account,
    );
  }

  /// 增加經驗值和貨幣
  void addRewards({required int exp, required int coins}) {
    final expPerLevel = ref.read(expPerLevelProvider);

    int newTotalExp = state.totalExp + exp;
    int newLevel = (newTotalExp ~/ expPerLevel) + 1; // 每 expPerLevel 升一級
    state = state.copyWith(totalExp: newTotalExp, level: newLevel);
  }

  /// 扣除經驗值和貨幣
  void deductRewards({required int exp, required int coins}) {
    final expPerLevel = ref.read(expPerLevelProvider);
    int newTotalExp = (state.totalExp - exp).clamp(0, state.totalExp);
    int newLevel = (newTotalExp ~/ expPerLevel) + 1;
    state = state.copyWith(
      totalExp: newTotalExp,
      level: newLevel,
      tokens: (state.tokens - coins).clamp(0, state.tokens),
    );
  }

  /// 重置用戶為初始狀態（測試用）
  void resetUser() {
    state = UserProfile(
      displayName: '王小明',
      name: '王小明',
      account: 'wangxm',
      email: 'wangxm@example.com',
      phone: '0912-345-678',
      company: 'TanAI Green Solutions',
      department: '業務部',
      level: 7,
      totalExp: 1250,
      tokens: 1250,
    );
  }
}

final currentUserProvider = NotifierProvider<CurrentUserProvider, UserProfile>(
  () => CurrentUserProvider(),
);
