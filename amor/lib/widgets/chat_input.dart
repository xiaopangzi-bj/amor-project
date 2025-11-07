import 'package:flutter/material.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import '../config/font_config.dart';

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
class _ChatInputState extends State<ChatInput>
    with SingleTickerProviderStateMixin {
  /// 文本输入控制器，用于管理输入框的文本内容
  final TextEditingController _controller = TextEditingController();

  /// 焦点节点，用于管理输入框的焦点状态
  final FocusNode _focusNode = FocusNode();

  /// 是否存在输入文本（用于切换按钮样式）
  bool _hasText = false;

  /// 麦克风是否正在录音
  bool _isRecording = false;

  /// 动画控制器，用于录音时的脉冲效果
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  /// 初始化组件
  @override
  void initState() {
    super.initState();

    // 初始化动画控制器
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    // 创建脉冲动画
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // 监听输入内容变化，用于切换发送/麦克风按钮
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) {
        setState(() {
          _hasText = hasText;
        });
      }
    });

    // 默认不自动获取焦点，避免页面进入时弹出键盘
  }

  /// 释放资源
  /// 在组件销毁时清理控制器和焦点节点，防止内存泄漏
  @override
  void dispose() {
    _animationController.dispose(); // 释放动画控制器
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
    // 添加触觉反馈
    HapticFeedback.lightImpact();

    if (_isRecording) {
      // 停止录音
      setState(() {
        _isRecording = false;
      });
      // 停止动画
      _animationController.stop();
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
        // 开始动画
        _animationController.repeat(reverse: true);
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2), // 压缩上下内边距，减少空隙
      decoration: const BoxDecoration(
        color: Colors.white, // 纯白背景
      ),
      child: SafeArea(
        top: false, // 不为顶部添加安全区域
        bottom: true, // 保留底部安全区，避免被系统手势区域遮挡
        child: Row(
          children: [
            // 输入框区域
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100, // 参考豆包的浅灰背景
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 0.8,
                  ),
                ),
                child: TextField(
                  controller: _controller, // 绑定文本控制器
                  focusNode: _focusNode, // 绑定焦点节点
                  enabled: !widget.isLoading, // 加载时禁用输入
                  decoration: InputDecoration(
                    hintText: 'Type a message...', // Hint text in English
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: FontConfig.getCurrentFontSizes().hintText,
                    ),
                    border: InputBorder.none, // 无边框
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6, // 略微增高，保证可触达性
                    ),
                  ),
                  maxLines: null, // 支持多行输入
                  textInputAction: TextInputAction.send, // 键盘显示发送按钮
                  onSubmitted: (_) => _sendMessage(), // 键盘发送时触发
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: FontConfig.getCurrentFontSizes().inputText,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6), // 进一步减少输入框与按钮间距
            // 根据输入内容显示麦克风或发送按钮（参考豆包交互）
            if (!_hasText) ...[
              GestureDetector(
                onTap:
                    widget.isLoading ? null : _handleMicrophonePress, // 加载时禁用点击
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _isRecording ? _pulseAnimation.value : 1.0,
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: _isRecording
                              ? Colors.red.shade600
                              : Colors.pink.shade500,
                          borderRadius: BorderRadius.circular(19),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(19),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(19),
                            onTap: widget.isLoading ? null : _handleMicrophonePress,
                            child: Container(
                              width: 38,
                              height: 38,
                              alignment: Alignment.center,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: _isRecording
                                    ? Container(
                                        key: const ValueKey('recording'),
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      )
                                    : const Icon(
                                        Icons.mic,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ] else ...[
              Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent, // 保持外层容器背景透明
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: widget.isLoading ? null : _sendMessage,
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      child: widget.isLoading
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.pink.shade500),
                              ),
                            )
                          : Icon(
                              Icons.send,
                              color: Colors.pink.shade500, // 图标使用主题色，背景透明
                              size: 18,
                            ),
                    ),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
