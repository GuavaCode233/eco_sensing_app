import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/auth/login_screen.dart';

void main() {
  runApp(
    ProviderScope(
      child: DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => const EcoSensingApp(),
      ),
    ),
  );
}

class EcoSensingApp extends StatelessWidget {
  const EcoSensingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context), // 使用 DevicePreview 的語言設定
      builder: DevicePreview.appBuilder, // 使用 DevicePreview 的 appBuilder

      title: 'Eco-Sensing 碳排AI智慧核算助理',
      // 淺色主題
      theme: ThemeData(
        // colorScheme: 主題色彩 useMaterail3: 並啟用設計風格
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF5B8FF9)),
        useMaterial3: true,
      ),
      // 深色主題
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF5B8FF9),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system, // 跟隨系統主題
      home: const LoginPage(),
    );
  }
}
