import 'package:flutter/material.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

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

  /// 麦克风是否正在录音
  bool _isRecording = false;

  /// 初始化组件
  /// 在组件构建完成后自动获取焦点
  @override
  void initState() {
    super.initState();
    // 延迟获取焦点，确保组件完全构建完成
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

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
      // 延迟重新获取焦点，避免键盘闪烁
      Timer(const Duration(milliseconds: 100), () {
        if (mounted) {
          _focusNode.requestFocus();
        }
      });
    }
  }

  /// 处理麦克风按钮点击
  /// 请求麦克风权限并开始/停止录音
  Future<void> _handleMicrophonePress() async {
    if (_isRecording) {
      // 停止录音
      setState(() {
        _isRecording = false;
      });
      // 这里可以添加停止录音的逻辑
      debugPrint('🎤 停止录音');
    } else {
      // 请求麦克风权限
      final permission = await Permission.microphone.request();
      if (permission.isGranted) {
        // 开始录音
        setState(() {
          _isRecording = true;
        });
        // 这里可以添加开始录音的逻辑
        debugPrint('🎤 开始录音');
      } else {
        // 权限被拒绝
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('需要麦克风权限才能使用语音功能'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
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
            color: Colors.grey.withOpacity(0.1),
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
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      HSLColor.fromAHSL(1.0, 315, 0.65, 0.98).toColor(), // 非常浅的Amor色
                      HSLColor.fromAHSL(1.0, 315, 0.65, 0.96).toColor(), // 浅Amor色
                      Colors.white, // 白色
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: HSLColor.fromAHSL(0.1, 315, 0.65, 0.60).toColor(),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: HSLColor.fromAHSL(0.2, 315, 0.65, 0.75).toColor(),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _controller, // 绑定文本控制器
                  focusNode: _focusNode, // 绑定焦点节点
                  enabled: !widget.isLoading, // 加载时禁用输入
                  decoration: InputDecoration(
                    hintText: '输入您的消息...', // 提示文本
                    hintStyle: TextStyle(
                      color: HSLColor.fromAHSL(0.6, 315, 0.65, 0.75).toColor(),
                      fontSize: 14,
                    ),
                    border: InputBorder.none, // 无边框
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  maxLines: null, // 支持多行输入
                  textInputAction: TextInputAction.send, // 键盘显示发送按钮
                  onSubmitted: (_) => _sendMessage(), // 键盘发送时触发
                  style: TextStyle(
                    color: HSLColor.fromAHSL(1.0, 315, 0.65, 0.40).toColor(), // 深Amor色文字
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12), // 输入框与按钮间距
            // 麦克风按钮
            GestureDetector(
              onTap: widget.isLoading ? null : _handleMicrophonePress, // 加载时禁用点击
              child: Container(
                width: 48,
                height: 48,
                child: Icon(
                  // 录音时显示停止图标，正常时显示麦克风图标
                  _isRecording ? Icons.stop : Icons.mic,
                  // 录音时红色，正常时使用发送按钮的粉色
                  color: _isRecording
                      ? Colors.red
                      : const Color(0xFFE91E63),
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 8), // 麦克风与发送按钮间距
            // 发送按钮
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.isLoading
                      ? [
                          Colors.grey.shade300,
                          Colors.grey.shade400,
                          Colors.grey.shade500,
                        ]
                      : [
                          HSLColor.fromAHSL(1.0, 315, 0.65, 0.80).toColor(), // 中浅Amor色
                          HSLColor.fromAHSL(1.0, 315, 0.65, 0.75).toColor(), // Amor主色
                          HSLColor.fromAHSL(1.0, 315, 0.65, 0.70).toColor(), // 中深Amor色
                        ],
                  stops: const [0.0, 0.5, 1.0],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: (widget.isLoading
                            ? Colors.grey.withOpacity(0.3)
                            : HSLColor.fromAHSL(1.0, 315, 0.65, 0.75).toColor())
                        .withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(25),
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: widget.isLoading ? null : _sendMessage,
                  child: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    child: widget.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 20,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
