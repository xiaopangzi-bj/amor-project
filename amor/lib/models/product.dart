class Product {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final List<PriceInfo> prices;
  final List<String> features;
  final String category;
  final String brand;

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

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      rating: json['rating'].toDouble(),
      reviewCount: json['reviewCount'],
      prices: (json['prices'] as List)
          .map((price) => PriceInfo.fromJson(price))
          .toList(),
      features: List<String>.from(json['features']),
      category: json['category'],
      brand: json['brand'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'prices': prices.map((p) => p.toJson()).toList(),
      'features': features,
      'category': category,
      'brand': brand,
    };
  }
}

class PriceInfo {
  final String store;
  final double price;
  final String currency;

  PriceInfo({
    required this.store,
    required this.price,
    required this.currency,
  });

  factory PriceInfo.fromJson(Map<String, dynamic> json) {
    return PriceInfo(
      store: json['store'],
      price: json['price'].toDouble(),
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'store': store,
      'price': price,
      'currency': currency,
    };
  }
}

class ProductFilter {
  final String id;
  final String title;
  final String description;
  final String? icon;

  ProductFilter({
    required this.id,
    required this.title,
    required this.description,
    this.icon,
  });

  factory ProductFilter.fromJson(Map<String, dynamic> json) {
    return ProductFilter(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
    };
  }
}

class ResearchStep {
  final String id;
  final String title;
  final bool isCompleted;
  final bool isActive;

  ResearchStep({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.isActive,
  });

  factory ResearchStep.fromJson(Map<String, dynamic> json) {
    return ResearchStep(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'isActive': isActive,
    };
  }
}
