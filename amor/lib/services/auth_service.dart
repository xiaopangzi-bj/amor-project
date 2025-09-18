import '../models/user.dart';
import 'api_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:math';

/// 认证服务类
/// 负责处理用户认证相关的所有操作，包括Google登录、登出、用户状态管理等
/// 使用单例模式确保全局只有一个认证服务实例
class AuthService {
  // 单例模式实现
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // 当前登录用户信息
  User? _currentUser;
  // 加载状态标识
  bool _isLoading = false;
  // Google Sign-In 实例
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  // API服务实例
  final ApiService _apiService = ApiService();

  /// 获取当前登录用户
  User? get currentUser => _currentUser;

  /// 获取加载状态
  bool get isLoading => _isLoading;

  /// 检查是否已登录
  bool get isLoggedIn => _currentUser != null;

  /// 初始化认证服务
  /// 在应用启动时调用，检查本地存储的登录状态
  /// 在实际应用中，这里会检查本地存储或安全存储中的用户信息
  Future<void> initialize() async {
    try {
      // 检查是否有已登录的 Google 用户
      final GoogleSignInAccount? googleUser = await _googleSignIn
          .signInSilently();
      if (googleUser != null) {
        _currentUser = User(
          id: googleUser.id,
          email: googleUser.email,
          name: googleUser.displayName ?? '',
          photoUrl: googleUser.photoUrl ?? '',
          displayName: googleUser.displayName ?? '',
        );
      }
      print('初始化认证服务');
    } catch (e) {
      print('初始化认证服务时出错: $e');
    }
  }

  /// Google登录方法
  /// 使用 Google Sign-In 插件执行Google OAuth登录流程，获取ID Token并进行后端验证
  /// @return 登录成功返回用户信息，失败返回null
  Future<User?> signInWithGoogle() async {
    try {
      _isLoading = true; // 设置加载状态

      // 第一步：使用 Google Sign-In 进行登录
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // 用户取消登录
        _isLoading = false;
        return null;
      }

      // 第二步：获取认证信息，包括ID Token
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      if (googleAuth.idToken == null) {
        throw Exception('无法获取Google ID Token');
      }

      print('获取到Google ID Token: ${googleAuth.idToken!.substring(0, 20)}...');

      // 第三步：将ID Token发送到后端进行验证
      try {
        final backendResponse = await _apiService.verifyGoogleToken(googleAuth.idToken!);
        
        // 第四步：使用后端返回的用户信息创建User对象
        if (backendResponse['success'] == true && backendResponse['user'] != null) {
          _currentUser = User.fromJson(backendResponse['user']);
          print('后端验证成功，用户信息: ${_currentUser!.email}');
        } else {
          throw Exception('后端验证失败: ${backendResponse['message'] ?? '未知错误'}');
        }
      } catch (apiError) {
        // 如果后端验证失败，回退到本地用户信息（可选）
        print('后端验证失败，使用本地用户信息: $apiError');
        
        // 可以选择是否允许离线模式
        // 这里我们仍然抛出异常，要求必须通过后端验证
        throw Exception('登录验证失败，请检查网络连接后重试');
        
        // 如果要支持离线模式，可以取消注释下面的代码：
        /*
        _currentUser = User(
          id: googleUser.id,
          email: googleUser.email,
          name: googleUser.displayName ?? '',
          photoUrl: googleUser.photoUrl ?? '',
          displayName: googleUser.displayName ?? '',
        );
        */
      }

      _isLoading = false; // 清除加载状态
      return _currentUser;
    } catch (e) {
      _isLoading = false; // 发生错误时也要清除加载状态
      print('Google登录失败: $e');
      rethrow; // 重新抛出异常供上层处理
    }
  }

  /// 苹果登录方法
  /// 使用 Apple Sign-In 插件执行苹果登录流程
  /// 仅在 iOS 和 macOS 平台上可用
  /// @return 登录成功返回用户信息，失败返回null
  Future<User?> signInWithApple() async {
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
        _currentUser = User(
          id: credential.userIdentifier!,
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
