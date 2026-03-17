import 'package:flutter/material.dart';

// 索引 2: 部門內排行榜 (待開發)
class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '排行榜頁面 開發中...',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}