import '../models/user.dart' as app_models;
import 'api_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../config/oauth_config.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:async';
// 移除dart:js导入以避免平台兼容性问题

/// 认证服务类
/// 负责处理用户认证相关的所有操作，包括Google登录、登出、用户状态管理等
/// 使用单例模式确保全局只有一个认证服务实例
class AuthService {
  // 单例模式实现
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal() {
    _initializeGoogleSignIn();
  }

  // 当前登录用户信息
  app_models.User? _currentUser;
  // 加载状态标识
  bool _isLoading = false;
  // Google Sign-In 实例
  late final GoogleSignIn _googleSignIn;
  // API服务实例
  final ApiService _apiService = ApiService();

  /// 初始化Google Sign-In配置
  void _initializeGoogleSignIn() {
    try {
      print('=== 初始化Google Sign-In ===');
      
      // 验证OAuth配置
      if (!OAuthConfig.isConfigValid()) {
        print('警告: OAuth配置使用示例值，请更新为真实的客户端ID');
      }

      // 获取当前平台的配置
      final config = OAuthConfig.getCurrentPlatformConfig();
      print('平台配置: $config');
      
      // Web平台也需要clientId参数来确保正确的OAuth配置
      if (kIsWeb) {
        print('Web平台初始化 - 客户端ID: ${config['clientId']}');
        _googleSignIn = GoogleSignIn(
          clientId: config['clientId'],
          scopes: config['scopes'],
        );
        print('Web平台Google Sign-In初始化完成，作用域: ${config['scopes']}');
      } else {
        // Android和iOS平台需要clientId
        print('Native平台初始化 - 客户端ID: ${config['clientId']}');
        _googleSignIn = GoogleSignIn(
          clientId: config['clientId'],
          scopes: config['scopes'],
        );
        print('Native平台Google Sign-In初始化完成，作用域: ${config['scopes']}');
      }
      
      print('Google Sign-In 初始化成功，平台: ${config['platform']}');
    } catch (e) {
      print('=== Google Sign-In 初始化错误 ===');
      print('错误信息: $e');
      print('使用默认配置作为后备');
      // 使用默认配置作为后备
      _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
    }
  }

  /// 获取当前登录用户
  app_models.User? get currentUser => _currentUser;

  /// 获取加载状态
  bool get isLoading => _isLoading;

  /// 检查是否已登录
  bool get isLoggedIn => _currentUser != null;

  /// 初始化认证服务
  /// 在应用启动时调用，检查本地存储的登录状态
  /// 在实际应用中，这里会检查本地存储或安全存储中的用户信息
  Future<void> initialize() async {
    try {
      print('开始初始化认证服务...');
      
      // 添加超时机制
      await Future.any([
        _performGoogleSignInCheck(),
        Future.delayed(const Duration(seconds: 8), () {
          throw TimeoutException('Google Sign-In检查超时', const Duration(seconds: 8));
        }),
      ]);
      
      print('认证服务初始化完成');
    } catch (e) {
      print('初始化认证服务时出错: $e');
      // 不重新抛出异常，让应用继续运行
    }
  }

  /// 执行Google Sign-In静默登录检查
  Future<void> _performGoogleSignInCheck() async {
    try {
      // 检查是否有已登录的 Google 用户
      final GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();
      if (googleUser != null) {
        _currentUser = app_models.User(
          id: googleUser.id,
          email: googleUser.email,
          name: googleUser.displayName ?? '',
          photoUrl: googleUser.photoUrl ?? '',
          displayName: googleUser.displayName ?? '',
        );
        print('发现已登录用户: ${googleUser.email}');
      } else {
        print('未发现已登录用户');
      }
    } catch (e) {
      print('Google Sign-In静默登录检查失败: $e');
      // 不重新抛出异常
    }
  }

  /// 启用Google提示（仅Web平台）
  void _enableGooglePrompt() {
    if (kIsWeb) {
      try {
        // 使用动态调用来设置window属性（仅在Web平台可用）
        _setJsProperty('allowGooglePrompt', true);
      } catch (e) {
        print('启用Google提示失败: $e');
      }
    }
  }

  /// 禁用Google提示（仅Web平台）
  void _disableGooglePrompt() {
    if (kIsWeb) {
      try {
        // 使用动态调用来设置window属性（仅在Web平台可用）
        _setJsProperty('allowGooglePrompt', false);
      } catch (e) {
        print('禁用Google提示失败: $e');
      }
    }
  }

  /// 设置JavaScript属性的辅助方法（仅Web平台）
  void _setJsProperty(String property, dynamic value) {
    if (kIsWeb) {
      try {
        // 在Web平台设置window属性（简化实现，避免dart:js依赖）
        print('设置Web属性: $property = $value');
        // 注意：实际的JavaScript调用已移除以避免平台兼容性问题
      } catch (e) {
        print('设置JS属性失败: $e');
      }
    }
  }

