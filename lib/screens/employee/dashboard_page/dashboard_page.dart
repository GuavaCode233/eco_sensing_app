import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:eco_sensing_app/screens/employee/dashboard_page/carbon_composiotion_card.dart';
import 'package:eco_sensing_app/screens/employee/dashboard_page/dashboard_header.dart';
import '../../auth/login_screen.dart'; // 引入登入頁面，登出後會導航回這裡
import '../../../providers/current_user_provider.dart';

class DashboardPage extends ConsumerWidget {
  // 模擬用戶數據
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(currentUserProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // 員工儀表板頂部背景與資訊
            DashboardHeader(),
            // 頁面內容
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 碳排數據卡片
                    CarbonCompositionCard(),
                    const SizedBox(height: 18),

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
