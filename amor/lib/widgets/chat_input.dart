import 'package:flutter/material.dart';

/// 聊天输入组件
/// 提供文本输入框和发送按钮，支持加载状态显示
/// 包含输入验证、键盘提交和禁用状态处理
class ChatInput extends StatefulWidget {
  /// 发送消息时的回调函数，接收输入的文本内容
  final Function(String) onSendMessage;

  /// 是否处于加载状态（发送消息时显示加载动画）
  final bool isLoading;

  /// 构造函数
  /// @param onSendMessage 发送消息回调（必需）
  /// @param isLoading 加载状态（必需）
  const ChatInput({
    super.key,
    required this.onSendMessage,
    required this.isLoading,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

/// ChatInput组件的状态类
/// 管理文本输入控制器、焦点节点和消息发送逻辑
class _ChatInputState extends State<ChatInput> {
  /// 文本输入控制器，用于管理输入框的文本内容
  final TextEditingController _controller = TextEditingController();

  /// 焦点节点，用于管理输入框的焦点状态
  final FocusNode _focusNode = FocusNode();

  /// 释放资源
  /// 在组件销毁时清理控制器和焦点节点，防止内存泄漏
  @override
  void dispose() {
    _controller.dispose(); // 释放文本控制器
    _focusNode.dispose(); // 释放焦点节点
    super.dispose();
  }

  /// 发送消息处理函数
  /// 验证输入内容，调用回调函数发送消息，并清空输入框
  void _sendMessage() {
    final text = _controller.text.trim(); // 去除首尾空格
    // 检查文本不为空且不在加载状态
    if (text.isNotEmpty && !widget.isLoading) {
      widget.onSendMessage(text); // 调用发送回调
      _controller.clear(); // 清空输入框
    }
  }

  /// 构建聊天输入UI
  /// 创建包含输入框和发送按钮的底部输入区域
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16), // 内边距
      decoration: BoxDecoration(
        color: Colors.white, // 白色背景
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2), // 向上的阴影效果
          ),
        ],
      ),
      child: SafeArea(
        // 确保内容不被系统UI遮挡
        child: Row(
          children: [
            // 输入框区域
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100, // 浅灰色背景
                  borderRadius: BorderRadius.circular(24), // 圆角边框
                ),
                child: TextField(
                  controller: _controller, // 绑定文本控制器
                  focusNode: _focusNode, // 绑定焦点节点
                  enabled: !widget.isLoading, // 加载时禁用输入
                  decoration: const InputDecoration(
                    hintText: '输入您的消息...', // 提示文本
                    border: InputBorder.none, // 无边框
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  maxLines: null, // 支持多行输入
                  textInputAction: TextInputAction.send, // 键盘显示发送按钮
                  onSubmitted: (_) => _sendMessage(), // 键盘发送时触发
                ),
              ),
            ),
            const SizedBox(width: 12), // 输入框与按钮间距
            // 发送按钮
            GestureDetector(
              onTap: widget.isLoading ? null : _sendMessage, // 加载时禁用点击
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  // 加载时灰色，正常时红色
                  color: widget.isLoading
                      ? Colors.grey.shade300
                      : const Color(0xFFFF6B6B),
                  shape: BoxShape.circle, // 圆形按钮
                ),
                child: widget.isLoading
                    ? const Center(
                        // 加载状态显示进度指示器
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      )
                    : const Icon(
                        // 正常状态显示发送图标
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
