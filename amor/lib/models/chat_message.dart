/// 聊天消息数据模型
/// 表示聊天界面中的单条消息，支持多种消息类型和附加数据
class ChatMessage {
  /// 消息唯一标识符
  final String id;
  
  /// 消息内容文本
  final String content;
  
  /// 是否为用户发送的消息（true：用户消息，false：AI回复）
  final bool isUser;
  
  /// 消息发送时间戳
  final DateTime timestamp;
  
  /// 消息类型（文本、产品筛选、研究步骤等）
  final MessageType type;
  
  /// 附加数据（可选），用于存储特定类型消息的额外信息
  final Map<String, dynamic>? data;

  /// 构造函数
  /// 创建聊天消息实例
  /// @param id 消息ID（必需）
  /// @param content 消息内容（必需）
  /// @param isUser 是否为用户消息（必需）
  /// @param timestamp 时间戳（必需）
  /// @param type 消息类型（默认为文本类型）
  /// @param data 附加数据（可选）
  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.type = MessageType.text,
    this.data,
  });

  /// 从JSON数据创建聊天消息对象
  /// 用于从本地存储或网络响应中恢复消息数据
  /// @param json 包含消息信息的JSON Map
  /// @return ChatMessage实例
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      content: json['content'],
      isUser: json['isUser'],
      timestamp: DateTime.parse(json['timestamp']), // 解析ISO8601时间字符串
      type: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${json['type']}',
        orElse: () => MessageType.text, // 如果类型不匹配，默认为文本类型
      ),
      data: json['data'], // 附加数据可能为null
    );
  }

  /// 将聊天消息对象转换为JSON格式
  /// 用于数据持久化、网络传输等场景
  /// @return 包含消息信息的Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(), // 转换为ISO8601时间字符串
      'type': type.toString().split('.').last, // 提取枚举值名称
      'data': data,
    };
  }
}

/// 消息类型枚举
/// 定义聊天消息的不同类型，用于区分消息内容和渲染方式
enum MessageType {
  /// 普通文本消息
  text,
  
  /// 产品筛选消息（包含筛选条件）
  productFilter,
  
  /// 研究步骤消息（显示AI研究进度）
  research,
  
  /// 产品推荐消息（包含推荐的产品列表）
  productRecommendation,

  /// 仅商品卡片（不含分析/研究等模块）
  productCards,
  
  /// 跳过选项消息（提供跳过当前步骤的选项）
  skipOption,
}
