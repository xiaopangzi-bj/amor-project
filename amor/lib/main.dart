// Flutter核心包
import 'package:flutter/material.dart';
// 状态管理包
import 'package:provider/provider.dart';
// 认证状态管理
import 'providers/auth_provider.dart';
// 登录页面
import 'screens/login_screen.dart';
// 聊天页面
import 'screens/chat_screen.dart';
// 字体配置
import 'config/font_config.dart';

/// 应用程序入口点
/// 启动Flutter应用并初始化根组件
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MyApp());
}

/// 应用程序根组件
/// 配置全局主题、状态管理和路由
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // 创建认证状态管理器，为整个应用提供认证状态
      create: (context) => AuthProvider(),
      child: MaterialApp(
        title: 'Amor', // 应用标题
        debugShowCheckedModeBanner: false, // 隐藏调试横幅
        theme: ThemeData(
          // 使用Material Design 3主题
          colorScheme: ColorScheme.fromSeed(
            seedColor: HSLColor.fromAHSL(1.0, 315, 0.65, 0.75).toColor(), // Amor主色调：315° 65% 75%
            brightness: Brightness.light, // 亮色主题
          ),
          useMaterial3: true, // 启用Material Design 3
          // Amor配色方案
          primarySwatch: MaterialColor(
            HSLColor.fromAHSL(1.0, 315, 0.65, 0.75).toColor().value,
            <int, Color>{
              50: HSLColor.fromAHSL(1.0, 315, 0.65, 0.95).toColor(), // 非常浅
              100: HSLColor.fromAHSL(1.0, 315, 0.65, 0.90).toColor(), // 浅
              200: HSLColor.fromAHSL(1.0, 315, 0.65, 0.85).toColor(), // 较浅
              300: HSLColor.fromAHSL(1.0, 315, 0.65, 0.80).toColor(), // 中浅
              400: HSLColor.fromAHSL(1.0, 315, 0.65, 0.75).toColor(), // 主色
              500: HSLColor.fromAHSL(1.0, 315, 0.65, 0.70).toColor(), // 中深
              600: HSLColor.fromAHSL(1.0, 315, 0.65, 0.65).toColor(), // 较深
              700: HSLColor.fromAHSL(1.0, 315, 0.65, 0.60).toColor(), // 深
              800: HSLColor.fromAHSL(1.0, 315, 0.65, 0.55).toColor(), // 很深
              900: HSLColor.fromAHSL(1.0, 315, 0.65, 0.50).toColor(), // 最深
            },
          ),
          primaryColor: HSLColor.fromAHSL(1.0, 315, 0.65, 0.75).toColor(),
          scaffoldBackgroundColor: HSLColor.fromAHSL(1.0, 315, 0.65, 0.98).toColor(), // 非常浅的背景
        ),
        home: const AuthWrapper(), // 设置首页为认证包装器
      ),
    );
  }
}

/// 认证包装器组件
/// 根据用户认证状态决定显示登录页面还是聊天页面
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

/// 认证包装器状态类
class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // 在组件初始化完成后初始化认证状态
    // 使用addPostFrameCallback确保在第一帧渲染完成后执行
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        context.read<AuthProvider>().initialize();
      } catch (e) {
        print('认证初始化失败: $e');
        // 即使初始化失败，也要确保UI能正常显示
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 使用Consumer监听认证状态变化
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // 如果认证状态还在初始化或正在加载，显示加载页面
        if (!authProvider.isInitialized || authProvider.isLoading) {
          return Scaffold(
            backgroundColor: HSLColor.fromAHSL(1.0, 315, 0.65, 0.98).toColor(), // Amor浅背景色
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 加载指示器，使用Amor主色调
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      HSLColor.fromAHSL(1.0, 315, 0.65, 0.75).toColor(), // Amor主色
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 加载提示文本
                  Text(
                    'Loading...',
                    style: TextStyle(
                      color: HSLColor.fromAHSL(1.0, 315, 0.65, 0.45).toColor(), // Amor深色调
                      fontSize: FontConfig.getCurrentFontSizes().inputText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 添加调试信息
                  Text(
                    'If you stay on this page for a long time, please check your network connection',
                    style: TextStyle(
                      color: HSLColor.fromAHSL(1.0, 315, 0.65, 0.45).toColor(), // Amor深色调
                      fontSize: FontConfig.getCurrentFontSizes().timestamp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        // 默认进入聊天页面，不强制登录
        return const ChatScreen();
      },
    );
  }
}
