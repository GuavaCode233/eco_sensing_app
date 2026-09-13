import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:eco_sensing_app/core/config/app_config.dart';

class TrashSessionApiException implements Exception {
  const TrashSessionApiException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// 垃圾桶寫入由後端處理；讀取／Realtime 仍使用 Supabase。
class TrashSessionApi {
  const TrashSessionApi({this.client, this.baseUrl = AppConfig.apiBaseUrl});

  final http.Client? client;
  final String baseUrl;

  Future<Map<String, dynamic>> create() async {
    final uri = Uri.parse(
      '${baseUrl.replaceFirst(RegExp(r'/+$'), '')}/trash/session',
    );
    final http.Response response;
    try {
      response =
          await (client != null
                  ? client!.post(
                      uri,
                      headers: const {'accept': 'application/json'},
                    )
                  : http.post(
                      uri,
                      headers: const {'accept': 'application/json'},
                    ))
              .timeout(const Duration(seconds: 30));
    } on TimeoutException {
      throw const TrashSessionApiException('建立連線逾時，請稍後確認垃圾桶狀態。');
    } on http.ClientException {
      throw const TrashSessionApiException('無法連線到伺服器，請確認網路後再試。');
    }

    // 不自動重送 POST：回應遺失時後端仍可能已建立 session。
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw TrashSessionApiException('建立垃圾桶連線失敗（${response.statusCode}）');
    }
    final dynamic body;
    try {
      body = jsonDecode(response.body);
    } on FormatException {
      throw const TrashSessionApiException('伺服器回傳格式不正確。');
    }
    if (body is! Map<String, dynamic> ||
        body['success'] != true ||
        body['session_id'] is! String ||
        (body['session_id'] as String).isEmpty ||
        body['status'] is! String) {
      throw const TrashSessionApiException('伺服器未回傳有效的垃圾桶 session。');
    }
    return {...body, 'id': body['session_id']};
  }
}
