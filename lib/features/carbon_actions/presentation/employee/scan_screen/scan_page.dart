import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';
import 'package:eco_sensing_app/core/theme/app_decorations.dart';
import 'widgets/recent_uploads_panel.dart';
import 'widgets/scan_viewfinder.dart';
import 'widgets/receipt_confirmation_dialog.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();
  final String _employeeQRCode = const Uuid().v4();

  static const _supportedFormats = ['機票收據', '計程車發票', '住宿單據', '更多'];

  late List<RecentUploadRecord> _recentUploads = const [
    RecentUploadRecord(
      title: '商務差旅單據',
      timeLabel: '今天 14:32',
      detail: '8.2 kg CO₂',
      status: UploadRecordStatus.completed,
      expGain: 50,
      co2Kg: 8.2,
    ),
    RecentUploadRecord(
      title: '住宿發票',
      timeLabel: '昨天 09:15',
      detail: '審核中',
      status: UploadRecordStatus.reviewing,
    ),
  ];

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (photo != null) {
        setState(() => _selectedImage = File(photo.path));
        _showReceiptConfirmation();
      }
    } catch (e) {
      _showErrorDialog('拍照失敗: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() => _selectedImage = File(image.path));
        _showReceiptConfirmation();
      }
    } catch (e) {
      _showErrorDialog('選擇照片失敗: $e');
    }
  }

  void _showReceiptConfirmation() {
    // 固定假數據模型
    final mockReceiptData = {
      'type': 'App乘車截圖',
      'date': DateTime(2026, 3, 26, 20, 30),
      'origin': '110台灣臺北市信義區林口街166號4樓',
      'destination': '337台灣桃園市大園區航站北路9號台灣桃園國際機場第二航廈地下停車場',
      'totalFee': 1424.00,
      'actualCarbon': null,
      'estimatedCarbon': 30.5,
      'experience': 30,
      'coin': 1,
    };

    showDialog(
      context: context,
      builder: (context) => ReceiptConfirmationDialog(
        receiptType: mockReceiptData['type'] as String,
        receiptDate: mockReceiptData['date'] as DateTime,
        originLocation: mockReceiptData['origin'] as String,
        destinationLocation: mockReceiptData['destination'] as String,
        totalFee: mockReceiptData['totalFee'] as double,
        actualCarbonFootprint: mockReceiptData['actualCarbon'] as double?,
        estimatedCarbonFootprint: mockReceiptData['estimatedCarbon'] as double,
        experienceGain: mockReceiptData['experience'] as int,
        coinGain: mockReceiptData['coin'] as int,
        onConfirm: _handleReceiptConfirmation,
        onCancel: () {
          setState(() => _selectedImage = null);
        },
      ),
    );
  }

  void _handleReceiptConfirmation(Map<String, dynamic> editedData) {
    _uploadImage(editedData);
  }

  void _uploadImage(Map<String, dynamic> receiptData) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('照片已上傳，AI 辨識中…')));

    // 根据编辑后的收据数据创建上传记录
    final receiptType = receiptData['type'] as String? ?? '紙本單據';
    final estimatedCarbon = receiptData['estimatedCarbon'] as double? ?? 0.0;
    final experience = receiptData['experience'] as int? ?? 0;

    setState(() {
      _recentUploads = [
        RecentUploadRecord(
          title: receiptType,
          timeLabel: '剛剛',
          detail: '審核中',
          status: UploadRecordStatus.reviewing,
          expGain: experience,
          co2Kg: estimatedCarbon,
        ),
        ..._recentUploads.take(1),
      ];
      _selectedImage = null;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('錯誤'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('確定'),
          ),
        ],
      ),
    );
  }

  void _showQRCodePopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('我的QR Code'),
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
                data: _employeeQRCode,
                version: QrVersions.auto,
                size: 200,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '員工ID: ${_employeeQRCode.substring(0, 8).toUpperCase()}',
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
            onPressed: () => Navigator.pop(context),
            child: const Text('關閉'),
          ),
        ],
      ),
    );
  }

  void _showViewAllUploads() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('完整上傳紀錄功能開發中')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralWarm,
      appBar: AppBar(title: const Text('掃描單據')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ScanViewfinder(onTap: _takePhoto),
                  const SizedBox(height: 20),
                  Text(
                    '拍照上傳紙本單據',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: _supportedFormats.map(_buildFormatChip).toList(),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _takePhoto,
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('開啟相機'),
                  ),
                  if (_selectedImage != null) ...[
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppDecorations.cardRadius,
                      ),
                      child: Image.file(
                        _selectedImage!,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  RecentUploadsPanel(
                    records: _recentUploads,
                    onViewAll: _showViewAllUploads,
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickImageFromGallery,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('選擇照片'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showQRCodePopup,
                    icon: const Icon(Icons.qr_code),
                    label: const Text('我的 QR Code'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatChip(String label) {
    final isMore = label == '更多';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isMore ? Colors.transparent : AppColors.white,
        borderRadius: BorderRadius.circular(AppDecorations.pillRadius),
        border: Border.all(
          color: isMore ? AppColors.greenAccent : AppColors.ceramic,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isMore ? AppColors.greenAccent : AppColors.textSecondary,
        ),
      ),
    );
  }
}
