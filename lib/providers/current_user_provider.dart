import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';

/// 當前登錄用戶資料 provider
/// 未來可改為從後端 API 獲取
final currentUserProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
      return UserProfileNotifier(
        UserProfile(
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
        ),
      );
    });

/// 用戶資料狀態管理器
class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier(super.initialState);

  /// 更新用戶基本資料
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
    int newTotalExp = state.totalExp + exp;
    int newLevel = (newTotalExp ~/ 500) + 1; // 每 500 EXP 升一級
    state = state.copyWith(
      totalExp: newTotalExp,
      level: newLevel,
      tokens: state.tokens + coins,
    );
  }

  /// 扣除經驗值和貨幣
  void deductRewards({required int exp, required int coins}) {
    int newTotalExp = (state.totalExp - exp).clamp(0, state.totalExp);
    int newLevel = (newTotalExp ~/ 500) + 1;
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
