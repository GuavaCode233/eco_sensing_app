import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:eco_sensing_app/screens/employee/dashboard_page/experience_bar_card.dart';
import 'package:eco_sensing_app/screens/employee/dashboard_page/carbon_composiotion_card.dart';
import 'package:eco_sensing_app/screens/employee/dashboard_page/dashboard_header.dart';
import '../../auth/login_screen.dart'; // 引入登入頁面，登出後會導航回這裡

class DashboardPage extends ConsumerWidget {
  // 模擬用戶數據
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 頁面內容 - 使用 SafeArea 處理底部安全區域
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 頂部用戶信息卡片
                    const DashboardHeader(),
                    const SizedBox(height: 16),
                    // 經驗值進度卡
                    const ExperienceBarCard(),
                    const SizedBox(height: 16),
                    // 碳排數據卡片
                    const CarbonCompositionCard(),
                    const SizedBox(height: 16),
                    // 暫時的登出按鈕，未來會放在個人中心頁面
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(
                            color: Color(0xFF5B8FF9),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          '登出',
                          style: TextStyle(
                            color: Color(0xFF5B8FF9),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
