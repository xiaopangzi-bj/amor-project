import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Loading消息气泡组件
/// 用于显示AI正在思考时的动画效果，包含动画小狗头像和打字效果
class LoadingMessageBubble extends StatefulWidget {
  const LoadingMessageBubble({super.key});

  @override
  State<LoadingMessageBubble> createState() => _LoadingMessageBubbleState();
}

class _LoadingMessageBubbleState extends State<LoadingMessageBubble>
    with TickerProviderStateMixin {
  late AnimationController _dotsController;
  late Animation<int> _dotsAnimation;

  @override
  void initState() {
    super.initState();
    
    // 打字动画控制器
    _dotsController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _dotsAnimation = IntTween(begin: 0, end: 3).animate(
      CurvedAnimation(parent: _dotsController, curve: Curves.easeInOut),
    );
    
    _dotsController.repeat();
  }

  @override
  void dispose() {
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 动画小狗头像
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFE91E63), // 粉色背景
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: SvgPicture.asset(
                'assets/dog_loading.svg', // 使用loading版本的小狗
                width: 32,
                height: 32,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 8),
          
          // Loading消息气泡
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 思考文字
                  const Text(
                    '正在思考',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(width: 4),
                  
                  // 动画点点点
                  AnimatedBuilder(
                    animation: _dotsAnimation,
                    builder: (context, child) {
                      String dots = '';
                      for (int i = 0; i < _dotsAnimation.value; i++) {
                        dots += '.';
                      }
                      return SizedBox(
                        width: 20,
                        child: Text(
                          dots,
                          style: const TextStyle(
                            color: Color(0xFFE91E63),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}