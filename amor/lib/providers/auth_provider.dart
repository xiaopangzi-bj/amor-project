import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;
  bool _isInitialized = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  bool get isInitialized => _isInitialized;

  // 初始化认证状态
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.initialize();
      _user = _authService.currentUser;
    } catch (e) {
      debugPrint('初始化认证状态失败: $e');
    } finally {
      _isLoading = false;
      _isInitialized = true;
      notifyListeners();
    }
  }

  // Google登录
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        _user = user;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('Google登录失败: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // 登出
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signOut();
      _user = null;
    } catch (e) {
      debugPrint('登出失败: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 更新用户信息
  void updateUser(User user) {
    _user = user;
    notifyListeners();
  }

  // 清除用户数据
  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
