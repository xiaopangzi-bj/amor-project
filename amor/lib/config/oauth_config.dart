import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Google OAuth 配置管理类
/// 统一管理不同平台的客户端ID配置
class OAuthConfig {
  // 开发环境配置
  static const String _devAndroidClientId = '163769271002-onpg6180ci63c6oijf3ig3uukq36pnto.apps.googleusercontent.com';
  static const String _devWebClientId = '163769271002-1eqcqsd72s23g0ujq4vdlvar7ekiu5gi.apps.googleusercontent.com';
  static const String _devIosClientId = '123456789012-abcdefghijklmnopqrstuvwxyz123456.apps.googleusercontent.com';
  
  // 生产环境配置 (从环境变量或配置文件读取)
  static const String _prodAndroidClientId = String.fromEnvironment('GOOGLE_ANDROID_CLIENT_ID', defaultValue: _devAndroidClientId);
  static const String _prodWebClientId = String.fromEnvironment('GOOGLE_WEB_CLIENT_ID', defaultValue: _devWebClientId);
  static const String _prodIosClientId = String.fromEnvironment('GOOGLE_IOS_CLIENT_ID', defaultValue: _devIosClientId);
  
  /// 是否为开发模式
  static const bool isDevelopment = kDebugMode;
  
  /// 获取当前平台的客户端ID
  static String get clientId {
    if (kIsWeb) {
      return webClientId;
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return androidClientId;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return iosClientId;
    }
    return webClientId; // 默认返回Web客户端ID
  }
  
  /// Android 客户端ID
  static String get androidClientId {
    return isDevelopment ? _devAndroidClientId : _prodAndroidClientId;
  }
  
  /// Web 客户端ID
  static String get webClientId {
    return isDevelopment ? _devWebClientId : _prodWebClientId;
  }
  
  /// iOS 客户端ID
  static String get iosClientId {
    return isDevelopment ? _devIosClientId : _prodIosClientId;
  }
  
  /// 获取所有平台的客户端ID
  static Map<String, String> get allClientIds {
    return {
      'android': androidClientId,
      'web': webClientId,
      'ios': iosClientId,
    };
  }
  
  /// 验证客户端ID是否为示例值
  static bool isExampleClientId(String clientId) {
    return clientId.contains('123456789012') || 
           clientId.contains('YOUR_') || 
           clientId.contains('EXAMPLE');
  }
  
  /// 验证当前配置是否有效
  static Map<String, bool> validateConfig() {
    return {
      'android': !isExampleClientId(androidClientId),
      'web': !isExampleClientId(webClientId),
      'ios': !isExampleClientId(iosClientId),
    };
  }
  
  /// 获取配置状态报告
  static String getConfigReport() {
    final validation = validateConfig();
    final buffer = StringBuffer();
    
    buffer.writeln('=== Google OAuth 配置状态 ===');
    buffer.writeln('环境: ${isDevelopment ? "开发" : "生产"}');
    buffer.writeln('当前平台: ${_getCurrentPlatformName()}');
    buffer.writeln('');
    
    validation.forEach((platform, isValid) {
      final status = isValid ? '✅ 已配置' : '❌ 需要配置';
      final clientId = allClientIds[platform] ?? '';
      buffer.writeln('$platform: $status');
      buffer.writeln('  客户端ID: ${_maskClientId(clientId)}');
    });
    
    return buffer.toString();
  }
  
  /// 获取当前平台名称
  static String _getCurrentPlatformName() {
    if (kIsWeb) return 'Web';
    if (defaultTargetPlatform == TargetPlatform.android) return 'Android';
    if (defaultTargetPlatform == TargetPlatform.iOS) return 'iOS';
    return 'Unknown';
  }
  
  /// 遮盖客户端ID的敏感部分
  static String _maskClientId(String clientId) {
    if (clientId.length < 20) return clientId;
    return '${clientId.substring(0, 10)}...${clientId.substring(clientId.length - 10)}';
  }
  
  /// OAuth 作用域
  static const List<String> scopes = [
    'email',
    'profile',
    'openid',
  ];
  
  /// 获取平台特定的配置
  static Map<String, dynamic> getPlatformConfig() {
    if (kIsWeb) {
      return {
        'clientId': webClientId,
        'scopes': scopes,
        'hostedDomain': null, // 可以设置特定域名限制
      };
    } else {
      return {
        'scopes': scopes,
        'hostedDomain': null,
      };
    }
  }
  
  /// 检查当前平台配置是否有效
  static bool isConfigValid() {
    final currentClientId = clientId;
    return !isExampleClientId(currentClientId);
  }
  
  /// 获取当前平台的配置信息
  static Map<String, dynamic> getCurrentPlatformConfig() {
    return {
      'clientId': clientId,
      'scopes': scopes,
      'platform': _getCurrentPlatformName().toLowerCase(),
      'hostedDomain': null,
    };
  }
}

/// OAuth 配置异常
class OAuthConfigException implements Exception {
  final String message;
  final String platform;
  
  const OAuthConfigException(this.message, this.platform);
  
  @override
  String toString() => 'OAuthConfigException [$platform]: $message';
}

/// OAuth 配置验证器
class OAuthConfigValidator {
  /// 验证配置并抛出异常（如果无效）
  static void validateOrThrow() {
    final validation = OAuthConfig.validateConfig();
    final currentPlatform = _getCurrentPlatform();
    
    if (!validation[currentPlatform]!) {
      throw OAuthConfigException(
        '当前平台 ($currentPlatform) 的客户端ID未正确配置，请检查配置文件',
        currentPlatform,
      );
    }
  }
  
  /// 获取当前平台标识
  static String _getCurrentPlatform() {
    if (kIsWeb) return 'web';
    if (defaultTargetPlatform == TargetPlatform.android) return 'android';
    if (defaultTargetPlatform == TargetPlatform.iOS) return 'ios';
    return 'unknown';
  }
  
  /// 检查是否所有平台都已配置
  static bool areAllPlatformsConfigured() {
    final validation = OAuthConfig.validateConfig();
    return validation.values.every((isValid) => isValid);
  }
  
  /// 获取未配置的平台列表
  static List<String> getUnconfiguredPlatforms() {
    final validation = OAuthConfig.validateConfig();
    return validation.entries
        .where((entry) => !entry.value)
        .map((entry) => entry.key)
        .toList();
  }
}