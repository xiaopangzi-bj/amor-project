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
  });

  /// 从JSON数据创建产品对象
  /// 用于从API响应或本地存储中恢复产品数据
  /// @param json 包含产品信息的JSON Map
  /// @return Product实例
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      rating: json['rating'].toDouble(), // 确保评分为double类型
      reviewCount: json['reviewCount'],
      prices: (json['prices'] as List)
          .map((price) => PriceInfo.fromJson(price)) // 转换价格信息列表
          .toList(),
      features: List<String>.from(json['features']), // 转换特性列表
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
