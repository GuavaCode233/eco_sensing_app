import 'package:flutter/material.dart';

// 索引 3: 個人頁面，資料維護、系統設定 (待開發)
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '個人頁面 開發中...',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}