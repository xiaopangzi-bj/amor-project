import 'dart:convert';

/// 产品数据模型
/// 表示购物应用中的商品信息，包含基本信息、价格、评价等详细数据
class Product {
  /// 产品唯一标识符
  final String id;
  
  /// 产品名称
  final String name;
  
  /// 产品详细描述
  final String description;
  
  /// 产品图片URL
  final String imageUrl;
  
  /// 产品评分（0.0-5.0）
  final double rating;
  
  /// 评价数量
  final int reviewCount;
  
  /// 不同商店的价格信息列表
  final List<PriceInfo> prices;
  
  /// 产品特性/功能列表
  final List<String> features;
  
  /// 产品分类
  final String category;
  
  /// 产品品牌
  final String brand;

  /// 匹配百分比（可选，来自接口的 matchPercentage 字段）
  final double? matchPercentage;

  /// 快速购买链接（可选）
  final String? quickBuyUrl;

  /// 产品详情链接（可选）
  final String? productUrl;

  /// 商家名称（可选）
  final String? sellerName;

  /// 构造函数
  /// 创建一个包含完整产品信息的Product实例
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.prices,
    required this.features,
    required this.category,
    required this.brand,
    this.matchPercentage,
    this.quickBuyUrl,
    this.productUrl,
    this.sellerName,
  });

  /// 从JSON数据创建产品对象
  /// 用于从API响应或本地存储中恢复产品数据
  /// @param json 包含产品信息的JSON Map
  /// @return Product实例
  factory Product.fromJson(Map<String, dynamic> json) {
    // 兼容新的接口 records 结构
    if (json.containsKey('title')) {
      // 解析图片
      String imageUrl = json['mainImageUrl'] ?? json['imageUrl'] ?? '';
      if ((imageUrl.isEmpty || imageUrl == 'null') && json['imageUrls'] != null) {
        try {
          final imgs = json['imageUrls'];
          if (imgs is String) {
            final list = List<String>.from(jsonDecode(imgs));
            if (list.isNotEmpty) imageUrl = list.first;
          } else if (imgs is List) {
            final list = List<String>.from(imgs.map((e) => e.toString()));
            if (list.isNotEmpty) imageUrl = list.first;
          }
        } catch (_) {}
      }

      // 解析特性
      List<String> features = [];
      dynamic badges = json['badges'];
      try {
        if (badges is String) {
          features = List<String>.from(jsonDecode(badges));
        } else if (badges is List) {
          features = List<String>.from(badges.map((e) => e.toString()));
        }
      } catch (_) {}
      if (features.isEmpty && json['promotionTags'] != null) {
        try {
          final tags = json['promotionTags'];
          if (tags is String) {
            features = List<String>.from(jsonDecode(tags));
          } else if (tags is List) {
            features = List<String>.from(tags.map((e) => e.toString()));
          }
        } catch (_) {}
      }
      if (features.isEmpty && json['recommendationReason'] != null && (json['recommendationReason'] as String).isNotEmpty) {
        features = [json['recommendationReason']];
      }

      // 价格信息
      final currency = (json['currency'] ?? '\$').toString();
      final currentPrice = (json['currentPrice'] is num) ? (json['currentPrice'] as num).toDouble() : 0.0;
      final originalPrice = (json['originalPrice'] is num) ? (json['originalPrice'] as num).toDouble() : 0.0;
      final sellerName = json['sellerName']?.toString();
      final prices = <PriceInfo>[
        if (currentPrice > 0)
          PriceInfo(store: sellerName ?? (json['platform']?.toString() ?? 'store'), price: currentPrice, currency: currency),
        if (originalPrice > 0)
          PriceInfo(store: '${sellerName ?? 'store'} MSRP', price: originalPrice, currency: currency),
      ];

      return Product(
        id: (json['productId'] ?? json['id']).toString(),
        name: json['title'] ?? '',
        description: json['productDescription'] ?? (json['description'] ?? ''),
        imageUrl: imageUrl,
        rating: (json['rating'] is num) ? (json['rating'] as num).toDouble() : 0.0,
        reviewCount: (json['reviewsCount'] is num) ? (json['reviewsCount'] as num).toInt() : 0,
        prices: prices,
        features: features,
        category: json['categoryName'] ?? (json['rootCategory'] ?? (json['category'] ?? '')),
        brand: json['brand'] ?? '',
        matchPercentage: (json['matchPercentage'] is num) ? (json['matchPercentage'] as num).toDouble() : null,
        quickBuyUrl: json['quickBuyUrl']?.toString(),
        productUrl: json['productUrl']?.toString(),
        sellerName: sellerName,
      );
    }

    // 原有结构兼容
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'],
      prices: (json['prices'] as List).map((price) => PriceInfo.fromJson(price)).toList(),
      features: List<String>.from(json['features']),
      category: json['category'],
      brand: json['brand'],
    );
  }

  /// 将产品对象转换为JSON格式
  /// 用于数据持久化、网络传输等场景
  /// @return 包含产品信息的Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'prices': prices.map((p) => p.toJson()).toList(), // 转换价格信息为JSON
      'features': features,
      'category': category,
      'brand': brand,
      'matchPercentage': matchPercentage,
      'quickBuyUrl': quickBuyUrl,
      'productUrl': productUrl,
      'sellerName': sellerName,
    };
  }
}

