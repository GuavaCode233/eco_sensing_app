import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';
import 'package:eco_sensing_app/core/theme/app_decorations.dart';
import 'widgets/recent_uploads_panel.dart';
import 'widgets/scan_viewfinder.dart';
import 'widgets/receipt_confirmation_dialog.dart';
import 'package:eco_sensing_app/features/carbon_actions/data/trash_session_repository.dart';
import 'widgets/trash_session_dialog.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();

  bool _isWasteDemoRunning = false;
  Timer? _scanTimer;

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

  Future<void> _startWasteDemo() async {
    if (_isWasteDemoRunning) return;
    setState(() => _isWasteDemoRunning = true);
    try {
      final scanned = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => _WasteCameraScanOverlay(
          onClose: () => Navigator.of(dialogContext).pop(false),
          onCameraReady: () {
            _scanTimer = Timer(const Duration(milliseconds: 1500), () {
              if (mounted &&
                  dialogContext.mounted &&
                  ModalRoute.of(dialogContext)?.isCurrent == true) {
                Navigator.of(dialogContext).pop(true);
              }
            });
          },
        ),
      );
      _scanTimer?.cancel();
      if (!mounted || scanned != true) return;
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) =>
            TrashSessionDialog(repository: SupabaseTrashSessionRepository()),
      );
    } finally {
      _scanTimer?.cancel();
      if (mounted) setState(() => _isWasteDemoRunning = false);
    }
  }

  @override
  void dispose() {
    _scanTimer?.cancel();
    super.dispose();
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

  Future<void> _uploadImage(Map<String, dynamic> receiptData) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('照片已上傳，AI 辨識中…'),
        duration: Duration(seconds: 2),
      ),
    );

    // 根據編輯後的數據更新最近上傳紀錄（實際應該等後端回傳結果）
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

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // 這裡直接模擬辨識完成並獲得獎勵，實際應該等後端回傳結果後再更新
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('AI 辨識完成，已獲得 30 經驗值和 1 碳幣')));

    setState(() {
      _recentUploads = [
        RecentUploadRecord(
          title: receiptType,
          timeLabel: '剛剛',
          detail: '+30 EXP',
          status: UploadRecordStatus.completed,
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
                    onPressed: _isWasteDemoRunning ? null : _startWasteDemo,
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('掃描垃圾桶'),
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

class _WasteCameraScanOverlay extends StatefulWidget {
  const _WasteCameraScanOverlay({
    required this.onClose,
    required this.onCameraReady,
  });

  final VoidCallback onClose;
  final VoidCallback onCameraReady;

  @override
  State<_WasteCameraScanOverlay> createState() =>
      _WasteCameraScanOverlayState();
}

class _WasteCameraScanOverlayState extends State<_WasteCameraScanOverlay> {
  CameraController? _controller;
  String? _errorMessage;
  bool _didNotifyReady = false;

  @override
  void initState() {
    super.initState();
    unawaited(_initializeCamera());
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (!mounted) {
        return;
      }

      if (cameras.isEmpty) {
        setState(() => _errorMessage = '找不到可用相機');
        return;
      }

      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() => _controller = controller);
      _notifyReady();
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() => _errorMessage = '相機啟動失敗');
    }
  }

  void _notifyReady() {
    if (_didNotifyReady) {
      return;
    }
    _didNotifyReady = true;
    widget.onCameraReady();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final isReady = controller != null && controller.value.isInitialized;

    return Dialog.fullscreen(
      backgroundColor: AppColors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (isReady)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: controller.value.previewSize!.height,
                height: controller.value.previewSize!.width,
                child: CameraPreview(controller),
              ),
            )
          else
            Container(color: AppColors.black),
          Container(color: AppColors.black.withValues(alpha: 0.28)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: widget.onClose,
                        icon: const Icon(Icons.close, color: AppColors.white),
                      ),
                      Expanded(
                        child: Text(
                          '掃描垃圾桶',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const Spacer(),
                  _buildScanFrame(context, isReady),
                  const SizedBox(height: 18),
                  Text(
                    _errorMessage ?? (isReady ? '讀取智慧垃圾桶資訊' : '正在啟動相機...'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.white.withValues(alpha: 0.82),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanFrame(BuildContext context, bool isReady) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDecorations.cardRadius),
          border: Border.all(color: AppColors.greenAccent, width: 2),
        ),
        child: Stack(
          children: [
            CustomPaint(painter: _WasteScanFramePainter(), size: Size.infinite),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isReady ? Icons.qr_code_scanner : Icons.camera_alt_outlined,
                    size: 42,
                    color: AppColors.white.withValues(alpha: 0.88),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isReady ? '將垃圾桶 QR Code 對準框內' : '啟動相機中',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WasteScanFramePainter extends CustomPainter {
  static const _cornerLen = 34.0;
  static const _stroke = 4.0;
  static const _inset = 22.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.greenAccent
      ..strokeWidth = _stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    _drawCorner(canvas, paint, Offset(_inset, _inset), true, true);
    _drawCorner(
      canvas,
      paint,
      Offset(size.width - _inset, _inset),
      false,
      true,
    );
    _drawCorner(
      canvas,
      paint,
      Offset(_inset, size.height - _inset),
      true,
      false,
    );
    _drawCorner(
      canvas,
      paint,
      Offset(size.width - _inset, size.height - _inset),
      false,
      false,
    );

    final linePaint = Paint()
      ..color = AppColors.greenAccent.withValues(alpha: 0.85)
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(_inset, size.height * 0.52),
      Offset(size.width - _inset, size.height * 0.52),
      linePaint,
    );
  }

  void _drawCorner(
    Canvas canvas,
    Paint paint,
    Offset origin,
    bool left,
    bool top,
  ) {
    final dx = left ? 1.0 : -1.0;
    final dy = top ? 1.0 : -1.0;
    canvas.drawLine(origin, origin + Offset(_cornerLen * dx, 0), paint);
    canvas.drawLine(origin, origin + Offset(0, _cornerLen * dy), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
