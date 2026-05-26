// 檔案路徑: lib/features/user/presentation/employee/widgets/employee_qr_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';
import 'package:eco_sensing_app/core/theme/app_decorations.dart';
import '../../../../../user/providers/current_user_provider.dart';

class QRCodePopup extends ConsumerWidget {
  const QRCodePopup({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 停用點擊背景關閉
      builder: (context) => const QRCodePopup(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 從 Riverpod 取得目前使用者的 UUID
    // final userProfile = ref.watch(currentUserProvider);
    // final String uuid = userProfile.uuid;

    // 測試用假資料
    final String uuid = "user-uuid-123456";

    // 加上時間戳記 (未來可做防偽驗證)
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String qrData = "$uuid-$timestamp";

    // 回傳 AlertDialog
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        '我的 QR Code',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 250,
            height: 250,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDecorations.cardRadius),
              border: Border.all(color: AppColors.greenAccent, width: 2),
            ),
            child: QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 200,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '員工ID: ${uuid.substring(10, 16).toUpperCase()}',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '掃碼器請掃描此QR Code進行識別',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('QR Code已複製到剪貼簿')));
          },
          icon: const Icon(Icons.copy),
          label: const Text('複製ID'),
        ),
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('成功收取廢棄物，計算碳足跡中...'),
                  duration: Duration(seconds: 2),
                ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('碳足跡計算成功，已儲存至個人帳戶；獲得 10 Exp。'),
                  duration: Duration(seconds: 3),
                ),
            );
            Navigator.pop(context);
          },
          child: const Text('關閉'),
        ),
      ],
    );
  }
}
