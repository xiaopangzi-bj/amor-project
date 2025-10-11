import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../models/chat_message.dart';
import '../models/product.dart';
import '../config/font_config.dart';

class ResearchWidget extends StatelessWidget {
  final ChatMessage message;
  final List<ResearchStep> researchSteps;

  const ResearchWidget({
    super.key,
    required this.message,
    required this.researchSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 跳过选项
          GestureDetector(
            onTap: () {
              // 可以添加跳过逻辑
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    HSLColor.fromAHSL(1.0, 315, 0.65, 0.95).toColor(),
                    HSLColor.fromAHSL(1.0, 315, 0.65, 0.90).toColor(),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: HSLColor.fromAHSL(1.0, 315, 0.65, 0.80).toColor(),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: HSLColor.fromAHSL(0.1, 315, 0.65, 0.50).toColor(),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Skip and show all recommendations',
                    style: TextStyle(
                      color: HSLColor.fromAHSL(1.0, 315, 0.65, 0.40).toColor(),
                      fontSize: FontConfig.getCurrentFontSizes().messageText,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),
          
          // 主题标签
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  HSLColor.fromAHSL(1.0, 315, 0.65, 0.90).toColor(),
                  HSLColor.fromAHSL(1.0, 315, 0.65, 0.85).toColor(),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: HSLColor.fromAHSL(1.0, 315, 0.65, 0.75).toColor(),
                width: 1,
              ),
            ),
            child: Text(
              'Pilot Jacket',
              style: TextStyle(
                color: HSLColor.fromAHSL(1.0, 315, 0.65, 0.30).toColor(),
                fontSize: FontConfig.getCurrentFontSizes().messageText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          // 研究卡片
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  HSLColor.fromAHSL(1.0, 315, 0.65, 0.98).toColor(),
                  HSLColor.fromAHSL(1.0, 315, 0.65, 0.95).toColor(),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: HSLColor.fromAHSL(1.0, 315, 0.65, 0.85).toColor(),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: HSLColor.fromAHSL(0.15, 315, 0.65, 0.50).toColor(),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.search,
                      color: Color(0xFF4CAF50),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Research',
                      style: TextStyle(
                        fontSize: FontConfig.getCurrentFontSizes().messageText,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            HSLColor.fromAHSL(1.0, 315, 0.65, 0.96).toColor(),
                            HSLColor.fromAHSL(1.0, 315, 0.65, 0.92).toColor(),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: HSLColor.fromAHSL(1.0, 315, 0.65, 0.80).toColor(),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '${researchSteps.length} SOURCES',
                        style: TextStyle(
                          fontSize: FontConfig.getCurrentFontSizes().timestamp,
                          color: HSLColor.fromAHSL(1.0, 315, 0.65, 0.40).toColor(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // 研究步骤
                ...researchSteps.map((step) => _buildResearchStep(step)).toList(),
                
                const SizedBox(height: 16),
                
                // 来源链接
                _buildSourceLinks(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResearchStep(ResearchStep step) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: step.isCompleted
                    ? [
                        HSLColor.fromAHSL(1.0, 120, 0.60, 0.45).toColor(),
                        HSLColor.fromAHSL(1.0, 120, 0.60, 0.50).toColor(),
                      ]
                    : step.isActive
                        ? [
                            HSLColor.fromAHSL(1.0, 315, 0.65, 0.85).toColor(),
                            HSLColor.fromAHSL(1.0, 315, 0.65, 0.80).toColor(),
                          ]
                        : [
                            HSLColor.fromAHSL(1.0, 315, 0.65, 0.92).toColor(),
                            HSLColor.fromAHSL(1.0, 315, 0.65, 0.88).toColor(),
                          ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: step.isCompleted
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  )
                : step.isActive
                    ? const Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              step.title,
              style: TextStyle(
                fontSize: FontConfig.getCurrentFontSizes().messageText,
                color: step.isCompleted 
                    ? HSLColor.fromAHSL(1.0, 315, 0.65, 0.25).toColor()
                    : step.isActive
                        ? HSLColor.fromAHSL(1.0, 315, 0.65, 0.35).toColor()
                        : HSLColor.fromAHSL(1.0, 315, 0.65, 0.50).toColor(),
                fontWeight: step.isActive ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 12,
            color: HSLColor.fromAHSL(1.0, 315, 0.65, 0.60).toColor(),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceLinks() {
    final sources = [
      'COCKPITUSA.COM [1]',
      'REDDIT.COM [2]',
      'FARFETCH.COM [3]',
      'REDDIT.COM [4]',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...sources.map((source) => Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  HSLColor.fromAHSL(1.0, 315, 0.65, 0.96).toColor(),
                  HSLColor.fromAHSL(1.0, 315, 0.65, 0.92).toColor(),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: HSLColor.fromAHSL(1.0, 315, 0.65, 0.80).toColor(),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (source.contains('REDDIT')) ...[
                  Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF4500),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.reddit,
                      color: Colors.white,
                      size: 10,
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  source,
                  style: TextStyle(
                    fontSize: FontConfig.getCurrentFontSizes().timestamp,
                    color: HSLColor.fromAHSL(1.0, 315, 0.65, 0.35).toColor(),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )).toList(),
          Icon(
            Icons.arrow_forward_ios,
            size: 12,
            color: HSLColor.fromAHSL(1.0, 315, 0.65, 0.60).toColor(),
          ),
        ],
      ),
    );
  }
}
