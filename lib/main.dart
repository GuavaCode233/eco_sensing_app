import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/auth/login_screen.dart';
import 'core/utils/app_observer.dart';
import 'core/theme/app_theme.dart';
import 'features/user/providers/current_user_provider.dart';
import 'features/iot_sensing/providers/elelvator_iot/elevator_provider.dart';
import 'features/iot_sensing/providers/elelvator_iot/pending_nfc_provider.dart';

void main() {
  runApp(
    ProviderScope(
      observers: [AppObserver()],
      child: DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => const EcoSensingApp(),
      ),
    ),
  );
}

class EcoSensingApp extends ConsumerStatefulWidget {
  const EcoSensingApp({super.key});

  @override
  ConsumerState<EcoSensingApp> createState() => _EcoSensingAppState();
}

class _EcoSensingAppState extends ConsumerState<EcoSensingApp> {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription? _linkSubscription;
  String _nfcMessage = '尚未掃描 NFC';

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  // 電梯搭乘追蹤 NFC 模組，接收 NFC 訊號
  void _initDeepLinks() {
    // 1. 處理 App 處於關閉狀態，因為掃描 NFC 而被冷啟動 (Cold Start)
    _appLinks.getInitialLink().then((Uri? uri) {
      if (uri != null) {
        _handleNfcUri(uri);
      }
    });

    // 2. 處理 App 已經在背景運行，因為掃描 NFC 而被喚醒
    _linkSubscription = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleNfcUri(uri);
      }
    });
  }

  void _handleNfcUri(Uri uri) {
    // uri 會長這樣: https://yourdomain.com/app?counter=5
    // 我們可以把 counter 提取出來
    final counterValue = uri.queryParameters['counter'];
    if (counterValue == null) {
      return;
    }

    _nfcMessage = "成功接收 NFC 資料！\nCounter: $counterValue";

    final floor = int.tryParse(counterValue);

    final isLoggedIn = ref
        .read(currentUserProvider)
        .account
        .isNotEmpty; // 判斷是否已登入

    if (isLoggedIn) {
      // 情況 A：已經登入了！直接紀錄搭電梯
      ref.read(elevatorProvider.notifier).recordNfcScan(floor!);
    } else {
      // 情況 B：還沒登入！先把這個樓層「暫存」起來，等他登入再處理
      ref.read(pendingNfcProvider.notifier).state = floor;
      print("尚未登入，已將 NFC 動作加入待辦佇列");
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Eco-Sensing 碳排AI智慧核算助理',
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      home: const LoginPage(),
    );
  }
}
