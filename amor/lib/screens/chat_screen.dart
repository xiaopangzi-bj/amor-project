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
import '../widgets/chat_input.dart';
import 'login_screen.dart';

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

    // Simulate backend response
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
  }

  void _handleGeneralRequest(String content) {
    final responseMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: 'I\'m your AI shopping research assistant, and I can help you find the most suitable products. Please tell me what you want to buy?',
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
      type: MessageType.recommendation,
      data: {'products': _recommendedProducts.map((p) => p.toJson()).toList()},
    );
    setState(() {
      _messages.add(summaryMessage);
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              HSLColor.fromAHSL(1.0, 315, 0.65, 0.98).toColor(), // Very light Amor color
              HSLColor.fromAHSL(1.0, 315, 0.65, 0.95).toColor(), // Light Amor color
              HSLColor.fromAHSL(1.0, 315, 0.65, 0.92).toColor(), // Lighter Amor color
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Column(
          children: [
            // App bar - using Amor primary color gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    HSLColor.fromAHSL(1.0, 315, 0.65, 0.80).toColor(), // Medium light Amor color
                    HSLColor.fromAHSL(1.0, 315, 0.65, 0.75).toColor(), // Amor primary color
                    HSLColor.fromAHSL(1.0, 315, 0.65, 0.70).toColor(), // Medium dark Amor color
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
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
                title: const Text(
                  'Amor',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
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
                            child: const Center(
                              child: Text(
                                'G',
                                style: TextStyle(
                                  color: Color(0xFF4285F4),
                                  fontSize: 16,
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
                padding: const EdgeInsets.all(16),
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
            ChatInput(
              onSendMessage: _sendMessage,
              isLoading: _isLoading,
            ),
          ],
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
