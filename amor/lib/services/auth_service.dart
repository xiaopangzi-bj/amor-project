import '../models/user.dart';

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
      // 模拟检查本地存储的登录状态
      // 在实际应用中，这里会检查本地存储或安全存储中的用户信息
      print('初始化认证服务');
    } catch (e) {
      print('初始化认证服务时出错: $e');
    }
  }

  /// Google登录方法（模拟实现）
  /// 执行Google OAuth登录流程
  /// @return 登录成功返回用户信息，失败返回null
  Future<User?> signInWithGoogle() async {
    try {
      _isLoading = true; // 设置加载状态
      
      // 模拟Google登录过程，实际应用中会调用Google Sign-In API
      await Future.delayed(const Duration(seconds: 2));
      
      // 创建模拟用户数据
      // 在实际应用中，这些数据来自Google账户信息
      _currentUser = User(
        id: '123456789',
        email: 'user@example.com',
        name: '测试用户',
        photoUrl: 'https://via.placeholder.com/150/FF6B6B/FFFFFF?text=U',
        displayName: '测试用户',
      );
      
      _isLoading = false; // 清除加载状态
      return _currentUser;
    } catch (e) {
      _isLoading = false; // 发生错误时也要清除加载状态
      print('Google登录失败: $e');
      rethrow; // 重新抛出异常供上层处理
    }
  }

  /// 用户登出方法
  /// 清除当前用户信息并执行登出操作
  Future<void> signOut() async {
    try {
      _isLoading = true; // 设置加载状态
      // 模拟登出过程，实际应用中会调用相关API清除认证信息
      await Future.delayed(const Duration(milliseconds: 500));
      _currentUser = null; // 清除当前用户信息
      _isLoading = false; // 清除加载状态
    } catch (e) {
      _isLoading = false; // 发生错误时也要清除加载状态
      print('登出失败: $e');
      rethrow; // 重新抛出异常供上层处理
    }
  }

  /// 检查Google登录状态
  /// @return 如果用户已登录返回true，否则返回false
  Future<bool> isGoogleSignedIn() async {
    return _currentUser != null;
  }
}
