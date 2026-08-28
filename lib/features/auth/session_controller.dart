import 'package:flutter_riverpod/legacy.dart';

/// 全域「被迫登出」訊號（§3.4 換發失敗分支）。
///
/// [ApiClient] 深藏在資料層、沒有 BuildContext，無法自行導頁；
/// 401 重放時若換發也被拒絕，改為遞增此計數器，由 App 根層 `ref.listen`
/// 偵測「又發生一次」並導向登入頁。
final forcedLogoutProvider = StateProvider<int>((ref) => 0);
