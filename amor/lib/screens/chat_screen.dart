import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chat_message.dart';
import '../models/product.dart';
import '../providers/auth_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/loading_message_bubble.dart';
import '../widgets/product_filter_widget.dart';
import '../widgets/research_widget.dart';
import '../widgets/product_recommendation_widget.dart';
import '../widgets/product_cards_widget.dart';
import '../widgets/chat_input.dart';
import '../config/font_config.dart';
import '../config/prompt_config.dart';
import 'login_screen.dart';
import '../services/api_service.dart';
import '../services/deepseek_service.dart';

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
  
  // 接入后端服务
  final ApiService _apiService = ApiService();
  // AI 对话服务
  final DeepSeekService _deepSeekService = DeepSeekService();

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _addWelcomeMessage();
    
    // Ensure AuthProvider is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (!authProvider.isInitialized) {
        debugPrint('🔧 [CHAT DEBUG] AuthProvider not initialized, starting initialization...');
        authProvider.initialize().then((_) {
          debugPrint('✅ [CHAT DEBUG] AuthProvider initialization completed');
        }).catchError((error) {
          debugPrint('❌ [CHAT DEBUG] AuthProvider initialization failed: $error');
        });
      } else {
        debugPrint('✅ [CHAT DEBUG] AuthProvider already initialized');
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    _messages.add(ChatMessage(
      id: 'welcome',
      content: 'Hello!  Amor here — your friendly shopping robot.  How can I help you today?',
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      // 使用更短的动画时间和更平滑的曲线
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
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

    // 在消息添加后立即滚动到底部
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    // 检查是否包含“买一个”并优先处理搜索逻辑
    final keyword = _extractBuyOneKeyword(content);
    if (keyword != null && keyword.isNotEmpty) {
      _handleBuyOneSearch(keyword);
      return;
    }

    // 其它逻辑保持不变（模拟响应）
    Future.delayed(const Duration(seconds: 1), () {
      _handleUserMessage(content);
    });
  }

  void _handleUserMessage(String content) {
    // 本地拦截：当用户询问“这是什么/做什么/你是谁”等，直接用提示词回复
    if (_isAboutQuestion(content)) {
      final aboutMsg = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: PromptConfig.aboutAssistant,
        isUser: false,
        timestamp: DateTime.now(),
      );
      setState(() {
        _messages.add(aboutMsg);
        _isLoading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      return;
    }
    if (content.contains('coat') || content.contains('jacket')) {
      _handleProductCategoryRequest(content);
    } else if (content.contains('bomber') || content.contains('denim') || content.contains('leather')) {
      _handleProductTypeRequest(content);
    } else {
      _handleGeneralAICompletion(content);
    }
  }

  bool _isAboutQuestion(String content) {
    final text = content.trim().toLowerCase();
    // 简单关键词匹配（中英文）
    final patterns = <String>[
      '做什么', '是什么', '你是谁', '用途', '作用', '介绍一下', '介绍下',
      'what is this', 'what do you do', 'who are you', 'what can you do', 'about you',
    ];
    return patterns.any((p) => text.contains(p));
  }

  // 解析“买一个”后的关键字
  String? _extractBuyOneKeyword(String content) {
    // 支持中文与英文触发词："买一个"、"buy an"、"buy a"
    final lc = content.toLowerCase();
    final triggers = ['买一个', 'buy an', 'buy a'];
    int foundIdx = -1;
    String foundTrigger = '';

    for (final t in triggers) {
      final i = lc.indexOf(t);
      if (i != -1 && (foundIdx == -1 || i < foundIdx)) {
        foundIdx = i;
        foundTrigger = t;
      }
    }

    if (foundIdx == -1) return null;

    // 提取触发词后的文本作为关键字
    String keyword = content.substring(foundIdx + foundTrigger.length).trim();
    // 去除开头的标点符号与空格
    keyword = keyword.replaceFirst(RegExp(r'^[,.:;，。；、!！\?\s]+'), '').trim();
    return keyword.isNotEmpty ? keyword : null;
  }

  // 调用接口按标题搜索并直接展示商品卡片
  Future<void> _handleBuyOneSearch(String keyword) async {
    setState(() {
      _isLoading = true;
      _recommendedProducts = [];
      _vettedAnalysis = null;
    });

    try {
      final result = await _apiService.searchProductsByTitle(title: keyword, size: 20, queryType: 0);
      final items = List<Product>.from(result['items'] ?? const []);

      setState(() {
        _recommendedProducts = items;
        _isLoading = false;
      });

      final cardsMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: '为你找到${items.length}件与“$keyword”相关的商品',
        isUser: false,
        timestamp: DateTime.now(),
        type: MessageType.productCards,
        data: {'products': items.map((p) => p.toJson()).toList()},
      );
      setState(() {
        _messages.add(cardsMessage);
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      final errorMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: '搜索失败，请稍后重试。',
        isUser: false,
        timestamp: DateTime.now(),
      );
      setState(() {
        _messages.add(errorMessage);
      });
    }
  }

  void _handleProductCategoryRequest(String content) {
    setState(() {
      _currentFilters = [
        ProductFilter(
          id: '1',
          title: 'Jacket',
          description: 'Lightweight and stylish, suitable for daily wear or spring/autumn seasons',
        ),
        ProductFilter(
          id: '2',
          title: 'Coat',
          description: 'Warm and formal, suitable for autumn/winter seasons or business occasions',
        ),
        ProductFilter(
          id: '3',
          title: 'Down Jacket',
          description: 'Ultimate warmth, suitable for cold weather or winter sports',
        ),
        ProductFilter(
          id: '4',
          title: 'Windbreaker',
          description: 'Wind and rain resistant, suitable for variable weather or travel',
        ),
      ];
      _isLoading = false;
    });

    final responseMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: 'What type of outerwear are you looking for? Please select an option from the list, or type what you\'re looking for.',
      isUser: false,
      timestamp: DateTime.now(),
      type: MessageType.productFilter,
      data: {'filters': _currentFilters.map((f) => f.toJson()).toList()},
    );
    setState(() {
      _messages.add(responseMessage);
    });
    
    // 在响应消息添加后滚动到底部
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _handleProductTypeRequest(String content) {
    setState(() {
      _currentFilters = [
        ProductFilter(
          id: '1',
          title: 'Bomber Jacket',
          description: 'Classic style with ribbed cuffs and hem, suitable for casual and sporty looks',
        ),
        ProductFilter(
          id: '2',
          title: 'Denim Jacket',
          description: 'Durable and versatile, suitable for daily wear and pairs with various outfits',
        ),
        ProductFilter(
          id: '3',
          title: 'Leather Jacket',
          description: 'Stylish and protective, suitable for riding or creating a tough look',
        ),
        ProductFilter(
          id: '4',
          title: 'Puffer Jacket',
          description: 'Lightweight and warm, filled with down or synthetic materials, suitable for cold weather',
        ),
        ProductFilter(
          id: '5',
          title: 'Windbreaker',
          description: 'Lightweight and windproof, usually with waterproof features, suitable for spring/autumn or outdoor activities',
        ),
      ];
      _isLoading = false;
    });

    final responseMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: 'What type of jacket are you looking for? Please select an option from the list, or type what you want to search for.',
      isUser: false,
      timestamp: DateTime.now(),
      type: MessageType.productFilter,
      data: {'filters': _currentFilters.map((f) => f.toJson()).toList()},
    );
    setState(() {
      _messages.add(responseMessage);
    });
    
    // 在响应消息添加后滚动到底部
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  /// 通用对话：调用 DeepSeek 获取回复
  Future<void> _handleGeneralAICompletion(String content) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 构建最近对话上下文，限制长度避免过长
      final int maxContext = 8;
      final recent = _messages.length > maxContext
          ? _messages.sublist(_messages.length - maxContext)
          : _messages;
      final messagesPayload = [
        for (final m in recent)
          {
            'role': m.isUser ? 'user' : 'assistant',
            'content': m.content,
          },
        {
          'role': 'user',
          'content': content,
        }
      ];

      // 先插入一个空的 AI 消息占位，用于逐字填充
      final placeholderId = DateTime.now().millisecondsSinceEpoch.toString();
      setState(() {
        _messages.add(ChatMessage(
          id: placeholderId,
          content: '',
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

      final stream = _deepSeekService.chatStream(
        messages: List<Map<String, String>>.from(messagesPayload),
      );

      String buffer = '';
      bool gotDelta = false;
      final int aiIndex = _messages.length - 1;

      await for (final delta in stream) {
        buffer += delta;
        gotDelta = true;
        // 收到首个增量后取消 Loading 消息气泡，仅保留增量渲染
        if (_isLoading) {
          setState(() {
            _isLoading = false;
          });
        }
        // 更新占位消息内容
        setState(() {
          _messages[aiIndex] = ChatMessage(
            id: _messages[aiIndex].id,
            content: buffer,
            isUser: false,
            timestamp: _messages[aiIndex].timestamp,
          );
        });
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }

      // 流结束，若未收到任何增量，兜底调用非流式接口
      if (!gotDelta) {
        final reply = await _deepSeekService.chat(
          messages: List<Map<String, String>>.from(messagesPayload),
        );
        setState(() {
          _messages[aiIndex] = ChatMessage(
            id: _messages[aiIndex].id,
            content: reply.trim().isEmpty ? '（空回复）' : reply.trim(),
            isUser: false,
            timestamp: _messages[aiIndex].timestamp,
          );
          _isLoading = false;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    } catch (e) {
      final fallback = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content:
            '暂时无法连接到 DeepSeek。请确认已通过 --dart-define 注入 DEEPSEEK_API_KEY，或稍后重试。\n错误：$e',
        isUser: false,
        timestamp: DateTime.now(),
      );
      setState(() {
        _messages.add(fallback);
        _isLoading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
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
          title: 'Evaluating top ${filter.title}...',
          isCompleted: true,
          isActive: false,
        ),
        ResearchStep(
          id: '2',
          title: 'Analyzing top ${filter.title} brands...',
          isCompleted: true,
          isActive: false,
        ),
        ResearchStep(
          id: '3',
          title: 'Comparing different ${filter.title} materials...',
          isCompleted: true,
          isActive: false,
        ),
        ResearchStep(
          id: '4',
          title: 'Evaluating warmth and seasonal suitability...',
          isCompleted: true,
          isActive: false,
        ),
        ResearchStep(
          id: '5',
          title: 'Researching styles and cuts...',
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

    // 在研究消息添加后滚动到底部
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    // Simulate research completion
    Future.delayed(const Duration(seconds: 2), () {
      _simulateRecommendations(filter);
    });
  }

  void _simulateRecommendations(ProductFilter filter) {
    setState(() {
      _vettedAnalysis = '''
${filter.title} is a classic fashion item for men, emphasizing material, warmth, and cut. Models like "Cockpit USA G-1" and "Cockpit USA A-2" are highly regarded for their historical significance and appearances in movies (such as "Top Gun"). Cockpit USA is made in the USA and offers custom services. Customer reviews: "truly timeless and practical" sheepskin A-2 jacket. "Cockpit USA A-2" is considered "the first pilot jacket". r/malefashionadvice forum users and Cockpit USA supply products to the U.S. military.
      ''';

      _recommendedProducts = [
        Product(
          id: '1',
          name: 'Cockpit USA G-1 Flight Jacket',
          description: 'This jacket is suitable for enthusiasts seeking historical authenticity and classic military style, with premium leather and fur collar providing exceptional protection and comfort.',
          imageUrl: 'https://via.placeholder.com/300x400/8B4513/FFFFFF?text=G-1+Jacket',
          rating: 4.6,
          reviewCount: 6,
          prices: [
            PriceInfo(store: 'Bradshawforbes', price: 640, currency: '\$'),
            PriceInfo(store: 'Uswings', price: 650, currency: '\$'),
          ],
          features: ['Classic style', 'Premium leather', 'Fur collar', 'Made in USA'],
          category: 'Best Classic',
          brand: 'Cockpit USA',
        ),
        Product(
          id: '2',
          name: 'Cockpit USA A-2 Flight Jacket',
          description: 'Ideal for those who appreciate traditional military clothing and American-made quality, this jacket offers timeless style and customization possibilities.',
          imageUrl: 'https://via.placeholder.com/300x400/654321/FFFFFF?text=A-2+Jacket',
          rating: 4.0,
          reviewCount: 307,
          prices: [
            PriceInfo(store: 'Mypilotstore', price: 645, currency: '\$'),
            PriceInfo(store: 'Cockpitusa', price: 0, currency: '\$'),
          ],
          features: ['Replica style', 'Custom service', 'Military style', 'Made in USA'],
          category: 'Best Replica',
          brand: 'Cockpit USA',
        ),
      ];

      _isLoading = false;
    });

    final summaryMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: 'Based on my research, I found the following ${filter.title} recommendations for you:',
      isUser: false,
      timestamp: DateTime.now(),
      type: MessageType.productRecommendation,
      data: {'products': _recommendedProducts.map((p) => p.toJson()).toList()},
    );
    setState(() {
      _messages.add(summaryMessage);
    });
    
    // 在推荐消息添加后滚动到底部
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
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
    // 移除自动滚动逻辑，避免每次重建都滚动
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // 点击空白区域时失去焦点
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFE91E63), // 与 HTML 一致的粉红色
                Color(0xFF9C27B0), // 与 HTML 一致的紫色
              ],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                children: [
                  // App bar - transparent to show background gradient
                  Container(
                  decoration: BoxDecoration(
                    // 移除 AppBar 的独立渐变，让背景渐变透过
                    boxShadow: [
                      BoxShadow(
                        color: HSLColor.fromAHSL(0.2, 315, 0.65, 0.60).toColor(),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: AppBar(
                    backgroundColor: Colors.transparent, // Transparent background to show gradient
                    elevation: 0, // Remove default shadow
                    foregroundColor: Colors.white, // White text and icons
                  title: Text(
                    'Amor',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: FontConfig.getCurrentFontSizes().messageText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  centerTitle: true,
                  actions: [
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        // Add debug information
                        debugPrint('🔍 [CHAT DEBUG] AuthProvider status: isLoggedIn=${authProvider.isLoggedIn}, isInitialized=${authProvider.isInitialized}, user=${authProvider.user?.email ?? 'null'}');
                        
                        if (authProvider.isLoggedIn && authProvider.user != null) {
                          // Logged in: show refresh and sign out buttons
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.refresh, color: Colors.white),
                                tooltip: 'Clear chat history',
                                onPressed: _clearChat,
                              ),
                              IconButton(
                                icon: const Icon(Icons.logout, color: Colors.white),
                                tooltip: 'Sign out',
                                onPressed: () async {
                                  debugPrint('🚪 [CHAT DEBUG] Clicked sign out');
                                  await authProvider.signOut();
                                },
                              ),
                            ],
                          );
                        } else {
                          // Not logged in: show Google G icon
                          return IconButton(
                            icon: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  'G',
                                  style: TextStyle(
                                    color: Color(0xFF4285F4),
                                    fontSize: FontConfig.getCurrentFontSizes().inputText,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            tooltip: 'Sign in with Google account',
                            onPressed: () {
                              debugPrint('🚀 [CHAT DEBUG] Clicked login button, navigating to login page');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                        bottom: MediaQuery.of(context).padding.bottom + 96, // 为悬浮输入框预留空间
                      ),
                      itemCount: _messages.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < _messages.length) {
                          final message = _messages[index];
                          return _buildMessage(message);
                        } else {
                          // Show loading message bubble
                          return const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: LoadingMessageBubble(),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              // 悬浮于页面底部的输入框
              Align(
                alignment: Alignment.bottomCenter,
                child: ChatInput(
                  onSendMessage: _sendMessage,
                  isLoading: _isLoading,
                ),
              ),
            ],
          ),
        ),
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
              title: 'General Recommendations',
              description: 'Popular products recommended for you',
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
      case MessageType.productCards:
        return ProductCardsWidget(
          message: message,
          products: _recommendedProducts,
        );
      case MessageType.skipOption:
        return MessageBubble(
          message: message,
          onTap: () {
            _selectFilter(ProductFilter(
              id: 'general',
              title: 'General Recommendations',
              description: 'Popular products recommended for you',
            ));
          },
        );
      default:
        return MessageBubble(message: message);
    }
  }
}
