import 'dart:async';

import 'package:eco_sensing_app/features/carbon_actions/data/trash_session_api.dart';

import 'package:flutter/material.dart';
import 'package:eco_sensing_app/features/carbon_actions/data/trash_session_repository.dart';

/// 此頁擁有單筆 session 的訂閱，關閉／返回時一併取消。
class TrashSessionDialog extends StatefulWidget {
  const TrashSessionDialog({super.key, required this.repository});

  final TrashSessionRepository repository;

  @override
  State<TrashSessionDialog> createState() => _TrashSessionDialogState();
}

class _TrashSessionDialogState extends State<TrashSessionDialog> {
  StreamSubscription<Map<String, dynamic>>? _subscription;
  Map<String, dynamic>? _row;
  String? _error;
  bool _reconnecting = false;
  int _watchGeneration = 0;

  @override
  void initState() {
    super.initState();
    unawaited(_create());
  }

  Future<void> _create() async {
    try {
      final row = await widget.repository.create();
      if (!mounted) return;
      if (row['id'] == null || row['id'].toString().isEmpty) {
        throw StateError('伺服器未回傳 session ID');
      }
      setState(() => _row = row);
      await _watch();
    } catch (error) {
      if (!mounted) return;
      debugPrint('Trash session creation failed: $error');
      setState(
        () => _error = error is TrashSessionApiException
            ? error.message
            : '無法建立垃圾桶連線，請確認設定與網路後再試。',
      );
    }
  }

  Future<void> _watch() async {
    final generation = ++_watchGeneration;
    setState(() => _reconnecting = true);
    await _subscription?.cancel();
    if (!mounted || generation != _watchGeneration) return;
    _subscription = widget.repository
        .watch(_row!['id'].toString())
        .listen(
          (row) {
            if (!mounted ||
                generation != _watchGeneration ||
                row['id']?.toString() != _row!['id'].toString()) {
              return;
            }
            setState(() {
              _row = row;
              _error = null;
              _reconnecting = false;
            });
          },
          onError: (Object error) {
            if (!mounted || generation != _watchGeneration) return;
            debugPrint('Trash session realtime failed: $error');
            setState(() {
              _error = '即時連線中斷，請重新連線。';
              _reconnecting = false;
            });
          },
        );
  }

  @override
  void dispose() {
    _watchGeneration++;
    unawaited(_subscription?.cancel());
    super.dispose();
  }

  String get _statusText => switch (_row?['status']) {
    null => _error == null ? '模擬掃描成功，正在建立連線...' : '連線建立失敗',
    'waiting' => '正在連線垃圾桶...',
    'opened' => '垃圾桶已開啟',
    'collecting' => '正在收集垃圾資料...',
    'processing' => '正在分析垃圾...',
    'completed' => '分析完成',
    'failed' => '處理失敗',
    _ => '收到未知狀態，請稍後再試',
  };

  @override
  Widget build(BuildContext context) {
    final completed = _row?['status'] == 'completed';
    final failed = _row?['status'] == 'failed';
    return AlertDialog(
      title: const Text('智慧垃圾桶'),
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(_statusText),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            if (_row != null)
              TextButton(
                onPressed: _reconnecting ? null : _watch,
                child: const Text('重新連線'),
              ),
          ],
          if (_error == null && !completed && !failed) ...[
            const SizedBox(height: 16),
            const Center(child: CircularProgressIndicator()),
          ],
          if (_row != null) ...[
            const SizedBox(height: 16),
            SelectableText(
              'Session ID：${_row!['id']}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          if (completed) ...[
            const SizedBox(height: 16),
            Text('垃圾類型：${_row!['trash_type'] ?? '尚未提供'}'),
            Text('重量：${_row!['weight'] ?? '尚未提供'}'),
            Text('碳排：${_row!['carbon'] ?? '尚未提供'}'),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('關閉'),
        ),
      ],
    );
  }
}
