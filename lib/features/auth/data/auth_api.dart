import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:eco_sensing_app/core/config/app_config.dart';

/// `POST /api/auth/login` 成功回應。
/// 對應 docs/Eco-Sensing_App_驗證機制_開發參考.md §4.2。
class AuthResult {
  const AuthResult({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  final String accessToken;
  final String refreshToken;

  /// Access Token 效期（秒）。僅供 UX 預判，實際過期以後端回應的 401 為準（§3.4）。
  final int expiresIn;
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AuthApi {
  const AuthApi();

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('${AppConfig.apiBaseUrl}/api/auth/login');

    final http.Response response;
    try {
      response = await http.post(
        uri,
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
    } catch (_) {
      throw const AuthException('無法連線到伺服器，請確認網路連線後再試');
    }

    final Map<String, dynamic> body = response.body.isEmpty
        ? const {}
        : jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return AuthResult(
        accessToken: body['access_token'] as String,
        refreshToken: body['refresh_token'] as String,
        expiresIn: body['expires_in'] as int,
      );
    }

    // 帳密錯誤（帳號不存在／未設密碼／密碼不符）後端統一回同一訊息，不洩漏帳號是否存在。
    if (response.statusCode == 401) {
      throw const AuthException('帳號或密碼錯誤');
    }

    throw AuthException('登入失敗，請稍後再試（${response.statusCode}）');
  }
}
