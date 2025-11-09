import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../config/ai_config.dart';

/// DeepSeek 聊天服务封装
/// 兼容 OpenAI 风格的 Chat Completions 接口
class DeepSeekService {
  final http.Client _client = http.Client();

  Uri _chatUri() => Uri.parse('${AIConfig.deepseekBaseUrl}/chat/completions');

  Map<String, String> _headers() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AIConfig.deepseekApiKey}',
    };
  }

  /// 发送聊天消息
  /// [messages] 为 OpenAI 样式的 message 列表：[{role, content}, ...]
  /// 返回助手回复的纯文本
  Future<String> chat({required List<Map<String, String>> messages}) async {
    if (!AIConfig.isConfigured) {
      throw DeepSeekException(
        'DeepSeek API Key 未配置',
        0,
        '请使用 --dart-define=DEEPSEEK_API_KEY=your_key 运行应用',
      );
    }

    // 在消息列表最前面插入系统提示，确保对话遵循你的角色与职责
    final List<Map<String, String>> fullMessages = [
      {
        'role': 'system',
        'content': AIConfig.systemPrompt,
      },
      ...messages,
    ];

    final body = {
      'model': AIConfig.deepseekModel,
      'messages': fullMessages,
      'temperature': 0.7,
      'stream': false,
    };

    final resp = await _client.post(_chatUri(), headers: _headers(), body: jsonEncode(body));
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body);
      // 兼容 deepseek 返回结构（与 OpenAI 相似）
      final choices = data['choices'];
      if (choices is List && choices.isNotEmpty) {
        final msg = choices[0]['message'];
        if (msg is Map && msg['content'] is String) {
          return msg['content'] as String;
        }
      }
      throw DeepSeekException('解析响应失败', resp.statusCode, resp.body);
    }
    throw DeepSeekException('请求失败', resp.statusCode, resp.body);
  }

  /// 流式聊天：返回增量文本片段的流
  /// 当服务端开启 `stream: true` 时，使用 SSE 按行解析 `data: {json}` 片段
  Stream<String> chatStream({required List<Map<String, String>> messages}) async* {
    if (!AIConfig.isConfigured) {
      throw DeepSeekException(
        'DeepSeek API Key 未配置',
        0,
        '请使用 --dart-define=DEEPSEEK_API_KEY=your_key 运行应用',
      );
    }

    final List<Map<String, String>> fullMessages = [
      {
        'role': 'system',
        'content': AIConfig.systemPrompt,
      },
      ...messages,
    ];

    final body = {
      'model': AIConfig.deepseekModel,
      'messages': fullMessages,
      'temperature': 0.7,
      'stream': true,
    };

    final req = http.Request('POST', _chatUri());
    req.headers.addAll(_headers());
    req.body = jsonEncode(body);

    final streamed = await _client.send(req);
    if (streamed.statusCode < 200 || streamed.statusCode >= 300) {
      final details = await streamed.stream.bytesToString();
      throw DeepSeekException('请求失败', streamed.statusCode, details);
    }

    final lines = streamed.stream.transform(utf8.decoder).transform(const LineSplitter());
    await for (final raw in lines) {
      final line = raw.trim();
      if (line.isEmpty) continue;
      if (!line.startsWith('data:')) continue;
      final payload = line.substring(5).trim();
      if (payload == '[DONE]') break;

      try {
        final data = jsonDecode(payload);
        final choices = data['choices'];
        if (choices is List && choices.isNotEmpty) {
          // OpenAI流式：choices[0].delta.content
          final delta = choices[0]['delta'];
          String? content;
          if (delta is Map && delta['content'] is String) {
            content = delta['content'] as String;
          } else {
            // 兼容可能返回完整message的情况
            final msg = choices[0]['message'];
            if (msg is Map && msg['content'] is String) {
              content = msg['content'] as String;
            }
          }
          if (content != null && content!.isNotEmpty) {
            yield content!;
          }
        }
      } catch (_) {
        // 忽略单行解析错误，继续下一行
        continue;
      }
    }
  }

  void dispose() {
    _client.close();
  }
}

class DeepSeekException implements Exception {
  final String message;
  final int statusCode;
  final String details;

  DeepSeekException(this.message, this.statusCode, this.details);

  @override
  String toString() => 'DeepSeekException: $message (Status: $statusCode) - $details';
}