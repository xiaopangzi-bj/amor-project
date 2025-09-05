/// 用户数据模型
/// 表示应用中的用户信息，包括基本信息和可选的显示信息
/// 支持从Google登录数据创建、JSON序列化等功能
class User {
  /// 用户唯一标识符
  final String id;
  
  /// 用户邮箱地址
  final String email;
  
  /// 用户姓名
  final String name;
  
  /// 用户头像URL（可选）
  final String? photoUrl;
  
  /// 用户显示名称（可选，通常用于UI显示）
  final String? displayName;

  /// 构造函数
  /// @param id 用户ID（必需）
  /// @param email 用户邮箱（必需）
  /// @param name 用户姓名（必需）
  /// @param photoUrl 头像URL（可选）
  /// @param displayName 显示名称（可选）
  const User({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    this.displayName,
  });

  /// 从Google登录数据创建用户对象
  /// 处理Google Sign-In返回的用户数据，提取必要信息创建User实例
  /// @param data Google登录返回的用户数据Map
  /// @return User实例
  factory User.fromGoogleSignIn(Map<String, dynamic> data) {
    return User(
      id: data['id'] ?? '', // 用户ID，默认为空字符串
      email: data['email'] ?? '', // 邮箱地址，默认为空字符串
      name: data['name'] ?? data['displayName'] ?? '', // 优先使用name，其次displayName
      photoUrl: data['photoUrl'], // 头像URL，可能为null
      displayName: data['displayName'], // 显示名称，可能为null
    );
  }

  /// 将用户对象转换为JSON格式
  /// 用于数据持久化、网络传输等场景
  /// @return 包含用户信息的Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'displayName': displayName,
    };
  }

  /// 从JSON数据创建用户对象
  /// 用于从本地存储或网络响应中恢复用户数据
  /// @param json 包含用户信息的JSON Map
  /// @return User实例
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '', // 用户ID，默认为空字符串
      email: json['email'] ?? '', // 邮箱地址，默认为空字符串
      name: json['name'] ?? '', // 用户姓名，默认为空字符串
      photoUrl: json['photoUrl'], // 头像URL，可能为null
      displayName: json['displayName'], // 显示名称，可能为null
    );
  }

  /// 创建当前用户对象的副本，可选择性地更新某些字段
  /// 由于User是不可变对象，需要通过此方法来"修改"用户信息
  /// @param id 新的用户ID（可选）
  /// @param email 新的邮箱地址（可选）
  /// @param name 新的用户姓名（可选）
  /// @param photoUrl 新的头像URL（可选）
  /// @param displayName 新的显示名称（可选）
  /// @return 更新后的User实例
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    String? displayName,
  }) {
    return User(
      id: id ?? this.id, // 使用新值或保持原值
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      displayName: displayName ?? this.displayName,
    );
  }

  /// 重写相等性比较操作符
  /// 比较两个User对象是否相等（所有字段都相同）
  /// @param other 要比较的对象
  /// @return 是否相等
  @override
  bool operator ==(Object other) {
    // 如果是同一个对象引用，直接返回true
    if (identical(this, other)) return true;
    // 检查类型并比较所有字段
    return other is User &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.photoUrl == photoUrl &&
        other.displayName == displayName;
  }

  /// 重写哈希码计算
  /// 基于所有字段计算哈希值，确保相等的对象有相同的哈希码
  /// @return 对象的哈希码
  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        name.hashCode ^
        photoUrl.hashCode ^
        displayName.hashCode;
  }

  /// 重写字符串表示方法
  /// 返回包含所有字段信息的字符串，便于调试和日志记录
  /// @return 用户对象的字符串表示
  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, photoUrl: $photoUrl, displayName: $displayName)';
  }
}
