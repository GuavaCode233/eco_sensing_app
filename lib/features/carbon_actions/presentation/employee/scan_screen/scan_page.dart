import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();
  final String _employeeQRCode = const Uuid().v4(); // 員工專屬QR Code

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _takePhoto() async {
    // 使用 image_picker 打開相機拍照
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (photo != null) {
        setState(() {
          _selectedImage = File(photo.path);
        });
        _showUploadConfirmation();
      }
    } catch (e) {
      _showErrorDialog('拍照失敗: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    // 從相簿選擇照片
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        _showUploadConfirmation();
      }
    } catch (e) {
      _showErrorDialog('選擇照片失敗: $e');
    }
  }

  void _showUploadConfirmation() {
    // 顯示確認上傳的對話框
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('確認上傳'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_selectedImage != null)
              Image.file(
                _selectedImage!,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16),
            const Text('確定要上傳此照片嗎？'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _uploadImage();
            },
            child: const Text('確認上傳'),
          ),
        ],
      ),
    );
  }

  void _uploadImage() {
    // TODO: 實現上傳邏輯至服務器
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('照片已上傳')));
    setState(() {
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
    // 顯示員工專屬QR Code的彈窗
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
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF5B8FF9), width: 2),
              ),
              child: QrImageView(
                data: _employeeQRCode,
                version: QrVersions.auto,
                size: 200,
                embeddedImage: null,
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
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('掃描單據'),
        backgroundColor: const Color(0xFF5B8FF9),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '拍照上傳紙本單據',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _takePhoto,
                    icon: const Icon(Icons.camera),
                    label: const Text('開啟相機'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      backgroundColor: const Color(0xFF5B8FF9),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  if (_selectedImage != null) ...[
                    const SizedBox(height: 24),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.file(
                        _selectedImage!,
                        height: 300,
                        width: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // 功能按鈕行 - TanAI 設計風格
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFFAFAFC),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImageFromGallery,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('選擇照片'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B8FF9),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showQRCodePopup,
                  icon: const Icon(Icons.qr_code),
                  label: const Text('我的QR Code'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B8FF9),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
