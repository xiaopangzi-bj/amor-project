// Flutter基础包，提供调试和通知功能
import 'package:flutter/foundation.dart';
// 用户数据模型
import '../models/user.dart';
// 认证服务
import '../services/auth_service.dart';

/// 认证状态管理器
/// 使用Provider模式管理用户认证状态，包括登录、登出、用户信息等
/// 继承ChangeNotifier以支持状态变化通知
class AuthProvider with ChangeNotifier {
  /// 认证服务实例，处理具体的认证逻辑
  final AuthService _authService = AuthService();

  /// 当前登录用户信息，null表示未登录
  User? _user;

  /// 是否正在执行认证相关操作（登录、登出等）
  bool _isLoading = false;

  /// 认证状态是否已初始化
  bool _isInitialized = false;

  /// 获取当前用户信息
  User? get user => _user;

  /// 获取加载状态
  bool get isLoading => _isLoading;

  /// 判断用户是否已登录
  bool get isLoggedIn => _user != null;

  /// 判断认证状态是否已初始化
  bool get isInitialized => _isInitialized;

  /// 初始化认证状态
  /// 在应用启动时调用，检查是否有已保存的登录状态
  /// 避免重复初始化，提高性能
  Future<void> initialize() async {
    // 如果已经初始化过，直接返回
    if (_isInitialized) return;

    // 设置加载状态并通知监听者
    _isLoading = true;
    notifyListeners();

    try {
      // 初始化认证服务
      await _authService.initialize();
      // 获取当前用户信息（如果有的话）
      _user = _authService.currentUser;
    } catch (e) {
      // 记录初始化失败的错误信息
      debugPrint('初始化认证状态失败: $e');
    } finally {
      // 无论成功失败，都要更新状态
      _isLoading = false;
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// 使用Google账号登录
  /// 调用认证服务进行Google登录，成功后更新用户状态
  /// @return 登录是否成功
  Future<bool> signInWithGoogle() async {
    // 设置加载状态
    _isLoading = true;
    notifyListeners();

    try {
      // 调用认证服务进行Google登录
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        // 登录成功，保存用户信息
        _user = user;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      // 记录登录失败的错误信息
      debugPrint('Google登录失败: $e');
    }

    // 登录失败，重置加载状态
    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// 使用苹果账号登录
  /// 调用认证服务进行苹果登录，成功后更新用户状态
  /// 仅在 iOS 和 macOS 平台上可用
  /// @return 登录是否成功
  Future<bool> signInWithApple() async {
    // 检查是否在支持的平台上
    if (defaultTargetPlatform != TargetPlatform.iOS &&
        defaultTargetPlatform != TargetPlatform.macOS) {
      debugPrint('苹果登录仅在 iOS 和 macOS 平台上支持');
      return false;
    }

    // 设置加载状态
    _isLoading = true;
    notifyListeners();

    try {
      // 调用认证服务进行苹果登录
      final user = await _authService.signInWithApple();
      if (user != null) {
        // 登录成功，保存用户信息
        _user = user;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      // 记录登录失败的错误信息
      debugPrint('苹果登录失败: $e');
    }

    // 登录失败，重置加载状态
    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// 用户登出
  /// 清除本地用户信息并调用认证服务登出
  Future<void> signOut() async {
    // 设置加载状态
    _isLoading = true;
    notifyListeners();

    try {
      // 调用认证服务登出
      await _authService.signOut();
      // 清除本地用户信息
      _user = null;
      // 重置初始化状态，确保下次启动时重新初始化
      _isInitialized = false;
      debugPrint('用户登出成功');
    } catch (e) {
      // 记录登出失败的错误信息
      debugPrint('登出失败: $e');
      // 即使登出失败，也要清除本地用户状态，避免状态不一致
      _user = null;
      _isInitialized = false;
    } finally {
      // 重置加载状态并通知监听者
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 更新用户信息
  /// 当用户信息发生变化时调用，如头像、昵称等
  /// @param user 新的用户信息
  void updateUser(User user) {
    _user = user;
    notifyListeners();
  }

  /// 清除用户数据
  /// 在登出或需要重置用户状态时调用
  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
