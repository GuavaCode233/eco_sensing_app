import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsTab extends ConsumerStatefulWidget {
  const SettingsTab({super.key});

  @override
  ConsumerState<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends ConsumerState<SettingsTab> {
  String _selectedTheme = 'light';
  String _selectedLanguage = 'zh_TW';
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          // 主題設定
          _buildSettingsSection(title: '主題', children: [_buildThemeSelector()]),
          const SizedBox(height: 16),
          // 語言設定
          _buildSettingsSection(
            title: '語言',
            children: [_buildLanguageSelector()],
          ),
          const SizedBox(height: 16),
          // 通知設定
          _buildSettingsSection(
            title: '通知設定',
            children: [
              _buildSwitchTile(
                title: '通知開啟',
                subtitle: '接收所有通知',
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
              if (_notificationsEnabled) ...[
                const SizedBox(height: 12),
                _buildSwitchTile(
                  title: 'Email通知',
                  subtitle: '接收郵件通知',
                  value: _emailNotifications,
                  onChanged: (value) {
                    setState(() {
                      _emailNotifications = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                _buildSwitchTile(
                  title: '推播通知',
                  subtitle: '接收手機推播通知',
                  value: _pushNotifications,
                  onChanged: (value) {
                    setState(() {
                      _pushNotifications = value;
                    });
                  },
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          // 數據和隱私
          _buildSettingsSection(
            title: '數據和隱私',
            children: [
              _buildSettingsTile(
                icon: Icons.download,
                title: '下載我的數據',
                subtitle: '匯出個人資料和活動記錄',
                onTap: () {
                  _showInfoDialog(context, '下載數據', '您的數據將被匯出為 JSON 格式');
                },
              ),
              const SizedBox(height: 12),
              _buildSettingsTile(
                icon: Icons.delete,
                title: '刪除帳號',
                subtitle: '永久刪除您的帳號和所有數據',
                titleColor: Colors.red,
                onTap: () {
                  _showConfirmDialog(context, '刪除帳號', '此操作無法撤銷，您確定嗎？');
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 關於
          _buildSettingsSection(
            title: '關於',
            children: [
              _buildSettingsTile(
                icon: Icons.info,
                title: '關於 Eco-Sensing',
                subtitle: '版本 1.0.0',
                onTap: () {
                  _showInfoDialog(
                    context,
                    '關於應用',
                    '企業範疇三碳排AI智慧核算助理\n版本 1.0.0\n\nEco-Sensing 幫助您追蹤和減少碳足跡。',
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildSettingsTile(
                icon: Icons.description,
                title: '隱私政策',
                subtitle: '查看我們的隱私政策',
                onTap: () {
                  _showInfoDialog(context, '隱私政策', '我們致力於保護您的個人隱私...');
                },
              ),
              const SizedBox(height: 12),
              _buildSettingsTile(
                icon: Icons.gavel,
                title: '服務條款',
                subtitle: '查看服務條款',
                onTap: () {
                  _showInfoDialog(context, '服務條款', '使用本應用即表示您同意以下條款...');
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
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
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildThemeSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildThemeOption(label: '淺色', value: 'light', icon: Icons.wb_sunny),
          const SizedBox(width: 12),
          _buildThemeOption(label: '深色', value: 'dark', icon: Icons.dark_mode),
          const SizedBox(width: 12),
          _buildThemeOption(
            label: '自動',
            value: 'auto',
            icon: Icons.brightness_auto,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption({
    required String label,
    required String value,
    required IconData icon,
  }) {
    final isSelected = _selectedTheme == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTheme = value;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF5B8FF9).withValues(alpha: 0.1)
              : Colors.grey[100],
          border: Border.all(
            color: isSelected ? const Color(0xFF5B8FF9) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF5B8FF9) : Colors.grey[600],
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? const Color(0xFF5B8FF9) : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Column(
      children: [
        _buildLanguageOption(label: '繁體中文', value: 'zh_TW'),
        const SizedBox(height: 8),
        _buildLanguageOption(label: '簡體中文', value: 'zh_CN'),
        const SizedBox(height: 8),
        _buildLanguageOption(label: 'English', value: 'en'),
      ],
    );
  }

  Widget _buildLanguageOption({required String label, required String value}) {
    final isSelected = _selectedLanguage == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLanguage = value;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF5B8FF9).withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? const Color(0xFF5B8FF9) : Colors.grey[700],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFF5B8FF9)),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: const Color(0xFF5B8FF9),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: titleColor ?? const Color(0xFF5B8FF9), size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('關閉'),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('帳號已刪除')));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('確定刪除'),
          ),
        ],
      ),
    );
  }
}
