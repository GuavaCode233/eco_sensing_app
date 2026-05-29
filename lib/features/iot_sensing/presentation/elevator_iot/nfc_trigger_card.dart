import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../providers/elelvator_iot/elevator_provider.dart';

/// NFC 觸發卡片 - 監聽電梯 NFC 掃描事件
///
/// 第一次掃描：顯示 SnackBar 提示進入樓層
/// 第二次掃描：顯示 Dialog 展示樓層差、碳排放和獎勵
class NfcTriggerCard extends ConsumerStatefulWidget {
  const NfcTriggerCard({super.key});

  @override
  ConsumerState<NfcTriggerCard> createState() => _NfcTriggerCardState();
}

class _NfcTriggerCardState extends ConsumerState<NfcTriggerCard> {
  int? _previousEntryFloor;

  @override
  void initState() {
    super.initState();
    _previousEntryFloor = null;
  }

  @override
  Widget build(BuildContext context) {
    // 監聽 elevatorProvider 的狀態變化
    final elevatorState = ref.watch(elevatorProvider);

    // 檢測狀態變化
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleElevatorStateChange(elevatorState);
    });

    return const SizedBox.shrink(); // 此元件只負責副作用，不渲染任何 UI
  }

  /// 處理電梯狀態變化
  void _handleElevatorStateChange(ElevatorState elevatorState) {
    final currentEntryFloor = elevatorState.entryFloor;

    // 第一次掃描：entryFloor 從 null → 某樓層
    if (_previousEntryFloor == null && currentEntryFloor != null) {
      _showEntrySnackBar(currentEntryFloor);
    }
    // 第二次掃描：entryFloor 從 某樓層 → null（重設狀態）
    else if (_previousEntryFloor != null && currentEntryFloor == null) {
      // 計算樓層差（假設前一個值是進入樓層）
      _showExitDialog(_previousEntryFloor!);
    }

    // 更新前一個值
    _previousEntryFloor = currentEntryFloor;
  }

  /// 顯示進入電梯的 SnackBar
  void _showEntrySnackBar(int entryFloor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '✓ 已進入電梯',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '進入樓層: $entryFloor 樓',
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            const SizedBox(height: 12),
            const Text(
              '💡 提示：抵達目標樓層時，再掃描一次 NFC',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFD4E9E2), // greenLight
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.houseGreen,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  /// 顯示離開電梯的 Dialog 卡片
  void _showExitDialog(int entryFloor) {
    // 這裡需要取得目標樓層（第二次掃描的樓層）
    // 由於架構設計，我們無法直接取得，所以使用假數據
    // 實際應該在 provider 中記錄兩個樓層值

    // 假設第二次掃描的樓層是 8
    final int exitFloor = 8;
    final int floorsTraveled = (exitFloor - entryFloor).abs();
    final double estimatedCarbon = floorsTraveled * 0.5; // kg CO₂
    const int rewardExp = 10;
    const int rewardCoins = 5;

    // 判斷上升或下降
    final String direction = exitFloor > entryFloor ? '上升' : '下降';
    final IconData directionIcon = exitFloor > entryFloor
        ? Icons.trending_up
        : Icons.trending_down;
    final Color directionColor = exitFloor > entryFloor
        ? Colors.green
        : Colors.blue;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDecorations.cardRadius),
          ),
          child: Container(
            decoration: AppDecorations.card(),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 標題
                  const Text(
                    '✓ 電梯使用完成',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.houseGreen,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 樓層資訊卡片
                  Container(
                    decoration: AppDecorations.card(
                      color: AppColors.greenLight,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // 進入樓層
                            Column(
                              children: [
                                const Text(
                                  '進入',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$entryFloor',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.houseGreen,
                                  ),
                                ),
                                const Text(
                                  '樓',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.houseGreen,
                                  ),
                                ),
                              ],
                            ),
                            // 箭頭
                            Column(
                              children: [
                                Icon(
                                  directionIcon,
                                  color: directionColor,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  direction,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: directionColor,
                                  ),
                                ),
                              ],
                            ),
                            // 離開樓層
                            Column(
                              children: [
                                const Text(
                                  '離開',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$exitFloor',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.houseGreen,
                                  ),
                                ),
                                const Text(
                                  '樓',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.houseGreen,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // 樓層差資訊
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          child: Text(
                            '搭乘 $floorsTraveled 層樓',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.houseGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 碳排放資訊
                  Container(
                    decoration: AppDecorations.tintedSurface(AppColors.red),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Icon(Icons.cloud, color: AppColors.red, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '預估碳排放量',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$estimatedCarbon kg CO₂',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 獎勵資訊 Band
                  Container(
                    decoration: AppDecorations.rewardsBand(),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '🎉 您獲得獎勵！',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.houseGreen,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  // EXP
                                  Expanded(
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: AppColors.houseGreen,
                                          size: 24,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '+$rewardExp EXP',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.houseGreen,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Coins
                                  Expanded(
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.monetization_on,
                                          color: AppColors.houseGreen,
                                          size: 24,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '+$rewardCoins 碳幣',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.houseGreen,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 確認按鈕
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greenAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDecorations.cardRadius,
                          ),
                        ),
                      ),
                      child: const Text(
                        '確認',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
