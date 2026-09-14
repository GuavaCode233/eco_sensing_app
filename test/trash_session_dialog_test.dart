import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eco_sensing_app/features/carbon_actions/data/trash_session_repository.dart';
import 'package:eco_sensing_app/features/carbon_actions/presentation/employee/scan_screen/widgets/trash_session_dialog.dart';

class FakeTrashRepository implements TrashSessionRepository {
  int creates = 0;
  int cancellations = 0;
  final watches = <StreamController<Map<String, dynamic>>>[];
  Completer<Map<String, dynamic>>? pendingCreate;

  @override
  Future<Map<String, dynamic>> create() async {
    creates++;
    return pendingCreate != null
        ? pendingCreate!.future
        : {'id': 'session-1', 'status': 'waiting'};
  }

  @override
  Stream<Map<String, dynamic>> watch(String id) {
    expect(id, 'session-1');
    final controller = StreamController<Map<String, dynamic>>(
      onCancel: () async {
        cancellations++;
      },
    );
    watches.add(controller);
    return controller.stream;
  }

  void emit(String status, {String id = 'session-1'}) {
    watches.last.add({
      'id': id,
      'status': status,
      'trash_type': 'PET',
      'weight': 32.5,
      'carbon': 0.083,
    });
  }
}

Future<void> showSession(WidgetTester tester, FakeTrashRepository repo) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: TextButton(
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => TrashSessionDialog(repository: repo),
              ),
              child: const Text('start'),
            ),
          );
        },
      ),
    ),
  );
  await tester.tap(find.text('start'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  testWidgets('small screen and large text fit every status', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final repo = FakeTrashRepository();
    await showSession(tester, repo);
    for (final status in [
      'waiting',
      'preparing',
      'ready',
      'recognizing',
      'uploading',
      'calculating',
      'completed',
      'failed',
    ]) {
      repo.emit(status);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: status);
      if (status == 'failed') {
        expect(find.byKey(const ValueKey('trash-step-4')), findsNothing);
        expect(find.text('處理失敗'), findsOneWidget);
      } else {
        expect(find.byKey(const ValueKey('trash-step-4')), findsOneWidget);
      }
    }
  });

  testWidgets(
    'renders only this session, all statuses and exact result values',
    (tester) async {
      final repo = FakeTrashRepository();
      await showSession(tester, repo);
      expect(repo.creates, 1);
      expect(find.text('正在連線垃圾桶...'), findsOneWidget);
      repo.emit('completed', id: 'other-session');
      await tester.pump();
      expect(find.text('分析完成'), findsNothing);
      for (final entry in {
        'preparing': '垃圾桶準備中...',
        'ready': '請投入垃圾',
        'recognizing': '正在辨識垃圾...',
        'uploading': '正在傳送感測資料...',
        'calculating': '正在計算重量與碳排...',
        'failed': '處理失敗',
        'completed': '分析完成',
      }.entries) {
        repo.emit(entry.key);
        await tester.pump();
        expect(find.text(entry.value), findsOneWidget);
      }
      expect(find.text('垃圾類型：PET'), findsOneWidget);
      expect(find.text('重量：32.5 g'), findsOneWidget);
      expect(find.text('碳排：0.083 kgCO₂e'), findsOneWidget);
      await tester.tap(find.text('關閉'));
      await tester.pumpAndSettle();
      expect(repo.cancellations, 1);
    },
  );

  testWidgets(
    'reconnects existing session without inserting again; back cancels',
    (tester) async {
      final repo = FakeTrashRepository();
      await showSession(tester, repo);
      repo.watches.last.addError(StateError('offline'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.text('重新連線'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(repo.creates, 1);
      expect(repo.cancellations, 1);
      expect(repo.watches.length, 2);
      repo.emit('calculating');
      await tester.pump();
      expect(find.text('即時連線中斷，請重新連線。'), findsNothing);
      final context = tester.element(find.byType(TrashSessionDialog));
      Navigator.of(context).pop();
      await tester.pumpAndSettle();
      expect(repo.cancellations, 2);
    },
  );

  testWidgets('leaving during insert never starts a late subscription', (
    tester,
  ) async {
    final repo = FakeTrashRepository()..pendingCreate = Completer();
    await showSession(tester, repo);
    await tester.tap(find.text('關閉'));
    await tester.pumpAndSettle();
    repo.pendingCreate!.complete({'id': 'session-1', 'status': 'waiting'});
    await tester.pump();
    expect(repo.watches, isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'insert failure is visible and does not subscribe or auto-retry',
    (tester) async {
      final repo = FakeTrashRepository()..pendingCreate = Completer();
      await showSession(tester, repo);
      repo.pendingCreate!.completeError(StateError('RLS denied'));
      await tester.pump();
      expect(find.text('無法建立垃圾桶連線，請確認設定與網路後再試。'), findsOneWidget);
      expect(repo.creates, 1);
      expect(repo.watches, isEmpty);
      await tester.tap(find.text('關閉'));
      await tester.pumpAndSettle();
    },
  );
}
