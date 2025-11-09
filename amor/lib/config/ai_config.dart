import 'package:flutter/foundation.dart';
import 'prompt_config.dart';

/// AI 配置
/// 通过 dart-define 注入环境变量，以支持不同平台安全传递密钥
class AIConfig {
  /// DeepSeek API Key（运行时通过 --dart-define 注入）
  static const String deepseekApiKey =
      String.fromEnvironment('DEEPSEEK_API_KEY', defaultValue: '');

  /// DeepSeek 模型（默认为 deepseek-chat）
  static const String deepseekModel =
      String.fromEnvironment('DEEPSEEK_MODEL', defaultValue: 'deepseek-chat');

  /// DeepSeek 基础地址（OpenAI 兼容风格的 chat completions 接口）
  static const String deepseekBaseUrl = String.fromEnvironment(
      'DEEPSEEK_BASE_URL',
      defaultValue: 'https://api.deepseek.com');

  /// 是否已配置有效的 API Key
  static bool get isConfigured => deepseekApiKey.isNotEmpty;

  /// 系统提示词（可用 --dart-define=AI_SYSTEM_PROMPT 覆盖）
  static const String systemPrompt = String.fromEnvironment(
    'AI_SYSTEM_PROMPT',
    defaultValue: PromptConfig.aboutAssistant,
  );

  /// 获取当前平台信息，便于日志排查
  static String platformLabel() {
    if (kIsWeb) return 'web';
    return defaultTargetPlatform.name;
  }
}