/// 用户年龄枚举
enum AgeGroup {
  young,    // 年轻用户 (18-35)
  middle,   // 中年用户 (36-55)
  senior,   // 老年用户 (56+)
}

/// 字体配置类
/// 根据用户年龄和偏好设置提供不同的字体大小配置
class FontConfig {
  /// 字体大小配置
  static final Map<AgeGroup, FontSizes> _fontSizesByAge = {
    AgeGroup.young: FontSizes(
      messageText: 16.0,
      inputText: 14.0,
      hintText: 14.0,
      timestamp: 11.0,
    ),
    AgeGroup.middle: FontSizes(
      messageText: 18.0,
      inputText: 16.0,
      hintText: 16.0,
      timestamp: 12.0,
    ),
    AgeGroup.senior: FontSizes(
      messageText: 20.0,
      inputText: 18.0,
      hintText: 18.0,
      timestamp: 14.0,
    ),
  };

  /// 默认字体大小（使用老年用户配置，大字体）
  static const FontSizes defaultFontSizes = FontSizes(
    messageText: 20.0,
    inputText: 18.0,
    hintText: 18.0,
    timestamp: 14.0,
  );

  /// 根据年龄获取字体大小配置
  /// @param ageGroup 用户年龄组
  /// @return 对应的字体大小配置
  static FontSizes getFontSizesByAge(AgeGroup ageGroup) {
    return _fontSizesByAge[ageGroup] ?? defaultFontSizes;
  }

  /// 根据用户年龄数值获取字体大小配置
  /// @param age 用户年龄
  /// @return 对应的字体大小配置
  static FontSizes getFontSizesByAgeNumber(int age) {
    if (age < 36) {
      return getFontSizesByAge(AgeGroup.young);
    } else if (age < 56) {
      return getFontSizesByAge(AgeGroup.middle);
    } else {
      return getFontSizesByAge(AgeGroup.senior);
    }
  }

  /// 获取当前默认字体大小（偏向大字体）
  static FontSizes getCurrentFontSizes() {
    // 目前返回默认的大字体配置
    // 将来可以根据用户设置或年龄动态调整
    return defaultFontSizes;
  }
}

/// 字体大小配置类
/// 包含聊天界面中各种文本元素的字体大小
class FontSizes {
  /// 消息文本字体大小
  final double messageText;
  
  /// 输入框文本字体大小
  final double inputText;
  
  /// 提示文本字体大小
  final double hintText;
  
  /// 时间戳字体大小
  final double timestamp;

  /// 构造函数
  const FontSizes({
    required this.messageText,
    required this.inputText,
    required this.hintText,
    required this.timestamp,
  });

  /// 创建字体大小的副本，允许部分修改
  FontSizes copyWith({
    double? messageText,
    double? inputText,
    double? hintText,
    double? timestamp,
  }) {
    return FontSizes(
      messageText: messageText ?? this.messageText,
      inputText: inputText ?? this.inputText,
      hintText: hintText ?? this.hintText,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  /// 按比例缩放所有字体大小
  /// @param scale 缩放比例
  /// @return 缩放后的字体大小配置
  FontSizes scale(double scale) {
    return FontSizes(
      messageText: messageText * scale,
      inputText: inputText * scale,
      hintText: hintText * scale,
      timestamp: timestamp * scale,
    );
  }
}