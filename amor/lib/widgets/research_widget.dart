import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../models/product.dart';

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
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '跳过并显示所有推荐',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
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
              color: const Color(0xFFFFE5E5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '飞行员夹克',
              style: TextStyle(
                color: const Color(0xFFE91E63),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          // 研究卡片
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
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
                    const Text(
                      'Research',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${researchSteps.length} SOURCES',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
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
              color: step.isCompleted 
                  ? const Color(0xFF4CAF50)
                  : step.isActive
                      ? const Color(0xFFFFD700)
                      : Colors.grey.shade300,
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
                fontSize: 14,
                color: step.isCompleted 
                    ? Colors.black87
                    : step.isActive
                        ? const Color(0xFFFFD700)
                        : Colors.grey.shade600,
                fontWeight: step.isActive ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 12,
            color: Colors.grey.shade400,
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
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
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
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )).toList(),
          Icon(
            Icons.arrow_forward_ios,
            size: 12,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }
}