  /// Google登录方法
  /// 使用 Google Sign-In 插件执行Google OAuth登录流程，获取ID Token并进行后端验证
  /// @return 登录成功返回用户信息，失败返回null
  Future<app_models.User?> signInWithGoogle() async {
    // 防止重复登录
    if (_isLoading) {
      print('登录正在进行中，请勿重复点击');
      return null;
    }
    
    try {
      _isLoading = true; // 设置加载状态
      
      // 在Web平台临时启用Google提示
      if (kIsWeb) {
        _enableGooglePrompt();
      }
      
      // 调试信息：打印当前配置
      print('=== Google Sign-In 调试信息 ===');
      print('当前平台: ${kIsWeb ? "Web" : "Native"}');
      print('OAuth配置有效性: ${OAuthConfig.isConfigValid()}');
      
      if (kIsWeb) {
        print('Web平台配置信息:');
        print('- 客户端ID通过 web/index.html 配置');
        print('- 当前域名: ${Uri.base.host}:${Uri.base.port}');
        print('- 协议: ${Uri.base.scheme}');
      } else {
        final config = OAuthConfig.getCurrentPlatformConfig();
        print('Native平台配置: $config');
      }

      // 确保之前的登录状态被清除
      await _googleSignIn.signOut();
      
      // 第一步：使用 Google Sign-In 进行登录
      print('开始Google登录流程...');
      GoogleSignInAccount? googleUser;
      
      try {
        print('正在启动Google登录界面...');
        googleUser = await _googleSignIn.signIn();
      } on PlatformException catch (platformError) {
        print('平台异常: ${platformError.code} - ${platformError.message}');
        if (platformError.code == 'sign_in_canceled') {
          print('用户取消了登录');
          return null;
        } else if (platformError.code == 'sign_in_failed') {
          print('登录失败，可能是网络问题或配置问题');
          return null;
        } else if (platformError.code == 'network_error') {
          print('网络连接错误');
          return null;
        }
        rethrow;
      } catch (signInError) {
        print('Google登录过程中出错: $signInError');
        print('错误类型: ${signInError.runtimeType}');
        if (signInError.toString().contains('aborted')) {
          print('登录被中止，可能是用户取消或网络问题');
          return null;
        }
        rethrow;
      }

      if (googleUser == null) {
        // 用户取消登录
        print('用户取消了Google登录');
        _isLoading = false;
        
        // 在Web平台禁用Google提示
        if (kIsWeb) {
          _disableGooglePrompt();
        }
        
        return null;
      }

      print('Google登录成功，用户信息:');
      print('- ID: ${googleUser.id}');
      print('- Email: ${googleUser.email}');
      print('- 显示名称: ${googleUser.displayName}');

      // 第二步：获取认证信息，包括ID Token
      print('获取Google认证信息...');
      GoogleSignInAuthentication? googleAuth;
      
      try {
        googleAuth = await googleUser.authentication;
      } catch (authError) {
        print('获取认证信息时出错: $authError');
        print('错误类型: ${authError.runtimeType}');
        if (authError.toString().contains('aborted')) {
          print('认证过程被中止');
          return null;
        }
        throw Exception('获取认证信息失败: $authError');
      }
      
      print('获取到Google认证信息');
      if (googleAuth.idToken == null) {
        print('错误: 无法获取Google ID Token');
        throw Exception('无法获取Google ID Token');
      }
      
      if (googleAuth.accessToken == null) {
        print('警告: 无法获取Google Access Token');
      }

      print('获取到Google ID Token: ${googleAuth.idToken?.substring(0, 20)}...');
      print('Access Token: ${googleAuth.accessToken?.substring(0, 20) ?? "未获取到"}...');

      // 第三步：将ID Token发送到后端进行验证
      try {
        print('正在向后端验证Google Token...');
        final backendResponse = await _apiService.verifyGoogleToken(googleAuth.idToken!);
        
        // 使用后端返回的用户信息创建User对象
        if (backendResponse['success'] == true && backendResponse['user'] != null) {
          _currentUser = app_models.User.fromJson(backendResponse['user']);
          print('后端验证成功，用户信息: ${_currentUser?.email}');
        } else {
          throw Exception('后端验证失败: ${backendResponse['message'] ?? '未知错误'}');
        }
      } catch (apiError) {
        // 如果后端验证失败，回退到本地用户信息（可选）
        print('后端验证失败: $apiError');
        print('错误类型: ${apiError.runtimeType}');
        
        // 可以选择是否允许离线模式
        // 这里我们仍然抛出异常，要求必须通过后端验证
        throw Exception('登录验证失败，请检查网络连接后重试');
        
        // 如果要支持离线模式，可以取消注释下面的代码：
        /*
        _currentUser = app_models.User(
          id: googleUser.id,
          email: googleUser.email,
          name: googleUser.displayName ?? '',
          photoUrl: googleUser.photoUrl ?? '',
          displayName: googleUser.displayName ?? '',
        );
        */
      }

      _isLoading = false; // 清除加载状态
      
      // 在Web平台禁用Google提示
      if (kIsWeb) {
        _disableGooglePrompt();
      }
      
      print('Google登录流程完成，用户: ${_currentUser?.email}');
      return _currentUser;
    } catch (e) {
      // 确保加载状态被清除
      if (_isLoading) {
        _isLoading = false;
      }
      
      // 在Web平台禁用Google提示
      if (kIsWeb) {
        try {
          _disableGooglePrompt();
        } catch (disableError) {
          print('禁用Google提示时出错: $disableError');
        }
      }
      
      // 清理Google登录状态
      try {
        await _googleSignIn.signOut();
      } catch (signOutError) {
        print('清理Google登录状态时出错: $signOutError');
      }
      
      print('=== Google登录错误详情 ===');
      print('错误类型: ${e.runtimeType}');
      print('错误信息: $e');
      
      // 检查常见的错误类型
      if (e.toString().contains('network_error')) {
        print('网络错误: 请检查网络连接');
        return null; // 网络错误时返回null而不是抛出异常
      } else if (e.toString().contains('sign_in_canceled') || 
                 e.toString().contains('aborted')) {
        print('用户取消了登录或操作被中止');
        return null; // 用户取消时返回null
      } else if (e.toString().contains('sign_in_failed')) {
        print('登录失败: 可能是配置问题');
      } else if (e.toString().contains('popup_blocked')) {
        print('弹窗被阻止: 请允许弹窗');
      } else if (e.toString().contains('Future already completed')) {
        print('异步操作重复完成错误，这通常是由于多次调用导致的');
        return null; // 对于Future已完成的错误，返回null
      } else if (e.toString().contains('timeout')) {
        print('操作超时: 请检查网络连接或稍后重试');
        return null;
      }
      
      print('=== 调试建议 ===');
      print('1. 检查 web/index.html 中的客户端ID配置');
      print('2. 确认当前域名已添加到Google Console的授权域名');
      print('3. 检查浏览器控制台是否有CORS错误');
      print('4. 确认Google API已启用');
      print('5. 避免快速重复点击登录按钮');
      print('6. 检查网络连接是否稳定');
      
      // 对于严重错误才重新抛出异常
      if (!e.toString().contains('canceled') && 
          !e.toString().contains('aborted') &&
          !e.toString().contains('network_error') &&
          !e.toString().contains('timeout') &&
          !e.toString().contains('Future already completed')) {
        rethrow;
      }
      
      return null;
    }
  }

