import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../providers/auth_provider.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          extendBodyBehindAppBar: true,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE91E63), // 深粉色
                  Color(0xFFF48FB1), // 浅粉色
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo和标题
                    const Spacer(flex: 2),
                    _buildHeader(),
                    const SizedBox(height: 60),

                    // 登录按钮
                    _buildLoginButtons(authProvider),
                    const SizedBox(height: 24),

                    // 加载指示器
                    if (authProvider.isLoading) _buildLoadingIndicator(),

                    const Spacer(flex: 3),

                    // 底部说明
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _signInWithGoogle(AuthProvider authProvider) async {
    debugPrint('🚀 [LOGIN DEBUG] Starting Google Sign In process...');
    try {
      debugPrint('📱 [LOGIN DEBUG] Calling authProvider.signInWithGoogle()');
      final success = await authProvider.signInWithGoogle();
      debugPrint('✅ [LOGIN DEBUG] Google Sign In result: $success');
      
      if (success) {
        debugPrint('🎉 [LOGIN DEBUG] Login successful! Showing success message...');
        // 显示成功提示，但不立即跳转
        _showSuccessSnackBar('登录成功！');
        // 延迟更长时间，让用户看到成功状态
        await Future.delayed(const Duration(milliseconds: 1500));
        debugPrint('🔄 [LOGIN DEBUG] Login process completed, main.dart will handle navigation...');
        // 不在这里手动跳转，让main.dart中的Consumer<AuthProvider>自动处理页面切换
      } else {
        debugPrint('❌ [LOGIN DEBUG] Login failed - user cancelled or error occurred');
        _showErrorDialog('Google登录失败', '登录过程被取消或失败，请重试');
      }
    } catch (e) {
      debugPrint('💥 [LOGIN DEBUG] Exception during Google Sign In: $e');
      debugPrint('📋 [LOGIN DEBUG] Exception type: ${e.runtimeType}');
      
      String errorMessage = '登录失败，请重试';
      
      // 根据错误类型提供更具体的错误信息
      if (e.toString().contains('网络')) {
        errorMessage = '网络连接失败，请检查网络后重试';
        debugPrint('🌐 [LOGIN DEBUG] Network error detected');
      } else if (e.toString().contains('验证失败')) {
        errorMessage = '身份验证失败，请重试';
        debugPrint('🔐 [LOGIN DEBUG] Authentication error detected');
      } else if (e.toString().contains('ID Token')) {
        errorMessage = 'Google认证失败，请重试';
        debugPrint('🎫 [LOGIN DEBUG] ID Token error detected');
      } else if (e.toString().contains('后端')) {
        errorMessage = '服务器验证失败，请稍后重试';
        debugPrint('🖥️ [LOGIN DEBUG] Backend error detected');
      }
      
      debugPrint('📝 [LOGIN DEBUG] Final error message: $errorMessage');
      _showErrorDialog('登录失败', errorMessage);
    }
  }

  Future<void> _signInWithApple(AuthProvider authProvider) async {
    debugPrint('🍎 [LOGIN DEBUG] Starting Apple Sign In process...');
    try {
      debugPrint('📱 [LOGIN DEBUG] Calling authProvider.signInWithApple()');
      final success = await authProvider.signInWithApple();
      debugPrint('✅ [LOGIN DEBUG] Apple Sign In result: $success');
      
      if (success) {
        debugPrint('🎉 [LOGIN DEBUG] Apple login successful! Showing success message...');
        // 显示成功提示，但不立即跳转
        _showSuccessSnackBar('登录成功！');
        // 延迟更长时间，让用户看到成功状态
        await Future.delayed(const Duration(milliseconds: 1500));
        debugPrint('🔄 [LOGIN DEBUG] Login process completed, main.dart will handle navigation...');
        // 不在这里手动跳转，让main.dart中的Consumer<AuthProvider>自动处理页面切换
      } else {
        debugPrint('❌ [LOGIN DEBUG] Apple login failed');
        _showErrorDialog('苹果登录失败', '请重试');
      }
    } catch (e) {
      debugPrint('💥 [LOGIN DEBUG] Exception during Apple Sign In: $e');
      debugPrint('📋 [LOGIN DEBUG] Exception type: ${e.runtimeType}');
      _showErrorDialog('苹果登录失败', '登录过程中出现错误，请重试');
    }
  }

  void _navigateToChat() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const ChatScreen()),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // App Logo - 使用新设计的SVG logo
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B6B).withValues(alpha: 0.2),
                blurRadius: 25,
                offset: const Offset(0, 8),
                spreadRadius: 2,
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.8),
                blurRadius: 15,
                offset: const Offset(0, -4),
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.95),
                    Colors.white.withValues(alpha: 0.85),
                  ],
                ),
              ),
              child: Center(
                child: Image.asset(
                  'assets/logo.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // 如果图片加载失败，显示优化的默认图标
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFFF6B6B),
                            Color(0xFFFF8E8E),
                            Color(0xFFFFB6B6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        size: 45,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),

        // 应用名称
        const Text(
          'Amor AI - Smart Health Product\nComparison',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),

        // 副标题
        const Text(
          'Voice-powered AI assistant helps you find trusted health products,\nsupplements, and wellness items at the best prices. Compare across top\nretailers instantly.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButtons(AuthProvider authProvider) {
    return Column(
      children: [
        // Google 登录按钮
        _buildGoogleLoginButton(authProvider),
        // 只在 iOS 和 macOS 上显示苹果登录按钮
        if (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS) ...[
          const SizedBox(height: 16),
          _buildAppleLoginButton(authProvider),
        ],
      ],
    );
  }

  Widget _buildTagButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPlatformInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '苹果登录仅在 iOS 和 macOS 设备上可用',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleLoginButton(AuthProvider authProvider) {
    return Container(
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: authProvider.isLoading
            ? null
            : () => _signInWithGoogle(authProvider),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF2C3E50),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Google Logo
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFF4285F4),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.g_mobiledata,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'Sign in with Google',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: authProvider.isLoading
                    ? Colors.grey
                    : const Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppleLoginButton(AuthProvider authProvider) {
    return Container(
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: authProvider.isLoading
            ? null
            : () => _signInWithApple(authProvider),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 苹果 Logo
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.apple, color: Colors.black, size: 20),
            ),
            const SizedBox(width: 16),
            Text(
              '使用 Apple 账户登录',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: authProvider.isLoading ? Colors.grey : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        children: [
          SizedBox(height: 16),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 2,
          ),
          SizedBox(height: 16),
          Text(
            '正在登录...',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const Text(
          'By signing in, you agree to our',
          style: TextStyle(fontSize: 12, color: Colors.white70),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                // 显示服务条款
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Terms of Service',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const Text(
              ' and ',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
            TextButton(
              onPressed: () {
                // 显示隐私政策
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// 自定义渐变爱心画笔
class GradientHeartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFFF6B00), // 橙色
          Color(0xFFFF1744), // 红色
          Color(0xFFE91E63), // 粉色
          Color(0xFF9C27B0), // 紫色
          Color(0xFF3F51B5), // 蓝色
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 0.25, 0.5, 0.75, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    final path = Path();
    
    // 绘制更现代化的爱心形状
    final width = size.width;
    final height = size.height;
    final centerX = width / 2;
    
    // 左上圆弧
    path.addArc(
      Rect.fromCircle(
        center: Offset(width * 0.3, height * 0.3),
        radius: width * 0.25,
      ),
      0,
      3.14159,
    );
    
    // 右上圆弧
    path.addArc(
      Rect.fromCircle(
        center: Offset(width * 0.7, height * 0.3),
        radius: width * 0.25,
      ),
      0,
      3.14159,
    );
    
    // 连接到底部尖角，使用贝塞尔曲线使形状更圆润
    path.quadraticBezierTo(
      width * 0.9, height * 0.6,
      centerX, height * 0.85,
    );
    
    path.quadraticBezierTo(
      width * 0.1, height * 0.6,
      width * 0.05, height * 0.3,
    );
    
    path.close();
    
    canvas.drawPath(path, paint);
    
    // 添加高光效果
    final highlightPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.3),
          Colors.white.withValues(alpha: 0.1),
          Colors.transparent,
        ],
        begin: Alignment.topLeft,
        end: Alignment.center,
      ).createShader(Rect.fromLTWH(0, 0, size.width * 0.6, size.height * 0.6))
      ..style = PaintingStyle.fill;
    
    final highlightPath = Path();
    highlightPath.addOval(
      Rect.fromLTWH(width * 0.15, height * 0.1, width * 0.4, height * 0.4),
    );
    
    canvas.drawPath(highlightPath, highlightPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
