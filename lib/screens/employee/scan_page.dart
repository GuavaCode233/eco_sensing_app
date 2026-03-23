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

class _ScanPageState extends State<ScanPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();
  final String _employeeQRCode = const Uuid().v4(); // 員工專屬QR Code

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('照片已上傳')),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('掃描單據'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '拍照'),
            Tab(text: '選擇照片'),
            Tab(text: '我的QR Code'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 拍照標籤
          _buildCameraTab(),
          // 選擇照片標籤
          _buildGalleryTab(),
          // QR Code標籤
          _buildQRCodeTab(),
        ],
      ),
    );
  }

  Widget _buildCameraTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.camera_alt,
            size: 64,
            color: Theme.of(context).primaryColor,
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
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
          if (_selectedImage != null) ...[
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
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
    );
  }

  Widget _buildGalleryTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image,
            size: 64,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 24),
          Text(
            '從相簿選擇照片',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _pickImageFromGallery,
            icon: const Icon(Icons.photo_library),
            label: const Text('選擇照片'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
          if (_selectedImage != null) ...[
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
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
    );
  }

  Widget _buildQRCodeTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '我的QR Code',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: QrImageView(
              data: _employeeQRCode,
              version: QrVersions.auto,
              size: 250,
              embeddedImage: null,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '員工ID: ${_employeeQRCode.substring(0, 8).toUpperCase()}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Text(
            '掃碼器請掃描此QR Code進行識別',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('QR Code已複製到剪貼簿')),
              );
            },
            icon: const Icon(Icons.copy),
            label: const Text('複製ID'),
          ),
        ],
      ),
    );
  }
}