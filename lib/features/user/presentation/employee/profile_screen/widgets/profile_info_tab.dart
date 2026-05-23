import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';
import 'package:eco_sensing_app/core/theme/app_decorations.dart';
import 'package:eco_sensing_app/core/widgets/app_card.dart';
import 'profile_stats_grid.dart';
import '../../../../providers/current_user_provider.dart';

class ProfileInfoTab extends ConsumerStatefulWidget {
  const ProfileInfoTab({super.key});

  @override
  ConsumerState<ProfileInfoTab> createState() => _ProfileInfoTabState();
}

class _ProfileInfoTabState extends ConsumerState<ProfileInfoTab> {
  late TextEditingController _displayNameController;
  late TextEditingController _nameController;
  late TextEditingController _accountController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;

  bool _isEditingBasicInfo = false;
  bool _showPasswordField = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final user = ref.read(currentUserProvider);
    _displayNameController = TextEditingController(text: user.displayName);
    _nameController = TextEditingController(text: user.name);
    _accountController = TextEditingController(text: user.account);
    _emailController = TextEditingController(text: user.email);
    _phoneController = TextEditingController(text: user.phone);
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _nameController.dispose();
    _accountController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _saveBasicInfo() {
    ref
        .read(currentUserProvider.notifier)
        .updateProfile(
          displayName: _displayNameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          account: _accountController.text,
        );
    setState(() {
      _isEditingBasicInfo = false;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('基本資料已更新')));
  }

  void _savePassword() {
    // TODO: 後端 API 呼叫改密碼
    setState(() {
      _showPasswordField = false;
      _passwordController.clear();
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('密碼已更新')));
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          // 基本資料卡片
          _buildBasicInfoCard(user),
          const SizedBox(height: 16),
          const AppCard(child: ProfileStatsGrid()),
          const SizedBox(height: 16),
          // 修改密碼部分
          _buildPasswordSection(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBasicInfoCard(dynamic user) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '基本資料',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              _isEditingBasicInfo
                  ? Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            _initializeControllers();
                            setState(() {
                              _isEditingBasicInfo = false;
                            });
                          },
                          child: const Text('取消'),
                        ),
                        TextButton(
                          onPressed: _saveBasicInfo,
                          child: const Text('儲存'),
                        ),
                      ],
                    )
                  : TextButton(
                      onPressed: () {
                        setState(() {
                          _isEditingBasicInfo = true;
                        });
                      },
                      child: const Text('編輯'),
                    ),
            ],
          ),
          const SizedBox(height: 12),
          // 顯示名稱
          _buildTextField(
            label: '顯示名稱',
            controller: _displayNameController,
            enabled: _isEditingBasicInfo,
          ),
          const SizedBox(height: 12),
          // 真實名稱
          _buildTextField(
            label: '真實名稱',
            controller: _nameController,
            enabled: false, // 不可編輯
          ),
          const SizedBox(height: 12),
          // 帳號
          _buildTextField(
            label: '帳號',
            controller: _accountController,
            enabled: _isEditingBasicInfo,
          ),
          const SizedBox(height: 12),
          // Email
          _buildTextField(
            label: 'Email',
            controller: _emailController,
            enabled: _isEditingBasicInfo,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          // 電話
          _buildTextField(
            label: '電話',
            controller: _phoneController,
            enabled: _isEditingBasicInfo,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordSection() {
    return Column(
      children: [
        if (!_showPasswordField)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _showPasswordField = true;
                });
              },
              icon: const Icon(Icons.lock),
              label: const Text('修改密碼'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDecorations.pillRadius),
                ),
              ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '修改密碼',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: '新密碼',
                  controller: _passwordController,
                  enabled: true,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _showPasswordField = false;
                            _passwordController.clear();
                          });
                        },
                        child: const Text('取消'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _savePassword,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDecorations.pillRadius,
                            ),
                          ),
                        ),
                        child: const Text('儲存'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required bool enabled,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.greenAccent, width: 2),
        ),
        filled: !enabled,
        fillColor: !enabled ? Colors.grey[100] : Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
    );
  }
}
