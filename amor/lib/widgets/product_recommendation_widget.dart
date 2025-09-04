import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../models/product.dart';

class ProductRecommendationWidget extends StatelessWidget {
  final ChatMessage message;
  final String analysis;
  final List<Product> products;

  const ProductRecommendationWidget({
    super.key,
    required this.message,
    required this.analysis,
    required this.products,
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
                color: const Color(0xFFFF6B6B),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          // 研究部分
          _buildResearchSection(),
          
          const SizedBox(height: 20),
          
          // 验证分析部分
          _buildVettedAnalysisSection(),
          
          const SizedBox(height: 20),
          
          // 品牌轮播
          _buildBrandCarousel(),
          
          const SizedBox(height: 20),
          
          // 产品推荐
          _buildProductRecommendations(),
          
          const SizedBox(height: 20),
          
          // 反馈部分
          _buildFeedbackSection(),
          
          const SizedBox(height: 20),
          
          // 相关话题
          _buildRelatedTopics(),
        ],
      ),
    );
  }

  Widget _buildResearchSection() {
    return Container(
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
                child: const Text(
                  '25 SOURCES',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 来源链接
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildSourceLink('COCKPITUSA.COM [1]'),
                _buildSourceLink('REDDIT.COM [2]', isReddit: true),
                _buildSourceLink('FARFETCH.COM [3]'),
                _buildSourceLink('REDDIT.COM [4]', isReddit: true),
                Icon(
                  Icons.arrow_forward_ios,
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

  Widget _buildSourceLink(String text, {bool isReddit = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isReddit) ...[
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
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVettedAnalysisSection() {
    return Container(
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
                Icons.favorite,
                color: Color(0xFFFF6B6B),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Vetted Analysis',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Text(
            analysis,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandCarousel() {
    final brands = [
      {'name': 'VETTED PICKS', 'image': 'https://via.placeholder.com/40x40/FF6B6B/FFFFFF?text=V'},
      {'name': 'COCKPIT USA', 'image': 'https://via.placeholder.com/40x40/8B4513/FFFFFF?text=C'},
      {'name': 'THOM BROWNE', 'image': 'https://via.placeholder.com/40x40/000000/FFFFFF?text=T'},
      {'name': 'SACAI', 'image': 'https://via.placeholder.com/40x40/4ECDC4/FFFFFF?text=S'},
      {'name': 'GUCCI', 'image': 'https://via.placeholder.com/40x40/FFD700/000000?text=G'},
      {'name': "TOD'S", 'image': 'https://via.placeholder.com/40x40/654321/FFFFFF?text=T'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: brands.map((brand) => Container(
          margin: const EdgeInsets.only(right: 16),
          child: Column(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade300,
                child: Text(
                  brand['name']![0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                brand['name']!,
                style: TextStyle(
                  fontSize: 12,
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

  Widget _buildProductRecommendations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: products.map((product) => Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.category,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _buildProductCard(product),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildProductCard(Product product) {
    return Container(
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
          // 产品图片
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.name,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // 产品描述
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // 评分
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Color(0xFFFFD700),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${product.rating} (${product.reviewCount})',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // 价格比较
                ...product.prices.where((price) => price.price > 0).map((price) => 
                  Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '${price.store} ${price.currency}${price.price.toInt()}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // 特性标签
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: product.features.map((feature) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      feature,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
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

  Widget _buildFeedbackSection() {
    return Container(
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
        children: [
          const Text(
            'Was this helpful?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFeedbackButton(Icons.thumb_up, 'YES', Colors.green),
              const SizedBox(width: 20),
              _buildFeedbackButton(Icons.thumb_down, 'NO', Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackButton(IconData icon, String text, Color color) {
    return GestureDetector(
      onTap: () {
        // 处理反馈
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedTopics() {
    final topics = [
      'Compare Vetted Picks',
      '最受欢迎的飞行员夹克品牌推荐',
      '如何根据身材选择合适的飞行员夹克',
      '飞行员夹克常见材质优缺点对比',
    ];

    return Container(
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
          const Text(
            'Related Topics',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          ...topics.map((topic) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    topic,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
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
          )).toList(),
        ],
      ),
    );
  }
}
