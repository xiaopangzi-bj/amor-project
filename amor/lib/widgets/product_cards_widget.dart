import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../models/product.dart';
import '../config/font_config.dart';

/// 仅商品卡片组件
/// 简洁展示商品卡片列表，不包含研究、分析等其它模块
class ProductCardsWidget extends StatelessWidget {
  final ChatMessage message;
  final List<Product> products;

  const ProductCardsWidget({
    super.key,
    required this.message,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 6.0),
              child: Text(
                message.content,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: FontConfig.getCurrentFontSizes().messageText,
                ),
              ),
            ),
          ...products.map((p) => _buildProductCard(context, p)).toList(),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    final primaryPrice = product.prices.isNotEmpty ? product.prices.first : null;
    final secondaryPrice = product.prices.length > 1 ? product.prices[1] : null;
    final currentPrice = primaryPrice?.price;
    final originalPrice = secondaryPrice?.price;
    final displayCurrency = ((primaryPrice?.currency ?? '').toString().trim().isEmpty)
        ? '¥'
        : (primaryPrice?.currency ?? '¥');
    final vendor = primaryPrice?.store ?? product.sellerName ?? product.brand;
    final hasDiscount = (originalPrice != null && currentPrice != null && originalPrice > 0 && currentPrice < originalPrice);
    final discountPercent = hasDiscount ? (((originalPrice! - currentPrice!) / originalPrice) * 100).round() : null;
    final matchPercent = ((product.matchPercentage ?? (product.rating / 5.0 * 100)).clamp(0, 100)).toStringAsFixed(1);
    final highlight = (product.features.isNotEmpty ? product.features.first : 'Recommended Feature');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12, width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A90E2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$matchPercent% Match',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: FontConfig.getCurrentFontSizes().timestamp),
                  ),
                ),
                Text(
                  vendor ?? '',
                  style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: FontConfig.getCurrentFontSizes().messageText),
                ),
              ],
            ),
          ),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.antiAlias,
            child: (product.imageUrl.isNotEmpty)
                ? Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => Center(
                      child: Text(
                        'Image not available',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: FontConfig.getCurrentFontSizes().messageText),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      'Product Image',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: FontConfig.getCurrentFontSizes().messageText),
                    ),
                  ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(color: const Color(0xFFF2B500), borderRadius: BorderRadius.circular(8)),
              child: Text(
                highlight,
                style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: FontConfig.getCurrentFontSizes().messageText),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              product.name,
              style: TextStyle(fontSize: FontConfig.getCurrentFontSizes().inputText, fontWeight: FontWeight.w700, color: Colors.black87),
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                ...List.generate(5, (index) {
                  final filled = product.rating >= index + 1 || (product.rating > index && product.rating < index + 1);
                  return Icon(Icons.star, size: 16, color: filled ? const Color(0xFFFFD700) : Colors.grey.shade300);
                }),
                const SizedBox(width: 8),
                Text(
                  '${product.rating.toStringAsFixed(1)} (${_formatCount(product.reviewCount)})',
                  style: TextStyle(fontSize: FontConfig.getCurrentFontSizes().messageText, color: Colors.black87),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Reference Price: *Price may change at checkout',
              style: TextStyle(fontSize: FontConfig.getCurrentFontSizes().timestamp, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                if (currentPrice != null)
                  Text(
                    '$displayCurrency${currentPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: FontConfig.getCurrentFontSizes().inputText + 6,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFE91E63),
                    ),
                  ),
                const SizedBox(width: 12),
                if (hasDiscount && originalPrice != null)
                  Text(
                    '$displayCurrency${originalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: FontConfig.getCurrentFontSizes().messageText,
                      color: Colors.grey.shade500,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                const SizedBox(width: 8),
                if (discountPercent != null)
                  Text(
                    '-$discountPercent%',
                    style: TextStyle(fontSize: FontConfig.getCurrentFontSizes().messageText, color: Colors.green.shade700, fontWeight: FontWeight.w600),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF5FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBBD1FF)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Why we recommend this:',
                    style: TextStyle(fontSize: FontConfig.getCurrentFontSizes().messageText, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.features.take(3).join(' • '),
                    style: TextStyle(fontSize: FontConfig.getCurrentFontSizes().messageText, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('Quick Buy on ${vendor ?? 'store'}'),
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.open_in_new, size: 16),
              label: Text('View on ${vendor ?? 'store'}'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black87,
                side: const BorderSide(color: Colors.black12),
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}m';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return count.toString();
  }
}