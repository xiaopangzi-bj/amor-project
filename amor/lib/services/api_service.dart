import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/product.dart';

/// API服务类
/// 负责处理与后端服务器的所有HTTP通信
class ApiService {
  // 单例模式实现
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Backend API base URL - configured to your server address
  static const String _baseUrl = 'http://18.166.177.4:8080';
  
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

  /// 获取盲盒列表
  /// 请求路径: /api/blind-boxes
  /// 返回: List<dynamic>（服务端返回的原始结构），如需强类型可后续接入模型
  Future<List<dynamic>> getBlindBoxes() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/api/blind-boxes'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // 兼容服务端返回数组或包裹对象的两种情况
        if (data is List) return data;
        if (data is Map<String, dynamic>) {
          // 常见结构: { list: [...], data: [...] }
          if (data['list'] is List) return List<dynamic>.from(data['list']);
          if (data['data'] is List) return List<dynamic>.from(data['data']);
        }
        // 无法识别结构时，包裹为单元素列表返回
        return [data];
      } else {
        throw ApiException(
          'Failed to fetch blind boxes',
          response.statusCode,
          response.body,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network request failed', 0, e.toString());
    }
  }

  /// 分页获取商品列表
  /// 请求路径: /api/products/list
  /// 参数: page(默认1), pageSize(默认20), filters(可选筛选条件)
  /// 返回: 包含商品列表(items)与原始响应(raw)及可用的分页信息
  Future<Map<String, dynamic>> getProductsList({
    int page = 1,
    int pageSize = 20,
    Map<String, dynamic>? filters,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/api/products/list'),
        headers: _headers,
        body: jsonEncode({
          'page': page,
          'pageSize': pageSize,
          if (filters != null) ...filters,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // 后端标准结构: { code, msg, data: { total, current, pages, size, records: [...] } }
        Map<String, dynamic>? inner;
        if (data is Map<String, dynamic>) {
          if (data['data'] is Map<String, dynamic>) {
            inner = Map<String, dynamic>.from(data['data']);
          }
        }

        dynamic listData;
        if (inner != null && inner['records'] is List) {
          listData = inner['records'];
        } else if (data is List) {
          listData = data;
        } else if (data is Map<String, dynamic>) {
          listData = data['list'] ?? data['items'];
        }

        List<Product> items = [];
        if (listData is List) {
          items = List<Product>.from(
            listData.map((e) => Product.fromJson(Map<String, dynamic>.from(e))),
          );
        }

        final currentPage = inner != null ? (inner['current'] ?? page) : (data is Map<String, dynamic> ? (data['page'] ?? page) : page);
        final sizeVal = inner != null ? (inner['size'] ?? pageSize) : (data is Map<String, dynamic> ? (data['pageSize'] ?? pageSize) : pageSize);
        final totalVal = inner != null ? (inner['total'] ?? items.length) : (data is Map<String, dynamic> ? (data['total'] ?? items.length) : items.length);

        return {
          'items': items,
          'raw': data,
          'page': currentPage,
          'pageSize': sizeVal,
          'total': totalVal,
        };
      } else {
        throw ApiException(
          '获取商品列表失败',
          response.statusCode,
          response.body,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('网络请求失败', 0, e.toString());
    }
  }

  /// 获取热销推荐商品（页面默认加载）
  /// 请求路径: /api/products/list
  /// 固定参数: queryType=1（热销/推荐），size（返回商品数量）
  /// 返回: 与 getProductsList 相同的结构
  Future<Map<String, dynamic>> getHotSaleProducts({int size = 3}) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/api/products/list'),
        headers: _headers,
        body: jsonEncode({
          'queryType': 1,
          'size': size,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // 统一解析 { data: { records: [...], current, size, total } }
        Map<String, dynamic>? inner;
        if (data is Map<String, dynamic> && data['data'] is Map<String, dynamic>) {
          inner = Map<String, dynamic>.from(data['data']);
        }

        dynamic listData;
        if (inner != null && inner['records'] is List) {
          listData = inner['records'];
        } else if (data is List) {
          listData = data;
        } else if (data is Map<String, dynamic>) {
          listData = data['list'] ?? data['items'];
        }

        List<Product> items = [];
        if (listData is List) {
          items = List<Product>.from(
            listData.map((e) => Product.fromJson(Map<String, dynamic>.from(e))),
          );
        }

        return {
          'items': items,
          'raw': data,
          'page': inner != null ? (inner['current'] ?? 1) : 1,
          'pageSize': inner != null ? (inner['size'] ?? size) : size,
          'total': inner != null ? (inner['total'] ?? items.length) : (data is Map<String, dynamic> ? (data['total'] ?? items.length) : items.length),
        };
      } else {
        throw ApiException(
          '获取热销推荐失败',
          response.statusCode,
          response.body,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('网络请求失败', 0, e.toString());
    }
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