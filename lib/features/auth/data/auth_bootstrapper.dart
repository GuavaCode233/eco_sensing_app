import 'package:eco_sensing_app/core/utils/auth_storage.dart';

import 'auth_api.dart';

/// 冷啟動判定結果（§3.3）。
enum BootstrapStatus {
  /// 沒有 Refresh Token，或已被後端明確拒絕（過期/撤銷）——導向登入頁。
  loggedOut,

  /// 持有 Refresh Token 且成功換發新 Access Token——直接進主畫面。
  loggedIn,

  /// 持有 Refresh Token，但換發時無法連線——先進 App 看快取，
  /// 不卡在登入頁；待有網路時由後續請求觸發的 401 攔截器補換（§3.4）。
  loggedInOffline,
}

/// 冷啟動流程：讀 Refresh Token → 背景靜默換發 Access Token。
class AuthBootstrapper {
  const AuthBootstrapper({this.authApi = const AuthApi()});

  final AuthApi authApi;

  Future<BootstrapStatus> run() async {
    final refreshToken = await AuthStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return BootstrapStatus.loggedOut;
    }

    try {
      final result = await authApi.refresh(refreshToken: refreshToken);
      AuthStorage.saveAccessToken(result.accessToken);
      return BootstrapStatus.loggedIn;
    } on AuthNetworkException {
      return BootstrapStatus.loggedInOffline;
    } on AuthException {
      await AuthStorage.logout();
      return BootstrapStatus.loggedOut;
    }
  }
}
