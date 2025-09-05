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

/// 应用程序入口点
/// 启动Flutter应用并初始化根组件
void main() {
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
            seedColor: const Color(0xFFFF6B6B), // 主色调：温暖的红色
            brightness: Brightness.light, // 亮色主题
          ),
          useMaterial3: true, // 启用Material Design 3
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
      context.read<AuthProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 使用Consumer监听认证状态变化
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // 如果认证状态还在初始化或正在加载，显示加载页面
        if (!authProvider.isInitialized || authProvider.isLoading) {
          return const Scaffold(
            backgroundColor: Color(0xFFF8F6F0), // 温暖的米色背景
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 加载指示器，使用应用主色调
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B6B)),
                  ),
                  SizedBox(height: 16),
                  // 加载提示文本
                  Text(
                    '正在加载...',
                    style: TextStyle(
                      color: Color(0xFF7F8C8D), // 柔和的灰色
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // 根据用户登录状态显示相应页面
        if (authProvider.isLoggedIn) {
          return const ChatScreen(); // 已登录：显示聊天页面
        } else {
          return const LoginScreen(); // 未登录：显示登录页面
        }
      },
    );
  }
}
