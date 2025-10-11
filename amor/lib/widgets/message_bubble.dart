import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/chat_message.dart';
import '../config/font_config.dart';

/// 消息气泡组件
/// 用于在聊天界面中显示单条消息，支持用户消息和AI回复的不同样式
/// 包含头像、消息内容和点击交互功能
class MessageBubble extends StatelessWidget {
  /// 要显示的聊天消息对象
  final ChatMessage message;
  
  /// 点击消息时的回调函数（可选）
  final VoidCallback? onTap;

  /// 构造函数
  /// @param message 聊天消息对象（必需）
  /// @param onTap 点击回调（可选）
  const MessageBubble({
    super.key,
    required this.message,
    this.onTap,
  });

  /// 构建消息气泡UI
  /// 根据消息类型（用户/AI）显示不同的布局和样式
  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isUser
                ? [
                    HSLColor.fromAHSL(1.0, 315, 0.65, 0.80).toColor(), // 用户消息：中浅Amor色
                    HSLColor.fromAHSL(1.0, 315, 0.65, 0.75).toColor(), // 用户消息：Amor主色
                    HSLColor.fromAHSL(1.0, 315, 0.65, 0.70).toColor(), // 用户消息：中深Amor色
                  ]
                : [
                    Colors.white, // 机器人消息：白色
                    HSLColor.fromAHSL(1.0, 315, 0.65, 0.98).toColor(), // 机器人消息：非常浅的Amor色
                    HSLColor.fromAHSL(1.0, 315, 0.65, 0.96).toColor(), // 机器人消息：浅Amor色
                  ],
            stops: const [0.0, 0.5, 1.0],
          ),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
            bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: (isUser
                      ? HSLColor.fromAHSL(1.0, 315, 0.65, 0.75).toColor()
                      : Colors.grey)
                  .withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: isUser
                ? HSLColor.fromAHSL(0.3, 315, 0.65, 0.75).toColor()
                : HSLColor.fromAHSL(0.2, 315, 0.65, 0.75).toColor(),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 消息内容
            Text(
              message.content,
              style: TextStyle(
                color: isUser ? Colors.white : HSLColor.fromAHSL(1.0, 315, 0.65, 0.40).toColor(),
                fontSize: FontConfig.getCurrentFontSizes().messageText,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 4),
            // 时间戳
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                color: isUser
                    ? Colors.white.withOpacity(0.7)
                    : HSLColor.fromAHSL(0.6, 315, 0.65, 0.75).toColor(),
                fontSize: FontConfig.getCurrentFontSizes().timestamp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 格式化时间戳为可读字符串
  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
