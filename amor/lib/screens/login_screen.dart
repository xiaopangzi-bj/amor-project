import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
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
          backgroundColor: const Color(0xFFF8F6F0),
          body: SafeArea(
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
        );
      },
    );
  }

  Future<void> _signInWithGoogle(AuthProvider authProvider) async {
    try {
      final success = await authProvider.signInWithGoogle();
      if (success) {
        // 显示成功提示
        _showSuccessSnackBar('登录成功！正在跳转...');
        // 延迟一下再跳转，让用户看到成功提示
        await Future.delayed(const Duration(milliseconds: 500));
        _navigateToChat();
      } else {
        _showErrorDialog('Google登录失败', '登录过程被取消或失败，请重试');
      }
    } catch (e) {
      String errorMessage = '登录失败，请重试';
      
      // 根据错误类型提供更具体的错误信息
      if (e.toString().contains('网络')) {
        errorMessage = '网络连接失败，请检查网络后重试';
      } else if (e.toString().contains('验证失败')) {
        errorMessage = '身份验证失败，请重试';
      } else if (e.toString().contains('ID Token')) {
        errorMessage = 'Google认证失败，请重试';
      } else if (e.toString().contains('后端')) {
        errorMessage = '服务器验证失败，请稍后重试';
      }
      
      _showErrorDialog('登录失败', errorMessage);
    }
  }

  Future<void> _signInWithApple(AuthProvider authProvider) async {
    try {
      final success = await authProvider.signInWithApple();
      if (success) {
        _showSuccessSnackBar('登录成功！正在跳转...');
        await Future.delayed(const Duration(milliseconds: 500));
        _navigateToChat();
      } else {
        _showErrorDialog('Apple登录失败', '登录过程被取消或失败，请重试');
      }
    } catch (e) {
      String errorMessage = '登录失败，请重试';
      
      if (e.toString().contains('网络')) {
        errorMessage = '网络连接失败，请检查网络后重试';
      } else if (e.toString().contains('验证失败')) {
        errorMessage = '身份验证失败，请重试';
      }
      
      _showErrorDialog('登录失败', errorMessage);
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
        // App Logo
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFFE91E63),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE91E63).withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(Icons.favorite, size: 60, color: Colors.white),
        ),
        const SizedBox(height: 32),

        // 应用名称
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              Color(0xFFE91E63), // 深粉色
              Color(0xFFFF6B9D), // 亮粉色
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            'Amor',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white, // 这个颜色会被渐变覆盖
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 副标题
        const Text(
          '您的AI购物研究助手',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF7F8C8D),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),

        // 描述
        const Text(
          '智能推荐最适合您的商品',
          style: TextStyle(fontSize: 14, color: Color(0xFF95A5A6)),
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
        ] else ...[
          // 在 Android 上显示提示信息
          const SizedBox(height: 16),
          // _buildPlatformInfo(),
        ],
      ],
    );
  }

  Widget _buildPlatformInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: const Color(0xFF6C757D), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '苹果登录仅在 iOS 和 macOS 设备上可用',
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFF6C757D),
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
              '使用 Google 账户登录',
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
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE91E63)),
            strokeWidth: 2,
          ),
          SizedBox(height: 16),
          Text(
            '正在登录...',
            style: TextStyle(color: Color(0xFF7F8C8D), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const Text(
          '登录即表示您同意我们的',
          style: TextStyle(fontSize: 12, color: Color(0xFF95A5A6)),
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
                '服务条款',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFE91E63),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const Text(
              ' 和 ',
              style: TextStyle(fontSize: 12, color: Color(0xFF95A5A6)),
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
                '隐私政策',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFE91E63),
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
