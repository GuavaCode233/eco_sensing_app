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

/// `POST /api/auth/token/refresh` 成功回應。不含新 Refresh（§1 定案不輪換）。
class RefreshResult {
  const RefreshResult({required this.accessToken, required this.expiresIn});

  final String accessToken;
  final int expiresIn;
}

sealed class AuthApiException implements Exception {
  const AuthApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// 連線失敗（逾時、無網路等）——非後端明確拒絕，呼叫端可視情況（如冷啟動
/// 靜默續期）當作「暫時無法確認」而非「登入已失效」處理（§3.3）。
class AuthNetworkException extends AuthApiException {
  const AuthNetworkException() : super('無法連線到伺服器，請確認網路連線後再試');
}

/// 後端明確拒絕（401 帳密錯誤 / Refresh 失效或已撤銷等）。
class AuthException extends AuthApiException {
  const AuthException(super.message);
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
      throw const AuthNetworkException();
    }

    final body = _decodeBody(response);

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

  /// 用 Refresh Token 換發新 Access Token。401 涵蓋「不存在／已撤銷」與
  /// 「已過期」兩種情況，App 端處理方式相同（§4.2），故不細分例外類型。
  Future<RefreshResult> refresh({required String refreshToken}) async {
    final uri = Uri.parse('${AppConfig.apiBaseUrl}/api/auth/token/refresh');

    final http.Response response;
    try {
      response = await http.post(
        uri,
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
      );
    } catch (_) {
      throw const AuthNetworkException();
    }

    final body = _decodeBody(response);

    if (response.statusCode == 200) {
      return RefreshResult(
        accessToken: body['access_token'] as String,
        expiresIn: body['expires_in'] as int,
      );
    }

    if (response.statusCode == 401) {
      throw const AuthException('登入已失效，請重新登入');
    }

    throw AuthException('換發失敗，請稍後再試（${response.statusCode}）');
  }

  Map<String, dynamic> _decodeBody(http.Response response) {
    return response.body.isEmpty
        ? const {}
        : jsonDecode(response.body) as Map<String, dynamic>;
  }
}