/// 价格信息模型
/// 表示产品在不同商店的价格信息
class PriceInfo {
  /// 商店名称
  final String store;
  
  /// 价格数值
  final double price;
  
  /// 货币单位（如：USD, CNY等）
  final String currency;

  /// 构造函数
  /// 创建包含商店、价格和货币信息的PriceInfo实例
  PriceInfo({
    required this.store,
    required this.price,
    required this.currency,
  });

  /// 从JSON数据创建价格信息对象
  /// @param json 包含价格信息的JSON Map
  /// @return PriceInfo实例
  factory PriceInfo.fromJson(Map<String, dynamic> json) {
    return PriceInfo(
      store: json['store'],
      price: json['price'].toDouble(), // 确保价格为double类型
      currency: json['currency'],
    );
  }

  /// 将价格信息对象转换为JSON格式
  /// @return 包含价格信息的Map
  Map<String, dynamic> toJson() {
    return {
      'store': store,
      'price': price,
      'currency': currency,
    };
  }
}

/// 产品筛选器模型
/// 表示用于筛选产品的条件或标准
class ProductFilter {
  /// 筛选器唯一标识符
  final String id;
  
  /// 筛选器标题
  final String title;
  
  /// 筛选器描述
  final String description;
  
  /// 筛选器图标（可选）
  final String? icon;

  /// 构造函数
  /// 创建产品筛选器实例
  ProductFilter({
    required this.id,
    required this.title,
    required this.description,
    this.icon,
  });

  /// 从JSON数据创建产品筛选器对象
  /// @param json 包含筛选器信息的JSON Map
  /// @return ProductFilter实例
  factory ProductFilter.fromJson(Map<String, dynamic> json) {
    return ProductFilter(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: json['icon'], // 图标可能为null
    );
  }

  /// 将产品筛选器对象转换为JSON格式
  /// @return 包含筛选器信息的Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
    };
  }
}

/// 研究步骤模型
/// 表示AI购物研究过程中的单个步骤状态
class ResearchStep {
  /// 步骤唯一标识符
  final String id;
  
  /// 步骤标题/描述
  final String title;
  
  /// 是否已完成
  final bool isCompleted;
  
  /// 是否为当前活跃步骤
  final bool isActive;

  /// 构造函数
  /// 创建研究步骤实例
  ResearchStep({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.isActive,
  });

  /// 从JSON数据创建研究步骤对象
  /// @param json 包含步骤信息的JSON Map
  /// @return ResearchStep实例
  factory ResearchStep.fromJson(Map<String, dynamic> json) {
    return ResearchStep(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'], // 完成状态
      isActive: json['isActive'], // 活跃状态
    );
  }

  /// 将研究步骤对象转换为JSON格式
  /// @return 包含步骤信息的Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'isActive': isActive,
    };
  }
}
