import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';
import 'package:eco_sensing_app/core/theme/app_decorations.dart';
import 'package:eco_sensing_app/core/utils/demo_auth_storage.dart';
import 'package:eco_sensing_app/features/auth/login_screen.dart';
import '../../../../providers/current_user_provider.dart';

class SettingsTab extends ConsumerStatefulWidget {
  const SettingsTab({super.key});

  static const _cardBorder = Color(0xFFE0E0E0);
  static const _settingsGreen = Color(0xFF2E7D32);
  static const _settingsRed = Color(0xFFE24B4A);

  @override
  ConsumerState<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends ConsumerState<SettingsTab> {
  String _selectedTheme = 'light';
  String _selectedLanguage = 'zh_TW';
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;

  static const _languageLabels = {
    'zh_TW': '繁體中文',
    'zh_CN': '簡體中文',
    'en': 'English',
  };

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final iconMuted = Theme.of(context).colorScheme.onSurfaceVariant;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          _SettingsBlock(
            title: '組織資訊',
            children: [
              _buildLockedTile(
                title: '所屬公司',
                subtitle: user.company,
                iconColor: iconMuted,
              ),
              const _SectionDivider(),
              _buildLockedTile(
                title: '所屬部門',
                subtitle: user.department,
                iconColor: iconMuted,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SettingsBlock(
            title: '外觀與語言',
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '主題',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildThemePills(),
                  ],
                ),
              ),
              const _SectionDivider(),
              ListTile(
                leading: Icon(Icons.language, color: iconMuted, size: 22),
                title: const Text('語言'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _languageLabels[_selectedLanguage] ?? '繁體中文',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.expand_more,
                      size: 20,
                      color: AppColors.textSecondary.withValues(alpha: 0.6),
                    ),
                  ],
                ),
                onTap: _showLanguageSheet,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SettingsBlock(
            title: '通知',
            children: [
              _buildNotificationSwitch(
                icon: Icons.notifications_outlined,
                title: '通知開啟',
                subtitle: '接收所有通知',
                value: _notificationsEnabled,
                onChanged: (v) => setState(() => _notificationsEnabled = v),
                iconColor: iconMuted,
              ),
              if (_notificationsEnabled) ...[
                const _SectionDivider(),
                _buildNotificationSwitch(
                  icon: Icons.email_outlined,
                  title: 'Email通知',
                  subtitle: '接收郵件通知',
                  value: _emailNotifications,
                  onChanged: (v) => setState(() => _emailNotifications = v),
                  iconColor: iconMuted,
                ),
                const _SectionDivider(),
                _buildNotificationSwitch(
                  icon: Icons.phone_android_outlined,
                  title: '推播通知',
                  subtitle: '接收手機推播通知',
                  value: _pushNotifications,
                  onChanged: (v) => setState(() => _pushNotifications = v),
                  iconColor: iconMuted,
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          _SettingsBlock(
            title: '帳戶',
            children: [
              _buildActionTile(
                icon: Icons.share_outlined,
                iconColor: SettingsTab._settingsGreen,
                title: '分享我的碳排檔案',
                subtitle: '產生分享連結給同事查看',
                onTap: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('分享連結已複製到剪貼簿')));
                },
              ),
              const _SectionDivider(),
              _buildActionTile(
                icon: Icons.download_outlined,
                iconColor: iconMuted,
                title: '下載我的數據',
                subtitle: '匯出個人資料和活動記錄',
                onTap: () {
                  _showInfoDialog(context, '下載數據', '您的數據將被匯出為 JSON 格式');
                },
              ),
              const _SectionDivider(),
              _buildActionTile(
                icon: Icons.logout,
                iconColor: SettingsTab._settingsRed,
                title: '登出',
                titleColor: SettingsTab._settingsRed,
                showSubtitle: false,
                onTap: () => _confirmLogout(context),
              ),
              const _SectionDivider(),
              _buildActionTile(
                icon: Icons.delete_outline,
                iconColor: SettingsTab._settingsRed,
                title: '刪除帳號',
                subtitle: '永久刪除您的帳號和所有數據',
                titleColor: SettingsTab._settingsRed,
                onTap: () {
                  _showConfirmDialog(context, '刪除帳號', '此操作無法撤銷，您確定嗎？');
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SettingsBlock(
            title: '關於',
            children: [
              _buildActionTile(
                icon: Icons.info_outline,
                iconColor: iconMuted,
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
              const _SectionDivider(),
              _buildActionTile(
                icon: Icons.shield_outlined,
                iconColor: iconMuted,
                title: '隱私政策',
                subtitle: '查看我們的隱私政策',
                onTap: () {
                  _showInfoDialog(context, '隱私政策', '我們致力於保護您的個人隱私...');
                },
              ),
              const _SectionDivider(),
              _buildActionTile(
                icon: Icons.description_outlined,
                iconColor: iconMuted,
                title: '服務條款',
                subtitle: '查看服務條款',
                onTap: () {
                  _showInfoDialog(context, '服務條款', '使用本應用即表示您同意以下條款...');
                },
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
        ],
      ),
    );
  }

  Widget _buildThemePills() {
    return Row(
      children: [
        Expanded(
          child: _ThemePill(
            label: '淺色',
            icon: Icons.wb_sunny_outlined,
            isSelected: _selectedTheme == 'light',
            onTap: () => setState(() => _selectedTheme = 'light'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ThemePill(
            label: '深色',
            icon: Icons.dark_mode_outlined,
            isSelected: _selectedTheme == 'dark',
            onTap: () => setState(() => _selectedTheme = 'dark'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ThemePill(
            label: '自動',
            icon: Icons.brightness_auto_outlined,
            isSelected: _selectedTheme == 'auto',
            onTap: () => setState(() => _selectedTheme = 'auto'),
          ),
        ),
      ],
    );
  }

  Widget _buildLockedTile({
    required String title,
    required String subtitle,
    required Color iconColor,
  }) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
      ),
      trailing: Icon(
        Icons.lock_outline,
        size: 18,
        color: AppColors.textSecondary.withValues(alpha: 0.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    Color? titleColor,
    bool showSubtitle = true,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor, size: 22),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: titleColor,
        ),
      ),
      subtitle: showSubtitle && subtitle != null
          ? Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            )
          : null,
      trailing: Icon(
        Icons.chevron_right,
        size: 20,
        color: AppColors.textSecondary.withValues(alpha: 0.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }

  Widget _buildNotificationSwitch({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color iconColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor, size: 22),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: SettingsTab._settingsGreen,
        activeThumbColor: Colors.white,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }

  void _showLanguageSheet() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '選擇語言',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ..._languageLabels.entries.map((entry) {
                final isSelected = _selectedLanguage == entry.key;
                return ListTile(
                  title: Text(entry.value),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check,
                          color: SettingsTab._settingsGreen,
                        )
                      : null,
                  onTap: () {
                    setState(() => _selectedLanguage = entry.key);
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _confirmLogout(BuildContext context) {
    final rootContext = context;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('登出'),
        content: const Text('確定要登出嗎？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              await DemoAuthStorage.logout();
              if (!rootContext.mounted) {
                return;
              }
              Navigator.pop(dialogContext);
              Navigator.of(rootContext).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: SettingsTab._settingsRed,
            ),
            child: const Text('登出'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDecorations.cardRadius),
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
            style: TextButton.styleFrom(
              foregroundColor: SettingsTab._settingsRed,
            ),
            child: const Text('確定刪除'),
          ),
        ],
      ),
    );
  }
}

class _SettingsBlock extends StatelessWidget {
  const _SettingsBlock({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: SettingsTab._cardBorder, width: 0.5),
      ),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(height: 4),
          ...children,
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, indent: 16, endIndent: 16);
  }
}

class _ThemePill extends StatelessWidget {
  const _ThemePill({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? SettingsTab._settingsGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? SettingsTab._settingsGreen
                : SettingsTab._cardBorder,
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
