import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const EcoSensingApp());
}

class EcoSensingApp extends StatelessWidget {
  const EcoSensingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eco-Sensing 碳排AI智慧核算助理',
      // 淺色主題
      theme: ThemeData( // colorScheme: 主題色彩 useMaterail3: 並啟用設計風格
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF5B8FF9)),
        useMaterial3: true,
      ),
      // 深色主題
      darkTheme: ThemeData( 
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF5B8FF9), brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.light, // 跟隨系統主題
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {  // 登入頁面，使用 StatefulWidget 以便管理輸入狀態
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
  void dispose() {  // 釋放控制器資源，避免記憶體外洩
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {  // 處理登入邏輯
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('請填寫所有欄位')),
      );
      return;
    }

    // 根據選擇的身份進行導航
    if (_selectedRole == '員工端') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => EmployeeHomePage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('企業端功能待開發')),
      );
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
                    borderRadius: BorderRadius.circular(24), // 卡片圓角
                    boxShadow:[
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1), // 淡淡的陰影
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
                    children:[
                      // --- 下面的內容幾乎和你原本的一樣，只是拿掉了一些太大的空白(SizedBox) ---
                      
                      // 標題區塊
                      Center(
                        child: Column(
                          children:[
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
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '企業範疇三碳排AI智慧核算助理',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey.shade600,
                              ),
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
                        children:[
                          Expanded(
                            child: _buildRoleButton(
                              role: '員工端',
                              isSelected: _selectedRole == '員工端',
                              onTap: () => setState(() => _selectedRole = '員工端'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildRoleButton(
                              role: '企業端',
                              isSelected: _selectedRole == '企業端',
                              onTap: () => setState(() => _selectedRole = '企業端'),
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
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
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
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // 登入按鈕
                      ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          '登入',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                        child: Text('忘記密碼？', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
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

  Widget _buildRoleButton({ // 角色選擇按鈕 (模組化)
    required String role,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
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

// 員工首頁
class EmployeeHomePage extends StatefulWidget {

  const EmployeeHomePage({
    super.key,
  });

  @override
  State<EmployeeHomePage> createState() => _EmployeeHomePageState();
}

class _EmployeeHomePageState extends State<EmployeeHomePage> {
  // 目前的頁面索引
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),  // 索引 0: 主畫面，儀表板
    const Center(child: Text('i減碳頁面 開發中...', style: TextStyle(fontSize: 24))), // 索引 1: i減碳，減碳活動/任務推薦頁面
    const Center(child: Text('排行榜頁面 開發中...', style: TextStyle(fontSize: 24))), // 索引 2: 部門內排行榜
    const Center(child: Text('個人頁面 開發中...', style: TextStyle(fontSize: 24))), // 索引 3: 個人頁面，資料維護、系統設定
  ];
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // 更新選中的頁面索引
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body 根據目前的 _selectedIndex，從清單中拿出對應的頁面來顯示
      body: _pages[_selectedIndex],
      
      // 底部導覽列
      bottomNavigationBar: BottomNavigationBar(
        // 重要！當按鈕超過 3 個時，必須加上 fixed，否則按鈕會變成白色隱形
        type: BottomNavigationBarType.fixed, 
        
        backgroundColor: Colors.white, // 底部列的背景色
        currentIndex: _selectedIndex, // 告訴導覽列現在是亮哪一顆按鈕
        onTap: _onItemTapped, // 點擊時呼叫上面的方法
        
        // 設定顏色 (對應你的設計圖)
        selectedItemColor: Colors.blueAccent, // 選中時的顏色 (藍色)
        unselectedItemColor: Colors.grey.shade400, // 未選中時的顏色 (灰色)
        
        // 這裡放你的四個按鈕
        items: const[
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline), // 儀表板圖示
            activeIcon: Icon(Icons.pie_chart), // 選中時變成實心圖示
            label: '儀表板',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.eco_outlined), 
            activeIcon: Icon(Icons.eco), 
            label: 'i減碳',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard_outlined), 
            activeIcon: Icon(Icons.leaderboard), 
            label: '排行榜',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), 
            activeIcon: Icon(Icons.person), 
            label: '個人',
          ),
        ],
      ),
    );
  }
}

// 主索引 0: 畫面，儀表板
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}


class _DashboardPageState extends State<DashboardPage> {

  // 模擬用戶數據
  late String userName;
  late String level;
  late int tokens;

  @override
  void initState() {
    super.initState();
    // 這裡未來可以換成呼叫後端 API 的程式碼，例如 fetchUserData()
    userName = "王小明";
    level = '青銅';
    tokens = 1250;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 用戶信息區塊
                  _buildUserInfoCard(),
                  const SizedBox(height: 32),

                  // 碳排數據卡片
                  _buildCarbonEmissionCard(),
                  const SizedBox(height: 24),

                  // 退出登入按鈕
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        '登出',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 用戶信息卡片
  Widget _buildUserInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 用戶名
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                ),
                child: Icon(
                  Icons.person,
                  size: 28,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '歡迎，$userName',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // 這裡可以顯示郵箱或其他用戶信息，目前先註解掉
                  // Text(
                  //   widget.email,
                  //   style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  //     color: Colors.grey.shade600,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 等級和代幣信息
          Row(
            children: [
              Expanded(
                child: _buildInfoTile(
                  icon: Icons.star,
                  label: '目前等級',
                  value: level,
                  backgroundColor: Colors.amber,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoTile(
                  icon: Icons.monetization_on,
                  label: '碳幣',
                  value: '$tokens',
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 信息磚塊
  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color backgroundColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: backgroundColor.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Icon(icon, color: backgroundColor, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: backgroundColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // 碳排數據卡片（圓餅圖）
  Widget _buildCarbonEmissionCard() {
    // 模擬月度碳排數據 (單位：公斤)
    final double travelEmission = 45.5;
    final double wasteEmission = 12.3;
    final double totalEmission = travelEmission + wasteEmission;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '月度碳排組成',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // 圓餅圖
          Center(
            child: SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: Colors.blue.shade400,
                      value: travelEmission,
                      title: '${(travelEmission / totalEmission * 100).toStringAsFixed(1)}%',
                      radius: 80,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      color: Colors.green.shade400,
                      value: wasteEmission,
                      title: '${(wasteEmission / totalEmission * 100).toStringAsFixed(1)}%',
                      radius: 80,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                  centerSpaceRadius: 0,
                  sectionsSpace: 3,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 圖例和數據
          Row(
            children: [
              Expanded(
                child: _buildEmissionLegend(
                  label: '差旅',
                  value: '${travelEmission.toStringAsFixed(1)} kg',
                  color: Colors.blue.shade400,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildEmissionLegend(
                  label: '廢棄物',
                  value: '${wasteEmission.toStringAsFixed(1)} kg',
                  color: Colors.green.shade400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 總計
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '本月總碳排量',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${totalEmission.toStringAsFixed(1)} kg',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 碳排圖例
  Widget _buildEmissionLegend({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
