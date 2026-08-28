import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:eco_sensing_app/features/auth/session_controller.dart';
import 'api_client.dart';

/// 供各功能模組取用的共用 [ApiClient]；換發被拒絕時遞增 [forcedLogoutProvider]
/// 讓 App 根層導向登入頁（§3.4）。
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    onSessionExpired: () => ref.read(forcedLogoutProvider.notifier).state++,
  );
});
