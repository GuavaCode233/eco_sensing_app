import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:eco_sensing_app/features/carbon_actions/data/trash_session_api.dart';

void main() {
  test(
    'POST uses empty body and maps session_id for existing Realtime filter',
    () async {
      final api = TrashSessionApi(
        baseUrl: 'https://example.test/',
        client: MockClient((request) async {
          expect(request.method, 'POST');
          expect(request.url.toString(), 'https://example.test/trash/session');
          expect(request.body, isEmpty);
          return http.Response(
            jsonEncode({
              'success': true,
              'session_id': 'session-1',
              'bin_id': 'bin-1',
              'status': 'waiting',
            }),
            200,
          );
        }),
      );
      final row = await api.create();
      expect(row['id'], 'session-1');
      expect(row['bin_id'], 'bin-1');
      expect(row['status'], 'waiting');
    },
  );

  test('HTTP failures are reported without retrying POST', () async {
    var calls = 0;
    final api = TrashSessionApi(
      client: MockClient((_) async {
        calls++;
        return http.Response('{"detail":"failure"}', 500);
      }),
    );
    await expectLater(api.create(), throwsA(isA<TrashSessionApiException>()));
    expect(calls, 1);
  });

  test('rejects malformed and unsuccessful responses', () async {
    for (final body in [
      'not json',
      '{}',
      '{"success":false}',
      '{"success":true,"session_id":"","status":"waiting"}',
    ]) {
      final api = TrashSessionApi(
        client: MockClient((_) async => http.Response(body, 200)),
      );
      await expectLater(api.create(), throwsA(isA<TrashSessionApiException>()));
    }
  });
}
