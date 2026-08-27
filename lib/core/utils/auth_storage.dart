import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 憑證儲存。
///
/// Refresh Token 存 `flutter_secure_storage`（Android Keystore / iOS
/// Keychain，§3.2）；Access Token 僅存於記憶體、不落地。
class AuthStorage {
  const AuthStorage._();

  static const _refreshTokenKey = 'app_refresh_token';
  static const _secureStorage = FlutterSecureStorage();

  static String? _accessToken;

  static String? get accessToken => _accessToken;

  static Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessToken = accessToken;
    await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
  }

  /// 冷啟動 / 401 續期換發成功後更新 Access Token；Refresh 不變（不輪換）。
  static void saveAccessToken(String accessToken) {
    _accessToken = accessToken;
  }

  static Future<String?> getRefreshToken() {
    return _secureStorage.read(key: _refreshTokenKey);
  }

  /// 「已登入」= 持有 Refresh Token。有效性判定權在後端（§3.4），
  /// 此處僅作在場判斷，非過期驗證。
  static Future<bool> isLoggedIn() async {
    final refreshToken = await getRefreshToken();
    return refreshToken != null && refreshToken.isNotEmpty;
  }

  static Future<void> logout() async {
    _accessToken = null;
    await _secureStorage.delete(key: _refreshTokenKey);
    // A1 階段曾暫存於 SharedPreferences；順手清除舊裝置上的殘留值。
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_refreshTokenKey);
  }
}
