import 'package:shared_preferences/shared_preferences.dart';

/// 憑證儲存。
///
/// A1 範圍：Refresh Token 暫存於 `SharedPreferences`；Access Token 僅存於
/// 記憶體、不落地。A2（§3.2）將把 Refresh Token 改存 `flutter_secure_storage`，
/// 屆時只需替換本檔的儲存後端，呼叫端介面不變。
class AuthStorage {
  const AuthStorage._();

  static const _refreshTokenKey = 'app_refresh_token';

  static String? _accessToken;

  static String? get accessToken => _accessToken;

  static Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessToken = accessToken;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  /// 「已登入」= 持有 Refresh Token。有效性判定權在後端（§3.4），
  /// 此處僅作在場判斷，非過期驗證。
  static Future<bool> isLoggedIn() async {
    final refreshToken = await getRefreshToken();
    return refreshToken != null && refreshToken.isNotEmpty;
  }

  static Future<void> logout() async {
    _accessToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_refreshTokenKey);
  }
}
