import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../models/product.dart';
import '../widgets/message_bubble.dart';
import '../widgets/product_filter_widget.dart';
import '../widgets/research_widget.dart';
import '../widgets/product_recommendation_widget.dart';
import '../widgets/chat_input.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  List<ProductFilter> _currentFilters = [];
  List<ResearchStep> _researchSteps = [];
  List<Product> _recommendedProducts = [];
  String? _vettedAnalysis;

  @override
  void initState() {
    super.initState();
    // 添加欢迎消息
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    _messages.add(ChatMessage(
      id: 'welcome',
      content: '您好，我是您的AI购物研究助手！我可以帮您找到最适合的商品。请告诉我您想购买什么？',
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage(String content) {
    // 添加用户消息
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    );
    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });

    // 模拟后端响应
    Future.delayed(const Duration(seconds: 1), () {
      _handleUserMessage(content);
    });
  }

  void _handleUserMessage(String content) {
    if (content.contains('外套') || content.contains('夹克')) {
      _handleProductCategoryRequest(content);
    } else if (content.contains('飞行员') || content.contains('牛仔') || content.contains('皮夹克')) {
      _handleProductTypeRequest(content);
    } else {
      _handleGeneralRequest(content);
    }
  }

  void _handleProductCategoryRequest(String content) {
    setState(() {
      _currentFilters = [
        ProductFilter(
          id: '1',
          title: '夹克',
          description: '轻便、时尚，适合日常穿着或春秋季节',
        ),
        ProductFilter(
          id: '2',
          title: '大衣',
          description: '保暖、正式，适合秋冬季节或商务场合',
        ),
        ProductFilter(
          id: '3',
          title: '羽绒服',
          description: '极致保暖，适合寒冷天气或冬季运动',
        ),
        ProductFilter(
          id: '4',
          title: '风衣',
          description: '防风、防雨，适合多变天气或旅行',
        ),
      ];
      _isLoading = false;
    });

    final responseMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: '您想找哪种类型的外套？请从列表中选择一个选项，或者输入您要找的。',
      isUser: false,
      timestamp: DateTime.now(),
      type: MessageType.productFilter,
      data: {'filters': _currentFilters.map((f) => f.toJson()).toList()},
    );
    setState(() {
      _messages.add(responseMessage);
    });
  }

  void _handleProductTypeRequest(String content) {
    setState(() {
      _currentFilters = [
        ProductFilter(
          id: '1',
          title: '飞行员夹克',
          description: '经典款式，通常有罗纹袖口和下摆，适合休闲和运动风格',
        ),
        ProductFilter(
          id: '2',
          title: '牛仔夹克',
          description: '耐用且百搭，适合日常穿着，可搭配多种服装',
        ),
        ProductFilter(
          id: '3',
          title: '皮夹克',
          description: '时尚且具有保护性，适合骑行或打造硬朗造型',
        ),
        ProductFilter(
          id: '4',
          title: '羽绒夹克',
          description: '轻便保暖，填充羽绒或合成材料，适合寒冷天气',
        ),
        ProductFilter(
          id: '5',
          title: '风衣',
          description: '轻薄防风，通常有防水功能，适合春秋季节或户外活动',
        ),
      ];
      _isLoading = false;
    });

    final responseMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: '您想找哪种类型的夹克？请从列表中选择一个选项，或者输入您要查找的内容。',
      isUser: false,
      timestamp: DateTime.now(),
      type: MessageType.productFilter,
      data: {'filters': _currentFilters.map((f) => f.toJson()).toList()},
    );
    setState(() {
      _messages.add(responseMessage);
    });
  }

  void _handleGeneralRequest(String content) {
    final responseMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: '我是您的AI购物研究助手，可以帮助您找到最适合的商品。请告诉我您想购买什么？',
      isUser: false,
      timestamp: DateTime.now(),
    );
    setState(() {
      _messages.add(responseMessage);
      _isLoading = false;
    });
  }

  void _selectFilter(ProductFilter filter) {
    setState(() {
      _isLoading = true;
    });

    // 模拟研究过程
    _simulateResearch(filter);
  }

  void _simulateResearch(ProductFilter filter) {
    setState(() {
      _researchSteps = [
        ResearchStep(
          id: '1',
          title: '评估顶级${filter.title}...',
          isCompleted: true,
          isActive: false,
        ),
        ResearchStep(
          id: '2',
          title: '分析顶级${filter.title}品牌...',
          isCompleted: true,
          isActive: false,
        ),
        ResearchStep(
          id: '3',
          title: '比较不同材质的${filter.title}...',
          isCompleted: true,
          isActive: false,
        ),
        ResearchStep(
          id: '4',
          title: '评估保暖性和季节适用性...',
          isCompleted: true,
          isActive: false,
        ),
        ResearchStep(
          id: '5',
          title: '研究款式和剪裁...',
          isCompleted: true,
          isActive: false,
        ),
        ResearchStep(
          id: '6',
          title: 'Summarizing findings...',
          isCompleted: false,
          isActive: true,
        ),
      ];
    });

    final researchMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: 'Research',
      isUser: false,
      timestamp: DateTime.now(),
      type: MessageType.research,
      data: {'steps': _researchSteps.map((s) => s.toJson()).toList()},
    );
    setState(() {
      _messages.add(researchMessage);
    });

    // 模拟研究完成
    Future.delayed(const Duration(seconds: 2), () {
      _simulateRecommendations(filter);
    });
  }

  void _simulateRecommendations(ProductFilter filter) {
    setState(() {
      _vettedAnalysis = '''
${filter.title}是男士的经典时尚单品，强调材质、保暖性和剪裁。像"Cockpit USA G-1"和"Cockpit USA A-2"这样的型号因其历史意义和在电影中的出现（如"Top Gun"）而备受推崇。Cockpit USA在美国制造并提供定制服务。客户评价："真正永恒且实用"的羊皮A-2夹克。"Cockpit USA A-2"被认为是"第一件飞行员夹克"。r/malefashionadvice论坛用户和Cockpit USA为美国军方提供产品。
      ''';

      _recommendedProducts = [
        Product(
          id: '1',
          name: 'Cockpit USA G-1 飞行夹克',
          description: '这款夹克适合追求历史真实性和经典军事风格的爱好者，其优质皮革和毛皮村里提供卓越的保护和舒适度。',
          imageUrl: 'https://via.placeholder.com/300x400/8B4513/FFFFFF?text=G-1+Jacket',
          rating: 4.6,
          reviewCount: 6,
          prices: [
            PriceInfo(store: 'Bradshawforbes', price: 640, currency: '\$'),
            PriceInfo(store: 'Uswings', price: 650, currency: '\$'),
          ],
          features: ['经典款式', '优质皮革', '毛皮领子', '美国制造'],
          category: '最佳经典款',
          brand: 'Cockpit USA',
        ),
        Product(
          id: '2',
          name: 'Cockpit USA A-2 飞行夹克',
          description: '对于那些欣赏传统军事服装和美国制造品质的人来说，这款夹克是理想选择，它提供了永恒的风格和定制的可能性。',
          imageUrl: 'https://via.placeholder.com/300x400/654321/FFFFFF?text=A-2+Jacket',
          rating: 4.0,
          reviewCount: 307,
          prices: [
            PriceInfo(store: 'Mypilotstore', price: 645, currency: '\$'),
            PriceInfo(store: 'Cockpitusa', price: 0, currency: '\$'),
          ],
          features: ['复刻款式', '定制服务', '军事风格', '美国制造'],
          category: '最佳复刻款',
          brand: 'Cockpit USA',
        ),
      ];

      _isLoading = false;
    });

    final analysisMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: _vettedAnalysis!,
      isUser: false,
      timestamp: DateTime.now(),
      type: MessageType.productRecommendation,
      data: {
        'analysis': _vettedAnalysis,
        'products': _recommendedProducts.map((p) => p.toJson()).toList(),
      },
    );
    setState(() {
      _messages.add(analysisMessage);
    });
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
      _currentFilters.clear();
      _researchSteps.clear();
      _recommendedProducts.clear();
      _vettedAnalysis = null;
    });
    _addWelcomeMessage();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'AI购物助手',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _clearChat,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < _messages.length) {
                  final message = _messages[index];
                  return _buildMessage(message);
                } else {
                  // 显示加载指示器
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B6B)),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          ChatInput(
            onSendMessage: _sendMessage,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    switch (message.type) {
      case MessageType.productFilter:
        return ProductFilterWidget(
          message: message,
          onFilterSelected: _selectFilter,
          onSkip: () {
            _selectFilter(ProductFilter(
              id: 'general',
              title: '通用推荐',
              description: '为您推荐的热门商品',
            ));
          },
        );
      case MessageType.research:
        return ResearchWidget(
          message: message,
          researchSteps: _researchSteps,
        );
      case MessageType.productRecommendation:
        return ProductRecommendationWidget(
          message: message,
          analysis: _vettedAnalysis ?? '',
          products: _recommendedProducts,
        );
      case MessageType.skipOption:
        return MessageBubble(
          message: message,
          onTap: () {
            _selectFilter(ProductFilter(
              id: 'general',
              title: '通用推荐',
              description: '为您推荐的热门商品',
            ));
          },
        );
      default:
        return MessageBubble(message: message);
    }
  }
}
