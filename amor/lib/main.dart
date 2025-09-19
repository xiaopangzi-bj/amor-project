// Flutter核心包
import 'package:flutter/material.dart';
// 状态管理包
import 'package:provider/provider.dart';
// Firebase核心包
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// 认证状态管理
import 'providers/auth_provider.dart';
// 登录页面
import 'screens/login_screen.dart';
// 聊天页面
import 'screens/chat_screen.dart';

/// 应用程序入口点
/// 启动Flutter应用并初始化根组件
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // 尝试初始化Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase初始化成功');
  } catch (e) {
    // Firebase初始化失败时的处理
    print('Firebase初始化失败: $e');
    // 继续运行应用，但不使用Firebase功能
  }
  
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
            seedColor: const Color(0xFFE91E63), // 主色调：粉色系
            brightness: Brightness.light, // 亮色主题
          ),
          useMaterial3: true, // 启用Material Design 3
          // 自定义粉色系配色
          primarySwatch: Colors.pink,
          primaryColor: const Color(0xFFE91E63),
          scaffoldBackgroundColor: const Color(0xFFFCE4EC),
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
          return const Scaffold(
            backgroundColor: Color(0xFFFCE4EC), // 粉色系背景
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 加载指示器，使用粉色系主色调
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFE91E63),
                    ),
                  ),
                  SizedBox(height: 16),
                  // 加载提示文本
                  Text(
                    '正在加载...',
                    style: TextStyle(
                      color: Color(0xFF880E4F), // 深粉色
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  // 添加调试信息
                  Text(
                    '如果长时间停留在此页面，请检查网络连接',
                    style: TextStyle(
                      color: Color(0xFF880E4F),
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
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