  /// 苹果登录方法
  /// 使用 Apple Sign-In 插件执行苹果登录流程
  /// 仅在 iOS 和 macOS 平台上可用
  /// @return 登录成功返回用户信息，失败返回null
  Future<app_models.User?> signInWithApple() async {
    // 检查是否在支持的平台上
    if (defaultTargetPlatform != TargetPlatform.iOS &&
        defaultTargetPlatform != TargetPlatform.macOS) {
      throw UnsupportedError('苹果登录仅在 iOS 和 macOS 平台上支持');
    }

    try {
      _isLoading = true; // 设置加载状态

      // 生成随机字符串作为 nonce
      final rawNonce = _generateNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      // 使用 Apple Sign-In 进行登录
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      if (credential.userIdentifier != null &&
          credential.userIdentifier!.isNotEmpty) {
        // 创建用户数据
        _currentUser = app_models.User(
          id: credential.userIdentifier ?? '',
          email: credential.email ?? '',
          name: '${credential.givenName ?? ''} ${credential.familyName ?? ''}'
              .trim(),
          photoUrl: '', // Apple 不提供头像
          displayName:
              '${credential.givenName ?? ''} ${credential.familyName ?? ''}'
                  .trim(),
        );
      }

      _isLoading = false; // 清除加载状态
      return _currentUser;
    } catch (e) {
      _isLoading = false; // 发生错误时也要清除加载状态
      print('苹果登录失败: $e');
      rethrow; // 重新抛出异常供上层处理
    }
  }

  /// 生成随机 nonce 用于 Apple Sign-In
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  /// 用户登出方法
  /// 清除当前用户信息并执行登出操作，包括后端登出
  Future<void> signOut() async {
    try {
      _isLoading = true; // 设置加载状态
      
      // 第一步：通知后端用户登出
      try {
        await _apiService.logout();
        print('后端登出成功');
      } catch (e) {
        print('后端登出失败: $e');
        // 继续执行本地登出，不因后端失败而中断
      }
      
      // 第二步：登出 Google 账户
      await _googleSignIn.signOut();
      
      // 第三步：断开连接，确保完全登出
      await _googleSignIn.disconnect();
      
      // 第四步：清除本地状态
      _currentUser = null; // 清除当前用户信息
      _isLoading = false; // 清除加载状态
      
      print('Google账户登出成功');
    } catch (e) {
      _isLoading = false; // 发生错误时也要清除加载状态
      _currentUser = null; // 即使出错也要清除用户信息，避免状态不一致
      print('登出过程中出现错误: $e');
      // 不重新抛出异常，让上层能够正常处理登出流程
    }
  }

  /// 检查Google登录状态
  /// @return 如果用户已登录返回true，否则返回false
  Future<bool> isGoogleSignedIn() async {
    return _currentUser != null;
  }
}
