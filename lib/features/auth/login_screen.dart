import 'package:flutter/material.dart';

import 'package:eco_sensing_app/core/utils/auth_storage.dart';
import 'package:eco_sensing_app/core/theme/app_colors.dart';
import 'package:eco_sensing_app/core/theme/app_decorations.dart';
import 'data/auth_api.dart';
import '../dashboard/presentation/employee/emp_home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.onLoggedIn});

  final VoidCallback? onLoggedIn;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _authApi = const AuthApi();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedRole;
  bool _obscurePassword = true;
  bool _isSubmitting = false;

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '請輸入郵箱';
    }
    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailPattern.hasMatch(value.trim())) {
      return '請輸入有效的郵箱地址';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '請輸入密碼';
    }
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('請選擇身份')));
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (_selectedRole != '員工端') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('企業端功能待開發')));
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final result = await _authApi.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      await AuthStorage.saveSession(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );
      if (!mounted) {
        return;
      }

      widget.onLoggedIn?.call();
      if (widget.onLoggedIn == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const EmployeeHomePage()),
        );
      }
    } on AuthException catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
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
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                        decoration: const InputDecoration(
                          hintText: '請輸入郵箱',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('密碼', style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        validator: _validatePassword,
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
                        onPressed: _isSubmitting ? null : _handleLogin,
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: AppColors.white,
                                ),
                              )
                            : const Text('登入'),
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
