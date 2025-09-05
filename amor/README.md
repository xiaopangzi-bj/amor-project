# Amor - AI购物研究助手

一个基于Flutter开发的智能购物研究助手应用，通过AI对话帮助用户进行产品研究和获取个性化推荐。

## 项目简介

Amor是一个现代化的移动应用，旨在通过人工智能技术简化用户的购物决策过程。用户可以通过自然语言与AI助手对话，获得专业的产品分析、价格比较和购买建议。

### 主要功能

- 🤖 **AI对话助手**: 智能理解用户需求，提供个性化产品推荐
- 🔍 **产品研究**: 深度分析产品特性、优缺点和适用场景
- 💰 **价格比较**: 多平台价格对比，帮助用户找到最优惠的购买渠道
- ⭐ **专业评测**: 基于用户评价和专业测评的综合分析
- 🏷️ **品牌推荐**: 相关品牌和替代产品推荐
- 📱 **跨平台支持**: 支持iOS、Android、Web等多个平台

## 技术栈

- **框架**: Flutter 3.x
- **开发语言**: Dart
- **状态管理**: Provider
- **用户认证**: Google Sign-In
- **UI设计**: Material Design 3
- **架构模式**: MVVM (Model-View-ViewModel)

## 项目结构

```
amor/
├── lib/
│   ├── main.dart              # 应用入口
│   ├── models/                # 数据模型
│   │   ├── user.dart
│   │   ├── product.dart
│   │   └── chat_message.dart
│   ├── providers/             # 状态管理
│   │   └── auth_provider.dart
│   ├── screens/               # 页面
│   │   ├── login_screen.dart
│   │   └── chat_screen.dart
│   ├── services/              # 服务层
│   │   └── auth_service.dart
│   └── widgets/               # 自定义组件
│       ├── message_bubble.dart
│       ├── chat_input.dart
│       └── product_recommendation_widget.dart
├── android/                   # Android平台代码
├── ios/                       # iOS平台代码
├── web/                       # Web平台代码
└── test/                      # 测试文件
```

详细的项目结构说明请参考 [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)

## 快速开始

### 环境要求

- Flutter SDK 3.0+
- Dart SDK 3.0+
- Android Studio / VS Code
- iOS开发需要Xcode (仅macOS)

### 安装步骤

1. **克隆项目**
   ```bash
   git clone <repository-url>
   cd amor
   ```

2. **安装依赖**
   ```bash
   flutter pub get
   ```

3. **配置Google登录**
   
   请参考 [GOOGLE_LOGIN_SETUP.md](GOOGLE_LOGIN_SETUP.md) 进行Google登录配置。

4. **运行应用**
   ```bash
   # 运行在调试模式
   flutter run
   
   # 运行在特定设备
   flutter run -d <device-id>
   
   # 构建发布版本
   flutter build apk  # Android
   flutter build ios  # iOS
   flutter build web  # Web
   ```

### 开发环境设置

1. **检查Flutter环境**
   ```bash
   flutter doctor
   ```

2. **获取设备列表**
   ```bash
   flutter devices
   ```

3. **运行测试**
   ```bash
   flutter test
   ```

## 功能演示

### 用户认证
- 支持Google账号一键登录
- 安全的用户会话管理
- 登录状态持久化

### AI对话体验
- 自然语言交互
- 上下文理解能力
- 多轮对话支持

### 产品推荐系统
- 个性化推荐算法
- 多维度产品分析
- 实时价格更新

详细的功能演示请参考 [LOGIN_DEMO.md](LOGIN_DEMO.md)

## 开发指南

### 代码规范

- 遵循Dart官方代码规范
- 使用有意义的变量和函数命名
- 为所有公共API添加文档注释
- 保持代码简洁和可读性

### 提交规范

- 使用清晰的提交信息
- 每次提交包含单一功能或修复
- 提交前运行代码检查和测试

### 测试策略

- 单元测试覆盖核心业务逻辑
- Widget测试验证UI组件
- 集成测试确保端到端功能

## 部署说明

### Android部署
```bash
# 构建APK
flutter build apk --release

# 构建App Bundle
flutter build appbundle --release
```

### iOS部署
```bash
# 构建iOS应用
flutter build ios --release
```

### Web部署
```bash
# 构建Web应用
flutter build web --release
```

## 贡献指南

我们欢迎社区贡献！请遵循以下步骤：

1. Fork本项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建Pull Request

## 许可证

本项目采用MIT许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 联系我们

- 项目维护者: [Your Name]
- 邮箱: [your.email@example.com]
- 项目链接: [https://github.com/yourusername/amor]

## 致谢

感谢以下开源项目和资源：

- [Flutter](https://flutter.dev/) - 跨平台UI框架
- [Provider](https://pub.dev/packages/provider) - 状态管理解决方案
- [Google Sign-In](https://pub.dev/packages/google_sign_in) - Google认证集成
- [Material Design](https://material.io/) - UI设计规范

---

**注意**: 在生产环境中需要集成真实的AI服务API。
