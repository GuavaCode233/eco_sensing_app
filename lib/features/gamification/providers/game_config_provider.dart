import 'package:flutter_riverpod/flutter_riverpod.dart';

// 提供「每級所需 EXP」的設定值
// 未來這裡可以改成 FutureProvider 去跟後端 API 要資料
final expPerLevelProvider = Provider<int>((ref) {
  return 500; // 目前先寫死 500，未來可動態改變
});
