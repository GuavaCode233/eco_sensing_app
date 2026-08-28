import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:eco_sensing_app/core/config/app_config.dart';
import 'package:eco_sensing_app/core/utils/auth_storage.dart';
import 'package:eco_sensing_app/features/auth/data/auth_api.dart';

/// Refresh 也被拒絕（401/403）——登入真的失效了，憑證已被清除。
/// 呼叫端 catch 到這個例外時：可先暫存尚未送出的操作內容，再導向登入頁
/// （§3.4「操作中途過期」）；本次請求本身視為失敗，不會被重放。
class SessionExpiredException implements Exception {
  const SessionExpiredException();
}

enum _RefreshOutcome { success, rejected, networkFailure }

/// 帶身份的 API 呼叫共用入口（§3.4）。
///
/// 每個歸戶請求自動帶 `Authorization: Bearer <Access>`；收到 401 時
/// （後端判定過期或無效）自動用 Refresh 換發一次並重放原請求——對呼叫端
/// 透明，這也是「操作中途過期」在常見情況下不遺失資料的原因：呼叫尚未
/// 返回，換發成功就直接補上、無感完成。
///
/// 只有換發本身也被拒絕（Refresh 已撤銷/過期）才視為登入真的失效，
/// 丟出 [SessionExpiredException] 並觸發 [onSessionExpired]；換發時單純
/// 連線失敗則不清除憑證、不強制登出，原樣拋出 [AuthNetworkException]。
class ApiClient {
  ApiClient({
    AuthApi authApi = const AuthApi(),
    http.Client? httpClient,
    this.onSessionExpired,
  }) : _authApi = authApi,
       _httpClient = httpClient ?? http.Client();

  final AuthApi _authApi;
  final http.Client _httpClient;

  /// 換發被拒絕、登入確定失效時呼叫，供 App 根層導向登入頁。
  final VoidCallback? onSessionExpired;

  Future<http.Response> get(String path) => _send('GET', path);

  Future<http.Response> post(String path, {Object? body}) =>
      _send('POST', path, body: body);

  Future<http.Response> patch(String path, {Object? body}) =>
      _send('PATCH', path, body: body);

  Future<http.Response> delete(String path) => _send('DELETE', path);

  Future<http.Response> _send(
    String method,
    String path, {
    Object? body,
    bool isRetry = false,
  }) async {
    final response = await _dispatch(method, path, body: body);

    if (response.statusCode != 401 || isRetry) {
      return response;
    }

    final outcome = await _tryRefresh();
    switch (outcome) {
      case _RefreshOutcome.success:
        return _send(method, path, body: body, isRetry: true);
      case _RefreshOutcome.rejected:
        onSessionExpired?.call();
        throw const SessionExpiredException();
      case _RefreshOutcome.networkFailure:
        throw const AuthNetworkException();
    }
  }

  Future<http.Response> _dispatch(
    String method,
    String path, {
    Object? body,
  }) async {
    final uri = Uri.parse('${AppConfig.apiBaseUrl}$path');
    final accessToken = AuthStorage.accessToken;
    final request = http.Request(method, uri)
      ..headers['Content-Type'] = 'application/json'
      ..headers.addAll(
        accessToken == null
            ? const {}
            : {'Authorization': 'Bearer $accessToken'},
      );
    if (body != null) {
      request.body = jsonEncode(body);
    }
    final streamedResponse = await _httpClient.send(request);
    return http.Response.fromStream(streamedResponse);
  }

  Future<_RefreshOutcome> _tryRefresh() async {
    final refreshToken = await AuthStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await AuthStorage.logout();
      return _RefreshOutcome.rejected;
    }

    try {
      final result = await _authApi.refresh(refreshToken: refreshToken);
      AuthStorage.saveAccessToken(result.accessToken);
      return _RefreshOutcome.success;
    } on AuthException {
      await AuthStorage.logout();
      return _RefreshOutcome.rejected;
    } on AuthNetworkException {
      return _RefreshOutcome.networkFailure;
    }
  }
}
