import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../models/chat_message.dart';
import '../models/product.dart';

class ProductFilterWidget extends StatelessWidget {
  final ChatMessage message;
  final Function(ProductFilter) onFilterSelected;
  final VoidCallback onSkip;

  const ProductFilterWidget({
    super.key,
    required this.message,
    required this.onFilterSelected,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final filters = message.data?['filters'] as List<dynamic>? ?? [];
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 跳过选项
          GestureDetector(
            onTap: onSkip,
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
          
          // 消息气泡
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFFE91E63),
                child: const Icon(
                  Icons.smart_toy,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    HSLColor.fromAHSL(1.0, 315, 0.65, 0.98).toColor(),
                    HSLColor.fromAHSL(1.0, 315, 0.65, 0.95).toColor(),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
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
                  child: Text(
                    message.content,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 筛选选项
          ...filters.map((filterData) {
            final filter = ProductFilter.fromJson(filterData);
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () => onFilterSelected(filter),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        HSLColor.fromAHSL(1.0, 315, 0.65, 0.97).toColor(),
                        HSLColor.fromAHSL(1.0, 315, 0.65, 0.93).toColor(),
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
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              filter.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              filter.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
