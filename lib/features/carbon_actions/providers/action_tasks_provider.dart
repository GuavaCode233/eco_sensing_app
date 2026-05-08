import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/action_task.dart';

/// 所有可執行的減碳任務列表
final availableActionTasksProvider = Provider<List<ActionTask>>((ref) {
  return [
    // 任務 1: 商務差旅
    ActionTask(
      id: 1,
      icon: 'flight_takeoff',
      title: '商務差旅',
      description: '記錄和上傳商務差旅相關單據',
      explanation: '通過掃描或上傳差旅相關單據（如機票、高鐵票、飛行里程等），系統將自動計算相應的碳排放量，並實時更新您的碳足跡。',
      exp: 50,
      coins: 30,
      isNavigable: true,
      navigationRoute: '/scan',
    ),
    // 任務 2: 電梯搭乘
    ActionTask(
      id: 2,
      icon: 'elevator',
      title: '電梯搭乘',
      description: '記錄每日搭乘電梯次數',
      explanation: '通過記錄日常搭乘電梯的次數，系統將基於樓層高度計算相應的碳排放數據。此功能正在開發中，敬請期待。',
      exp: 15,
      coins: 8,
      isNavigable: false,
      navigationRoute: null,
    ),
    // 任務 3: 辦公室廢棄物
    ActionTask(
      id: 3,
      icon: 'delete_outline',
      title: '辦公室廢棄物',
      description: '上傳辦公室廢棄物相關文件和統計數據',
      explanation: '上傳辦公室廢棄物的重量、類別等信息，系統將自動計算對應的碳排放量。此功能正在開發中，敬請期待。',
      exp: 40,
      coins: 25,
      isNavigable: false,
      navigationRoute: null,
    ),
    // 任務 4: 餐飲碳排
    ActionTask(
      id: 4,
      icon: 'restaurant',
      title: '餐飲碳排',
      description: '上傳餐飲相關單據和菜品信息',
      explanation: '通過上傳餐飲單據和菜品照片，系統將基於食物類別和份量估算碳排放量。幫助您瞭解飲食習慣對碳足跡的影響。',
      exp: 35,
      coins: 20,
      isNavigable: true,
      navigationRoute: '/scan',
    ),
  ];
});
