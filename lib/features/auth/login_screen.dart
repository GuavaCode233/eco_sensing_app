import 'package:flutter/material.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';
import 'package:eco_sensing_app/core/theme/app_decorations.dart';
import '../dashboard/presentation/employee/emp_home_screen.dart';

class LoginPage extends StatefulWidget {
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _selectedRole == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('請填寫所有欄位')));
      return;
    }

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
      backgroundColor: AppColors.neutralWarm,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Container(
                decoration: AppDecorations.card(),
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.greenLight,
                            ),
                            child: const Icon(
                              Icons.eco,
                              size: 44,
                              color: AppColors.starbucksGreen,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Eco-Sensing',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(color: AppColors.starbucksGreen),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '企業範疇三碳排AI智慧核算助理',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      '選擇身份',
                      style: Theme.of(context).textTheme.titleSmall,
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
                    Text(
                      '郵箱地址',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: '請輸入郵箱',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '密碼',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: '請輸入密碼',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _handleLogin,
                      child: const Text('登入'),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('忘記密碼功能待實現')),
                        );
                      },
                      child: const Text('忘記密碼？'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    required String role,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.greenAccent : AppColors.neutralCool,
          borderRadius: BorderRadius.circular(AppDecorations.pillRadius),
          border: Border.all(
            color: isSelected ? AppColors.greenAccent : AppColors.ceramic,
            width: 1.5,
          ),
        ),
        child: Text(
          role,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.14,
            color: isSelected ? AppColors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
