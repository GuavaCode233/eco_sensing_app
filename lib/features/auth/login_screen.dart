import 'package:flutter/material.dart';

import '../dashboard/presentation/employee/emp_home_screen.dart';

class LoginPage extends StatefulWidget {
  // 登入頁面，使用 StatefulWidget 以便管理輸入狀態
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedRole;
  bool _obscurePassword = true;

  @override
  void dispose() {
    // 釋放控制器資源，避免記憶體外洩
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    // 處理登入邏輯
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _selectedRole == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('請填寫所有欄位')));
      return;
    }

    // 根據選擇的身份進行導航
    if (_selectedRole == '員工端') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => EmployeeHomePage()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('企業端功能待開發')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 漸層背景
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        ),
        child: SafeArea(
          // Center 讓裡面的東西在整個螢幕中「垂直且水平置中」
          child: Center(
            child: SingleChildScrollView(
              // 外層加一點 Padding，避免在小手機上卡片緊貼螢幕邊緣
              padding: const EdgeInsets.all(24.0),
              // ConstrainedBox 是網頁/桌面版的救星！限制卡片最寬只能是 400
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                // 使用 Card 或帶有陰影的 Container 來製作「浮動卡片」
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface, // 卡片背景色
                    borderRadius: BorderRadius.circular(14), // 卡片圓角
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06), // 淡淡的陰影
                        blurRadius: 20,
                        offset: const Offset(0, 10), // 陰影往下偏移，更有浮空感
                      ),
                    ],
                  ),
                  // 卡片內部的 Padding
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    // 5. 重要！讓 Column 的高度「剛好包住內容就好」，不要撐滿整個螢幕
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // --- 下面的內容幾乎和你原本的一樣，只是拿掉了一些太大的空白(SizedBox) ---

                      // 標題區塊
                      Center(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue.shade100,
                              ),
                              child: Icon(
                                Icons.eco,
                                size: 48,
                                color: Colors.blue.shade700,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Eco-Sensing',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF5B8FF9),
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '企業範疇三碳排AI智慧核算助理',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey.shade600),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32), // 縮小原本的間距
                      // 角色選擇
                      Text(
                        '選擇身份',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildRoleButton(
                              role: '員工端',
                              isSelected: _selectedRole == '員工端',
                              onTap: () =>
                                  setState(() => _selectedRole = '員工端'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildRoleButton(
                              role: '企業端',
                              isSelected: _selectedRole == '企業端',
                              onTap: () =>
                                  setState(() => _selectedRole = '企業端'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // 郵箱欄位
                      Text(
                        '郵箱地址',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: '請輸入郵箱',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: const Color(0xFF5B8FF9),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 密碼欄位
                      Text(
                        '密碼',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: '請輸入密碼',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: const Color(0xFF5B8FF9),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // 登入按鈕
                      ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5B8FF9),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          '登入',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // 忘記密碼
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('忘記密碼功能待實現')),
                          );
                        },
                        child: Text(
                          '忘記密碼？',
                          style: TextStyle(color: const Color(0xFF5B8FF9)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    // 角色選擇按鈕 (模組化)
    required String role,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5B8FF9) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF5B8FF9) : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF5B8FF9).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              role,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
