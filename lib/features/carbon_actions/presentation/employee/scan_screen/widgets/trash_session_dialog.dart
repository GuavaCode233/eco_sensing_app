import 'dart:async';

import 'trash_progress_stepper.dart';

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
    'preparing' => '垃圾桶準備中...',
    'ready' => '準備完成，請投入垃圾',
    'recognizing' => '正在辨識垃圾...',
    'uploading' => '正在傳送感測資料...',
    'calculating' => '正在計算重量與碳排...',
    'completed' => '分析完成',
    'failed' => '處理失敗',
    _ => '收到未知狀態，請稍後再試',
  };

  @override
  Widget build(BuildContext context) {
    final completed = _row?['status'] == 'completed';
    final failed = _row?['status'] == 'failed';
    final ready = _row?['status'] == 'ready';
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return AlertDialog(
      title: const Text('智慧垃圾桶'),
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_row != null && !failed) ...[
            TrashProgressStepper(status: _row!['status']?.toString() ?? ''),
            const SizedBox(height: 24),
          ],
          Semantics(
            liveRegion: true,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: failed
                    ? colors.errorContainer
                    : ready || completed
                    ? colors.primaryContainer
                    : colors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (ready || completed || failed) ...[
                    Icon(
                      failed
                          ? Icons.error_outline
                          : completed
                          ? Icons.check_circle_outline
                          : Icons.delete_outline,
                      size: 32,
                      color: failed
                          ? colors.onErrorContainer
                          : colors.onPrimaryContainer,
                    ),
                    const SizedBox(height: 8),
                  ],
                  Text(
                    ready ? '準備完成' : _statusText,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: failed
                          ? colors.onErrorContainer
                          : ready || completed
                          ? colors.onPrimaryContainer
                          : colors.onSurface,
                    ),
                  ),
                  if (ready) ...[
                    const SizedBox(height: 8),
                    Text(
                      '請投入垃圾',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: colors.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  if (failed) ...[
                    const SizedBox(height: 8),
                    Text(
                      '垃圾桶處理過程發生錯誤，\n請稍後重新掃描。',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onErrorContainer,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
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
          if (completed) ...[
            const SizedBox(height: 16),
            Text('垃圾類型：${_row!['trash_type'] ?? '尚未提供'}'),
            Text(
              '重量：${_row!['weight'] == null ? '尚未提供' : '${_row!["weight"]} g'}',
            ),
            Text(
              '碳排：${_row!['carbon'] == null ? '尚未提供' : '${_row!["carbon"]} kgCO₂e'}',
            ),
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
