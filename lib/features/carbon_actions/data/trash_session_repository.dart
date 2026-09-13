import 'dart:async';

import 'trash_session_api.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:eco_sensing_app/core/config/trash_demo_config.dart';

abstract interface class TrashSessionRepository {
  Future<Map<String, dynamic>> create();
  Stream<Map<String, dynamic>> watch(String sessionId);
}

class SupabaseTrashSessionRepository implements TrashSessionRepository {
  SupabaseTrashSessionRepository({
    TrashSessionApi api = const TrashSessionApi(),
  }) : _api = api;

  final TrashSessionApi _api;
  static Future<Supabase>? _initialization;

  Future<SupabaseClient> _client() async {
    if (!TrashDemoConfig.isConfigured) {
      throw StateError('尚未設定垃圾桶連線，請完成 Demo 環境設定後重新啟動 App。');
    }
    _initialization ??= Supabase.initialize(
      url: TrashDemoConfig.supabaseUrl,
      publishableKey: TrashDemoConfig.supabaseKey,
      authOptions: const FlutterAuthClientOptions(
        autoRefreshToken: false,
        persistSession: false,
        detectSessionInUri: false,
      ),
    );
    try {
      return (await _initialization!).client;
    } catch (_) {
      _initialization = null;
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> create() => _api.create();

  @override
  Stream<Map<String, dynamic>> watch(String sessionId) {
    late StreamController<Map<String, dynamic>> controller;
    RealtimeChannel? channel;
    SupabaseClient? client;
    var cancelled = false;
    var revision = 0;

    Future<void> refresh() async {
      final beforeRead = revision;
      try {
        final row = await client!
            .from('trash_sessions')
            .select()
            .eq('id', sessionId)
            .single();
        // 更新事件優先，避免较舊的 SELECT 回應覆蓋新結果。
        if (!cancelled && beforeRead == revision) controller.add(row);
      } catch (error, stack) {
        if (!cancelled) controller.addError(error, stack);
      }
    }

    Future<void> start() async {
      try {
        client = await _client();
        if (cancelled) return;
        channel = client!.channel('trash-session-$sessionId');
        channel!
            .onPostgresChanges(
              event: PostgresChangeEvent.update,
              schema: 'public',
              table: 'trash_sessions',
              filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'id',
                value: sessionId,
              ),
              callback: (payload) {
                if (cancelled ||
                    payload.newRecord['id']?.toString() != sessionId) {
                  return;
                }
                revision++;
                controller.add(payload.newRecord);
              },
            )
            .subscribe((status, error) {
              if (cancelled) return;
              if (status == RealtimeSubscribeStatus.subscribed) {
                // 初次訂閱及重連都補讀，補齊離線／訂閱空窗的狀態。
                unawaited(refresh());
              } else if (status == RealtimeSubscribeStatus.channelError ||
                  status == RealtimeSubscribeStatus.timedOut ||
                  status == RealtimeSubscribeStatus.closed) {
                controller.addError(StateError('即時連線中斷，請重新連線。'));
              }
            });
      } catch (error, stack) {
        if (!cancelled) controller.addError(error, stack);
      }
    }

    controller = StreamController<Map<String, dynamic>>(
      onListen: () => unawaited(start()),
      onCancel: () async {
        cancelled = true;
        if (channel != null) await client!.removeChannel(channel!);
      },
    );
    return controller.stream;
  }
}
