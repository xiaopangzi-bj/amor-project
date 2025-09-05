import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkExistingLogin();
  }

  Future<void> _checkExistingLogin() async {
    await _authService.initialize();
    if (_authService.isLoggedIn) {
      _navigateToChat();
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final User? user = await _authService.signInWithGoogle();
      if (user != null) {
        _navigateToChat();
      }
    } catch (e) {
      _showErrorDialog('登录失败: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToChat() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const ChatScreen()),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('错误'),
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

  @override
  Widget build(BuildContext context) {
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
              _buildLoginButton(),
              const SizedBox(height: 24),
              
              // 加载指示器
              if (_isLoading) _buildLoadingIndicator(),
              
              const Spacer(flex: 3),
              
              // 底部说明
              _buildFooter(),
            ],
          ),
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
            color: const Color(0xFFFF6B6B),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B6B).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.favorite,
            size: 60,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 32),
        
        // 应用名称
        const Text(
          'Amor',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
            letterSpacing: 2,
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
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF95A5A6),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _signInWithGoogle,
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
            // Google Logo (使用图标代替网络图片)
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
                color: _isLoading ? Colors.grey : const Color(0xFF2C3E50),
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
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B6B)),
            strokeWidth: 2,
          ),
          SizedBox(height: 16),
          Text(
            '正在登录...',
            style: TextStyle(
              color: Color(0xFF7F8C8D),
              fontSize: 14,
            ),
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
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF95A5A6),
          ),
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
                  color: Color(0xFFFF6B6B),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const Text(
              ' 和 ',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF95A5A6),
              ),
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
                  color: Color(0xFFFF6B6B),
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
