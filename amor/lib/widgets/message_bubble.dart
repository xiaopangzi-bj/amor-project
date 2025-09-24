import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/chat_message.dart';

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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8), // 垂直间距
      child: Row(
        // 用户消息右对齐，AI消息左对齐
        mainAxisAlignment: message.isUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI消息显示小狗头像（左侧）
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFE91E63), // 粉色背景
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: SvgPicture.asset(
                  'assets/dog_avatar.svg',
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8), // 头像与消息间距
          ],
          // 消息内容容器
          Flexible(
            child: GestureDetector(
              onTap: onTap, // 点击事件处理
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  // 用户消息红色背景，AI消息白色背景
                  color: message.isUser 
                      ? const Color(0xFFE91E63)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20), // 圆角气泡
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2), // 阴影效果
                    ),
                  ],
                ),
                child: Text(
                  message.content, // 消息文本内容
                  style: TextStyle(
                    // 用户消息白色文字，AI消息深色文字
                    color: message.isUser ? Colors.white : Colors.black87,
                    fontSize: 16,
                    height: 1.4, // 行高
                  ),
                ),
              ),
            ),
          ),
          // 用户消息显示用户头像（右侧）
          if (message.isUser) ...[
            const SizedBox(width: 8), // 消息与头像间距
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF4ECDC4), // 青色背景
              child: const Icon(
                Icons.person, // 用户图标
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
