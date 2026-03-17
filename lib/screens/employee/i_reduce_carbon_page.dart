import 'package:flutter/material.dart';

// 索引 1: i減碳，減碳活動/任務推薦頁面 (待開發)
class IReduceCarbonPage extends StatefulWidget {
  const IReduceCarbonPage({super.key});

  @override
  State<IReduceCarbonPage> createState() => _IReduceCarbonPageState();
}

class _IReduceCarbonPageState extends State<IReduceCarbonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'i減碳頁面 開發中...',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}