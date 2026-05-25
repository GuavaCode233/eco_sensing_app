import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';
import 'package:eco_sensing_app/core/theme/app_decorations.dart';

class ReceiptConfirmationDialog extends StatefulWidget {
  final String receiptType;
  final DateTime receiptDate;
  final String originLocation;
  final String destinationLocation;
  final double totalFee;
  final double? actualCarbonFootprint;
  final double estimatedCarbonFootprint;
  final int experienceGain;
  final int coinGain;
  final Function(Map<String, dynamic> editedData) onConfirm;
  final VoidCallback onCancel;

  const ReceiptConfirmationDialog({
    super.key,
    required this.receiptType,
    required this.receiptDate,
    required this.originLocation,
    required this.destinationLocation,
    required this.totalFee,
    required this.actualCarbonFootprint,
    required this.estimatedCarbonFootprint,
    required this.experienceGain,
    required this.coinGain,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<ReceiptConfirmationDialog> createState() =>
      _ReceiptConfirmationDialogState();
}

class _ReceiptConfirmationDialogState extends State<ReceiptConfirmationDialog> {
  late TextEditingController _originController;
  late TextEditingController _destinationController;
  late TextEditingController _totalFeeController;
  late TextEditingController _actualCarbonController;
  late String _selectedReceiptType;
  late DateTime _selectedDate;

  static const List<String> _receiptTypes = [
    '高鐵電子票',
    'App乘車截圖',
    '計程車紙本收據',
    '其他',
  ];

  @override
  void initState() {
    super.initState();
    _originController = TextEditingController(text: widget.originLocation);
    _destinationController = TextEditingController(
      text: widget.destinationLocation,
    );
    _totalFeeController = TextEditingController(
      text: widget.totalFee.toStringAsFixed(2),
    );
    _actualCarbonController = TextEditingController(
      text: widget.actualCarbonFootprint?.toStringAsFixed(2) ?? '',
    );
    _selectedReceiptType = widget.receiptType;
    _selectedDate = widget.receiptDate;
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _totalFeeController.dispose();
    _actualCarbonController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      // TODO: 考慮是否需要分離時間選擇器
      // 目前保留原有的時間
      setState(() {
        _selectedDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          _selectedDate.hour,
          _selectedDate.minute,
        );
      });
    }
  }

  String _formatDate(DateTime date) {
    final dateFormat = DateFormat('yyyy/MM/dd hh:mm a');
    return dateFormat.format(date);
  }

  void _handleConfirm() {
    final editedData = {
      'type': _selectedReceiptType,
      'date': _selectedDate,
      'origin': _originController.text,
      'destination': _destinationController.text,
      'totalFee': double.tryParse(_totalFeeController.text) ?? widget.totalFee,
      'actualCarbon': _actualCarbonController.text.isEmpty
          ? null
          : double.tryParse(_actualCarbonController.text),
      'estimatedCarbon': widget.estimatedCarbonFootprint,
      'experience': widget.experienceGain,
      'coin': widget.coinGain,
    };
    Navigator.pop(context);
    widget.onConfirm(editedData);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('確認收據資訊'),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 票據類型
              _buildSectionLabel('票據類型'),
              const SizedBox(height: 8),
              _buildReceiptTypeDropdown(),
              const SizedBox(height: 20),
              const Divider(color: AppColors.ceramic, height: 1),
              const SizedBox(height: 20),

              // 票據日期
              _buildSectionLabel('票據日期'),
              const SizedBox(height: 8),
              _buildDatePicker(),
              const SizedBox(height: 20),
              const Divider(color: AppColors.ceramic, height: 1),
              const SizedBox(height: 20),

              // 起站
              _buildSectionLabel('起站'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _originController,
                hintText: '輸入起站地址',
                // TODO: 後續實裝地址自動完成選擇
              ),
              const SizedBox(height: 20),

              // 訖站
              _buildSectionLabel('訖站'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _destinationController,
                hintText: '輸入訖站地址',
                // TODO: 後續實裝地址自動完成選擇
              ),
              const SizedBox(height: 20),
              const Divider(color: AppColors.ceramic, height: 1),
              const SizedBox(height: 20),

              // 金額
              _buildSectionLabel('金額'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _totalFeeController,
                hintText: '輸入金額',
                keyboardType: TextInputType.number,
                suffixText: 'NT\$',
                // TODO: 驗證邏輯（正數、小數位數）
              ),
              const SizedBox(height: 20),
              const Divider(color: AppColors.ceramic, height: 1),
              const SizedBox(height: 20),

              // 碳足跡
              _buildSectionLabel('碳足跡'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _actualCarbonController,
                hintText: '輸入實際碳足跡',
                keyboardType: TextInputType.number,
                suffixText: 'kg CO₂e',
                // TODO: 驗證邏輯（正數、2位小數）
              ),
              const SizedBox(height: 8),
              Text(
                '預估碳足跡: ${widget.estimatedCarbonFootprint.toStringAsFixed(1)} kg CO₂e',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              const Divider(color: AppColors.ceramic, height: 1),
              const SizedBox(height: 20),

              // 預估獎勵
              _buildSectionLabel('預估獎勵'),
              const SizedBox(height: 8),
              Text(
                '${widget.experienceGain} Exp',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                '${widget.coinGain} 碳幣',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            widget.onCancel();
          },
          child: const Text('取消上傳'),
        ),
        ElevatedButton(onPressed: _handleConfirm, child: const Text('確認上傳')),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildReceiptTypeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.ceramic),
        borderRadius: BorderRadius.circular(AppDecorations.cardRadius),
      ),
      child: DropdownButton<String>(
        value: _receiptTypes.contains(_selectedReceiptType)
            ? _selectedReceiptType
            : '其他',
        isExpanded: true,
        underline: const SizedBox(),
        items: _receiptTypes.map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              _selectedReceiptType = newValue;
            });
          }
        },
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: _selectDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.ceramic),
          borderRadius: BorderRadius.circular(AppDecorations.cardRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatDate(_selectedDate),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Icon(Icons.calendar_today, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    String? suffixText,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDecorations.cardRadius),
        ),
        suffixText: suffixText,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
    );
  }
}
