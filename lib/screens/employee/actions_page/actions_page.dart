import 'package:flutter/material.dart';

// 索引 1: i減碳，減碳活動/任務推薦頁面
class IReduceCarbonPage extends StatefulWidget {
  const IReduceCarbonPage({super.key});

  @override
  State<IReduceCarbonPage> createState() => _IReduceCarbonPageState();
}

class _IReduceCarbonPageState extends State<IReduceCarbonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 頂部漸變背景
          Container(
            height: 200 + MediaQuery.of(context).padding.top,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3DBF8A), Color(0xFF1A9E6A)], // 綠色漸變
              ),
            ),
          ),
          // 頁面內容
          SafeArea(
            child: Column(
              children: [
                // 頁面標題
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'i減碳',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                // 主要內容區域
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // 待開發提示
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
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Icon(
                                Icons.eco,
                                size: 64,
                                color: const Color(0xFF3DBF8A),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '減碳活動推薦',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '此頁面正在開發中...',
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
