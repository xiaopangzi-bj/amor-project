import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../models/chat_message.dart';
import '../models/product.dart';
import '../config/font_config.dart';

/// 产品推荐组件
/// 显示AI分析结果、产品推荐、品牌轮播、反馈收集等完整的推荐界面
/// 包含研究来源、审核分析、产品卡片、相关话题等多个功能模块
class ProductRecommendationWidget extends StatelessWidget {
  /// 聊天消息对象，包含推荐的上下文信息
  final ChatMessage message;
  
  /// AI分析结果文本，显示产品的详细分析
  final String analysis;
  
  /// 推荐的产品列表
  final List<Product> products;

  /// 构造函数
  /// @param message 聊天消息（必需）
  /// @param analysis 分析文本（必需）
  /// @param products 产品列表（必需）
  const ProductRecommendationWidget({
    super.key,
    required this.message,
    required this.analysis,
    required this.products,
  });

  /// 构建产品推荐UI
  /// 创建包含多个功能模块的完整推荐界面
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 跳过选项 - 允许用户跳过当前推荐
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
                      color: Colors.grey.shade600,
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
          
          // 主题标签 - 显示当前推荐的产品类别
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
              'Pilot Jacket', // 产品类别标签
              style: TextStyle(
                color: HSLColor.fromAHSL(1.0, 315, 0.65, 0.30).toColor(), // 深紫色文字
                fontSize: FontConfig.getCurrentFontSizes().messageText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          // 研究部分 - 显示数据来源和研究信息
          _buildResearchSection(),
          
          const SizedBox(height: 20),
          
          // 验证分析部分 - 显示AI分析结果
          _buildVettedAnalysisSection(),
          
          const SizedBox(height: 20),
          
          // 品牌轮播 - 显示相关品牌选择
          _buildBrandCarousel(),
          
          const SizedBox(height: 20),
          
          // 产品推荐 - 显示具体的产品推荐卡片
          _buildProductRecommendations(),
          
          const SizedBox(height: 20),
          
          // 反馈部分 - 收集用户对推荐的反馈
          _buildFeedbackSection(),
          
          const SizedBox(height: 20),
          
          // 相关话题 - 显示相关的推荐话题
          _buildRelatedTopics(),
        ],
      ),
    );
  }

  /// 构建研究部分UI
  /// 显示数据来源、研究信息和来源链接
  Widget _buildResearchSection() {
    return Container(
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
                'Research', // 研究标题
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
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '25 SOURCES', // 数据来源数量标签
                  style: TextStyle(
                    fontSize: FontConfig.getCurrentFontSizes().timestamp,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 来源链接 - 水平滚动的数据来源列表
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildSourceLink('COCKPITUSA.COM [1]'),
                _buildSourceLink('REDDIT.COM [2]', isReddit: true),
                _buildSourceLink('FARFETCH.COM [3]'),
                _buildSourceLink('REDDIT.COM [4]', isReddit: true),
                Icon(
                  Icons.arrow_forward_ios, // 更多来源指示箭头
                  size: 12,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建数据来源链接标签
  /// @param text 来源文本
  /// @param isReddit 是否为Reddit来源（显示特殊图标）
  Widget _buildSourceLink(String text, {bool isReddit = false}) {
    return Container(
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
          // 如果是Reddit来源，显示Reddit图标
          if (isReddit) ...[
            Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Color(0xFFFF4500), // Reddit橙色
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
            text, // 来源文本
            style: TextStyle(
                fontSize: FontConfig.getCurrentFontSizes().timestamp,
                color: HSLColor.fromAHSL(1.0, 315, 0.65, 0.35).toColor(),
                fontWeight: FontWeight.w500,
              ),
          ),
        ],
      ),
    );
  }

  /// 构建审核分析部分UI
  /// 显示AI对产品的详细分析结果
  Widget _buildVettedAnalysisSection() {
    return Container(
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
                Icons.favorite,
                color: Color(0xFFE91E63),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Vetted Analysis', // 审核分析标题
                style: TextStyle(
                  fontSize: FontConfig.getCurrentFontSizes().messageText,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Text(
            analysis, // 显示AI分析文本
            style: TextStyle(
              fontSize: FontConfig.getCurrentFontSizes().messageText,
              color: Colors.black87,
              height: 1.5, // 行高设置
            ),
          ),
        ],
      ),
    );
  }

  /// 构建品牌轮播UI
  /// 显示相关品牌的水平滚动列表，包含品牌头像和名称
  Widget _buildBrandCarousel() {
    // 品牌数据列表，包含推荐的相关品牌
    final brands = [
      {'name': 'VETTED PICKS', 'image': 'https://via.placeholder.com/40x40/FF6B6B/FFFFFF?text=V'},
      {'name': 'COCKPIT USA', 'image': 'https://via.placeholder.com/40x40/8B4513/FFFFFF?text=C'},
      {'name': 'THOM BROWNE', 'image': 'https://via.placeholder.com/40x40/000000/FFFFFF?text=T'},
      {'name': 'SACAI', 'image': 'https://via.placeholder.com/40x40/4ECDC4/FFFFFF?text=S'},
      {'name': 'GUCCI', 'image': 'https://via.placeholder.com/40x40/FFD700/000000?text=G'},
      {'name': "TOD'S", 'image': 'https://via.placeholder.com/40x40/654321/FFFFFF?text=T'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // 水平滚动
      child: Row(
        children: brands.map((brand) => Container(
          margin: const EdgeInsets.only(right: 16),
          child: Column(
            children: [
              // 品牌头像
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade300,
                child: Text(
                  brand['name']![0], // 显示品牌名称首字母
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // 品牌名称
              Text(
                brand['name']!,
                style: TextStyle(
                  fontSize: FontConfig.getCurrentFontSizes().timestamp,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }

  /// 构建产品推荐列表UI
  /// 显示所有推荐产品的卡片列表，按类别分组
  Widget _buildProductRecommendations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: products.map((product) => Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 产品类别标题
            Text(
              product.category,
              style: TextStyle(
                fontSize: FontConfig.getCurrentFontSizes().messageText,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            // 产品卡片
            _buildProductCard(product),
          ],
        ),
      )).toList(),
    );
  }

  /// 构建单个产品卡片UI
  /// 显示产品图片、信息、评分、价格和特性标签
  /// @param product 产品对象
  Widget _buildProductCard(Product product) {
    return Container(
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
          // 产品图片区域 - 占位符显示
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  HSLColor.fromAHSL(1.0, 315, 0.65, 0.92).toColor(),
                  HSLColor.fromAHSL(1.0, 315, 0.65, 0.88).toColor(),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              border: Border.all(
                color: HSLColor.fromAHSL(1.0, 315, 0.65, 0.80).toColor(),
                width: 1,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag, // 购物袋图标作为占位符
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.name, // 产品名称
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: FontConfig.getCurrentFontSizes().inputText,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 产品标题
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: FontConfig.getCurrentFontSizes().inputText,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // 产品描述
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: FontConfig.getCurrentFontSizes().messageText,
                    color: Colors.grey.shade600,
                    height: 1.4, // 行高设置
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // 评分显示
                Row(
                  children: [
                    const Icon(
                      Icons.star, // 星形评分图标
                      color: Color(0xFFFFD700), // 金色
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${product.rating} (${product.reviewCount})', // 评分和评论数
                      style: TextStyle(
                        fontSize: FontConfig.getCurrentFontSizes().messageText,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // 价格比较 - 显示不同商店的价格
                ...product.prices.where((price) => price.price > 0).map((price) => 
                  Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '${price.store} ${price.currency}${price.price.toInt()}', // 商店名称和价格
                      style: TextStyle(
                        fontSize: FontConfig.getCurrentFontSizes().messageText,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // 特性标签 - 显示产品特性的标签云
                Wrap(
                  spacing: 8, // 水平间距
                  runSpacing: 4, // 垂直间距
                  children: product.features.map((feature) => Container(
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
                      feature, // 特性文本
                      style: TextStyle(
                        fontSize: FontConfig.getCurrentFontSizes().timestamp,
                        color: HSLColor.fromAHSL(1.0, 315, 0.65, 0.35).toColor(),
                      ),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建反馈区域UI
  /// 显示用户反馈选项，询问推荐是否有帮助
  Widget _buildFeedbackSection() {
    return Container(
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
        children: [
          // 反馈标题
          Text(
            'Was this helpful?',
            style: TextStyle(
              fontSize: FontConfig.getCurrentFontSizes().inputText,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          // 反馈按钮行
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFeedbackButton(Icons.thumb_up, 'YES', Colors.green), // 正面反馈
              const SizedBox(width: 20),
              _buildFeedbackButton(Icons.thumb_down, 'NO', Colors.red), // 负面反馈
            ],
          ),
        ],
      ),
    );
  }

  /// 构建反馈按钮UI
  /// @param icon 按钮图标
  /// @param text 按钮文本
  /// @param color 按钮颜色主题
  Widget _buildFeedbackButton(IconData icon, String text, Color color) {
    return GestureDetector(
      onTap: () {
        // 处理反馈逻辑
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.15),
              color.withOpacity(0.08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16), // 反馈图标
            const SizedBox(width: 4),
            Text(
              text, // 按钮文本
              style: TextStyle(
                color: color,
                fontSize: FontConfig.getCurrentFontSizes().messageText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建相关话题UI
  /// 显示与当前推荐相关的话题链接列表
  Widget _buildRelatedTopics() {
    // 相关话题列表
    final topics = [
      'Compare Vetted Picks',
      'Most Popular Pilot Jacket Brand Recommendations',
      'How to Choose the Right Pilot Jacket for Your Body Type',
      'Pros and Cons of Common Pilot Jacket Materials',
    ];

    return Container(
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
          // 相关话题标题
          Text(
            'Related Topics',
            style: TextStyle(
              fontSize: FontConfig.getCurrentFontSizes().inputText,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          // 话题链接列表
          ...topics.map((topic) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    topic, // 话题文本
                    style: TextStyle(
                    fontSize: FontConfig.getCurrentFontSizes().messageText,
                    color: HSLColor.fromAHSL(1.0, 315, 0.65, 0.35).toColor(),
                  ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios, // 箭头指示器
                  size: 12,
                  color: HSLColor.fromAHSL(1.0, 315, 0.65, 0.60).toColor(),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }
}
