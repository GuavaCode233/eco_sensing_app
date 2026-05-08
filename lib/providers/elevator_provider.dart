import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'current_user_provider.dart';

/// 電梯碳排 provider

class ElevatorState {
  final int? entryFloor;
  ElevatorState({this.entryFloor});
}

class ElevatorNotifier extends Notifier<ElevatorState> {
  @override
  ElevatorState build() {
    return ElevatorState(entryFloor: null);
  }

  /// 接收到 NFC 掃描事件，記錄進入的樓層
  void recordNfcScan(int currentScannedFloor) {
    if (state.entryFloor == null) {
      // 第一次掃描，記錄進入的樓層
      state = ElevatorState(entryFloor: currentScannedFloor);
    } else {
      // 已經有進入樓層，這次掃描是離開，計算碳排並重置狀態
      int floorsTraveled = (currentScannedFloor - state.entryFloor!).abs();

      // TODO: 商業邏輯：計算電梯使用碳排，並給予獎勵
      if (floorsTraveled > 0) {
        ref.read(currentUserProvider.notifier).addRewards(exp: 10, coins: 5);
      }
      
      // 重製狀態
      state = ElevatorState(entryFloor: null);
    }
  }
}

final elevatorProvider = NotifierProvider<ElevatorNotifier, ElevatorState>(() {
  return ElevatorNotifier();
});
