import '../models/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  // 初始化时检查是否已经登录
  Future<void> initialize() async {
    try {
      // 模拟检查本地存储的登录状态
      // 在实际应用中，这里会检查本地存储或安全存储中的用户信息
      print('初始化认证服务');
    } catch (e) {
      print('初始化认证服务时出错: $e');
    }
  }

  // Google登录（模拟实现）
  Future<User?> signInWithGoogle() async {
    try {
      _isLoading = true;
      
      // 模拟Google登录过程
      await Future.delayed(const Duration(seconds: 2));
      
      // 创建模拟用户数据
      _currentUser = User(
        id: '123456789',
        email: 'user@example.com',
        name: '测试用户',
        photoUrl: 'https://via.placeholder.com/150/FF6B6B/FFFFFF?text=U',
        displayName: '测试用户',
      );
      
      _isLoading = false;
      return _currentUser;
    } catch (e) {
      _isLoading = false;
      print('Google登录失败: $e');
      rethrow;
    }
  }

  // 登出
  Future<void> signOut() async {
    try {
      _isLoading = true;
      await Future.delayed(const Duration(milliseconds: 500));
      _currentUser = null;
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      print('登出失败: $e');
      rethrow;
    }
  }

  // 获取Google登录状态
  Future<bool> isGoogleSignedIn() async {
    return _currentUser != null;
  }
}
