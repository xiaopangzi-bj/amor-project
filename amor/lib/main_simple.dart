// Flutter核心包
import 'package:flutter/material.dart';
// 字体配置
import 'config/font_config.dart';

/// 简单测试版本的应用程序入口点
/// 用于测试基本UI是否能正常显示
void main() {
  runApp(const SimpleTestApp());
}

/// 简单测试应用
class SimpleTestApp extends StatelessWidget {
  const SimpleTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amor - 测试版',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE91E63),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        primarySwatch: Colors.pink,
        primaryColor: const Color(0xFFE91E63),
        scaffoldBackgroundColor: const Color(0xFFFCE4EC),
      ),
      home: const SimpleTestScreen(),
    );
  }
}

/// 简单测试页面
class SimpleTestScreen extends StatelessWidget {
  const SimpleTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC),
      appBar: AppBar(
        title: const Text('Amor - 测试版'),
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.favorite,
              size: 80,
              color: Color(0xFFE91E63),
            ),
            const SizedBox(height: 20),
            Text(
              '应用正常运行！',
              style: TextStyle(
                fontSize: FontConfig.getCurrentFontSizes().inputText + 8,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF880E4F),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '如果你能看到这个页面，说明Flutter应用基本功能正常',
              style: TextStyle(
                fontSize: FontConfig.getCurrentFontSizes().inputText,
                color: const Color(0xFF880E4F),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Card(
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      '测试信息',
                      style: TextStyle(
                        fontSize: FontConfig.getCurrentFontSizes().inputText + 2,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF880E4F),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '• UI渲染正常\n• 主题配置正确\n• 基本组件工作正常',
                      style: TextStyle(
                        fontSize: FontConfig.getCurrentFontSizes().messageText,
                        color: const Color(0xFF880E4F),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('测试按钮点击成功！'),
              backgroundColor: Color(0xFFE91E63),
            ),
          );
        },
        backgroundColor: const Color(0xFFE91E63),
        child: const Icon(Icons.touch_app, color: Colors.white),
      ),
    );
  }
}