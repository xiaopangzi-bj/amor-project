import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

/// API服务类
/// 负责处理与后端服务器的所有HTTP通信
class ApiService {
  // 单例模式实现
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // 后端API基础URL - 请根据实际情况修改
  static const String _baseUrl = 'http://192.168.100.39:8080';
  
  // HTTP客户端
  final http.Client _client = http.Client();
  
  // 认证Token
  String? _authToken;

  /// 设置认证Token
  void setAuthToken(String token) {
    _authToken = token;
  }

  /// 清除认证Token
  void clearAuthToken() {
    _authToken = null;
  }

  /// 获取通用请求头
  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    
    return headers;
  }

  /// Google登录验证
  /// 将Google ID Token发送到后端进行验证
  /// @param idToken Google ID Token
  /// @return 验证成功返回用户信息和JWT Token
  Future<Map<String, dynamic>> verifyGoogleToken(String idToken) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/login'),
        headers: _headers,
        body: jsonEncode({
          'id_token': idToken,
          'platform': 'mobile', // 标识来源平台
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // 保存后端返回的JWT Token
        if (data['token'] != null) {
          setAuthToken(data['token']);
        }
        
        return data;
      } else {
        throw ApiException(
          'Google登录验证失败',
          response.statusCode,
          response.body,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('网络请求失败', 0, e.toString());
    }
  }

  /// Apple登录验证
  /// 将Apple Identity Token发送到后端进行验证
  /// @param identityToken Apple Identity Token (JWT)
  /// @return 验证成功返回用户信息和JWT Token
  Future<Map<String, dynamic>> verifyAppleToken(String identityToken) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/login/apple'),
        headers: _headers,
        body: jsonEncode({
          'identity_token': identityToken,
          'platform': 'ios', // 标识来源平台
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // 保存后端返回的JWT Token
        if (data['token'] != null) {
          setAuthToken(data['token']);
        }

        return data;
      } else {
        throw ApiException(
          'Apple登录验证失败',
          response.statusCode,
          response.body,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('网络请求失败', 0, e.toString());
    }
  }

  /// 刷新用户Token
  /// 当Token即将过期时调用
  Future<Map<String, dynamic>> refreshToken() async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/auth/refresh'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // 更新Token
        if (data['token'] != null) {
          setAuthToken(data['token']);
        }
        
        return data;
      } else {
        throw ApiException(
          'Token刷新失败',
          response.statusCode,
          response.body,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('网络请求失败', 0, e.toString());
    }
  }

  /// 获取用户信息
  /// 从后端获取最新的用户信息
  Future<User> getUserInfo() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/user/profile'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data['user']);
      } else {
        throw ApiException(
          '获取用户信息失败',
          response.statusCode,
          response.body,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('网络请求失败', 0, e.toString());
    }
  }

  /// 用户登出
  /// 通知后端用户登出，使Token失效
  Future<void> logout() async {
    try {
      await _client.post(
        Uri.parse('$_baseUrl/auth/logout'),
        headers: _headers,
      );
      
      // 清除本地Token
      clearAuthToken();
    } catch (e) {
      // 登出失败也要清除本地Token
      clearAuthToken();
      print('登出请求失败: $e');
    }
  }

  /// 验证Token是否有效
  /// 检查当前Token是否仍然有效
  Future<bool> validateToken() async {
    if (_authToken == null) return false;
    
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/auth/validate'),
        headers: _headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// 释放资源
  void dispose() {
    _client.close();
  }
}

/// API异常类
/// 用于处理API调用过程中的各种异常情况
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final String details;

  ApiException(this.message, this.statusCode, this.details);

  @override
  String toString() {
    return 'ApiException: $message (Status: $statusCode) - $details';
  }
}