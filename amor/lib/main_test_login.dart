import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google登录测试',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginTestPage(),
    );
  }
}

class LoginTestPage extends StatefulWidget {
  @override
  _LoginTestPageState createState() => _LoginTestPageState();
}

class _LoginTestPageState extends State<LoginTestPage> {
  String _status = '准备测试Google登录';
  bool _isLoading = false;

  Future<void> _testGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _status = '开始Google登录测试...';
    });

    try {
      print('=== Google登录测试开始 ===');
      
      // 创建GoogleSignIn实例
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      setState(() {
        _status = '正在启动Google登录界面...';
      });
      print('正在启动Google登录界面...');

      // 尝试登录
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        setState(() {
          _status = '用户取消了登录';
          _isLoading = false;
        });
        print('用户取消了登录');
        return;
      }

      setState(() {
        _status = '登录成功！用户: ${googleUser.email}';
      });
      print('Google登录成功: ${googleUser.email}');

      // 获取认证信息
      setState(() {
        _status = '正在获取认证信息...';
      });
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      setState(() {
        _status = '认证信息获取成功！\n'
                 '用户: ${googleUser.email}\n'
                 'ID Token: ${googleAuth.idToken?.substring(0, 20)}...\n'
                 'Access Token: ${googleAuth.accessToken?.substring(0, 20)}...';
        _isLoading = false;
      });
      
      print('认证信息获取成功');
      print('ID Token: ${googleAuth.idToken?.substring(0, 50)}...');
      print('Access Token: ${googleAuth.accessToken?.substring(0, 50)}...');

    } on PlatformException catch (e) {
      setState(() {
        _status = '平台异常: ${e.code}\n消息: ${e.message}';
        _isLoading = false;
      });
      print('平台异常: ${e.code} - ${e.message}');
      
      if (e.code == 'sign_in_canceled') {
        print('用户取消了登录');
      } else if (e.code == 'sign_in_failed') {
        print('登录失败，可能是配置问题');
      } else if (e.code == 'network_error') {
        print('网络连接错误');
      }
    } catch (e) {
      setState(() {
        _status = '未知错误: $e\n错误类型: ${e.runtimeType}';
        _isLoading = false;
      });
      print('Google登录未知错误: $e');
      print('错误类型: ${e.runtimeType}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google登录测试'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 30),
            Text(
              'Google登录功能测试',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _status,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isLoading ? null : _testGoogleSignIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: _isLoading
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text('测试中...'),
                      ],
                    )
                  : Text(
                      '测试Google登录',
                      style: TextStyle(fontSize: 18),
                    ),
            ),
            SizedBox(height: 20),
            Text(
              '这个测试版本会显示详细的登录过程和错误信息',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}