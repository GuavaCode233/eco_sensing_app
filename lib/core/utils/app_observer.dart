import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// 建立一個全局的觀察者
final class AppObserver extends ProviderObserver {
  // 當任何一個 Provider 的狀態發生「改變」時，就會自動觸發這裡！
  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    log(
      '🔄 [狀態改變] ${context.provider.name ?? context.provider.runtimeType}\n'
      '├─ 舊狀態: $previousValue\n'
      '└─ 新狀態: $newValue',
      name: 'Riverpod',
    );
  }

  // 當某個 Provider 第一次被初始化的時候
  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    log(
      '🌱 [初始化] ${context.provider.name ?? context.provider.runtimeType}: $value',
      name: 'Riverpod',
    );
  }
}
