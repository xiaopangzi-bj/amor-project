# Amor - AI购物研究助手项目结构说明

## 项目概述

Amor是一个基于Flutter开发的AI购物研究助手应用，帮助用户通过AI对话进行产品研究和推荐。本文档详细说明了项目的目录结构和各个文件的作用。

## 根目录结构

```
amor/
├── lib/                    # 主要源代码目录
├── android/                # Android平台特定代码
├── ios/                    # iOS平台特定代码
├── web/                    # Web平台特定代码
├── windows/                # Windows平台特定代码
├── linux/                  # Linux平台特定代码
├── macos/                  # macOS平台特定代码
├── test/                   # 测试文件目录
├── pubspec.yaml           # Flutter项目配置文件
├── pubspec.lock           # 依赖版本锁定文件
├── README.md              # 项目说明文档
├── GOOGLE_LOGIN_SETUP.md  # Google登录设置指南
├── LOGIN_DEMO.md          # 登录演示说明
├── analysis_options.yaml  # 代码分析配置
├── .gitignore             # Git忽略文件配置
└── .metadata              # Flutter元数据文件
```

## lib/ 目录详细结构

### 主要目录说明

```
lib/
├── main.dart              # 应用程序入口文件
├── models/                # 数据模型目录
├── providers/             # 状态管理提供者目录
├── screens/               # 页面/屏幕目录
├── services/              # 服务类目录
└── widgets/               # 自定义组件目录
```

### 1. main.dart
- **作用**: 应用程序的入口点
- **功能**: 
  - 初始化Flutter应用
  - 配置Provider状态管理
  - 设置应用主题
  - 管理认证状态和路由

### 2. models/ 目录

数据模型定义目录，包含应用中使用的所有数据结构。

```
models/
├── user.dart             # 用户数据模型
├── product.dart          # 产品相关数据模型
└── chat_message.dart     # 聊天消息数据模型
```

#### user.dart
- **User类**: 用户信息模型
  - 包含用户ID、邮箱、姓名、头像等基本信息
  - 提供Google登录数据转换方法
  - 支持JSON序列化和反序列化

#### product.dart
- **Product类**: 产品信息模型
  - 包含产品基本信息、评分、价格、特性等
  - **PriceInfo类**: 价格信息模型
  - **ProductFilter类**: 产品筛选条件模型
  - **ResearchStep类**: 研究步骤模型

#### chat_message.dart
- **ChatMessage类**: 聊天消息模型
  - 支持不同类型的消息（文本、产品推荐等）
  - **MessageType枚举**: 定义消息类型

### 3. providers/ 目录

状态管理提供者目录，使用Provider模式管理应用状态。

```
providers/
└── auth_provider.dart    # 认证状态管理
```

#### auth_provider.dart
- **AuthProvider类**: 认证状态管理器
  - 管理用户登录状态
  - 处理Google登录/登出
  - 提供认证状态变化通知
  - 集成AuthService进行实际认证操作

### 4. screens/ 目录

应用页面/屏幕目录，包含所有用户界面页面。

```
screens/
├── login_screen.dart     # 登录页面
└── chat_screen.dart      # 聊天主页面
```

#### login_screen.dart
- **LoginScreen类**: 用户登录界面
  - 提供Google登录按钮
  - 显示应用介绍和功能说明
  - 处理登录状态和加载指示器

#### chat_screen.dart
- **ChatScreen类**: 主聊天界面
  - AI对话功能
  - 消息列表显示
  - 用户输入处理
  - 产品推荐展示
  - 用户菜单和登出功能

### 5. services/ 目录

服务类目录，包含业务逻辑和外部API交互。

```
services/
└── auth_service.dart     # 认证服务
```

#### auth_service.dart
- **AuthService类**: 认证服务（单例模式）
  - 处理Google OAuth登录
  - 管理用户会话状态
  - 提供登录/登出接口
  - 本地认证状态持久化

### 6. widgets/ 目录

自定义UI组件目录，包含可复用的界面组件。

```
widgets/
├── message_bubble.dart              # 消息气泡组件
├── chat_input.dart                  # 聊天输入组件
└── product_recommendation_widget.dart # 产品推荐组件
```

#### message_bubble.dart
- **MessageBubble类**: 聊天消息气泡
  - 支持用户和AI消息的不同样式
  - 显示头像、消息内容和时间
  - 支持点击事件处理

#### chat_input.dart
- **ChatInput类**: 聊天输入框
  - 文本输入和发送功能
  - 加载状态指示器
  - 发送按钮状态管理

#### product_recommendation_widget.dart
- **ProductRecommendationWidget类**: 产品推荐展示组件
  - 研究步骤展示
  - 专业分析内容
  - 品牌轮播展示
  - 产品卡片列表
  - 用户反馈收集
  - 相关话题推荐

## 平台特定目录

### android/
Android平台的原生代码和配置文件，包含：
- 应用配置和权限设置
- 原生Android代码集成
- 构建脚本和依赖管理

### ios/
iOS平台的原生代码和配置文件，包含：
- Xcode项目配置
- iOS应用设置和权限
- 原生iOS代码集成

### web/
Web平台的资源和配置文件，包含：
- HTML入口文件
- Web应用图标和清单文件
- PWA配置

### windows/, linux/, macos/
桌面平台的原生代码和配置文件，支持跨平台部署。

## 配置文件说明

### pubspec.yaml
Flutter项目的核心配置文件，定义：
- 项目基本信息
- 依赖包管理
- 资源文件配置
- 平台特定设置

### analysis_options.yaml
代码分析和linting规则配置，确保代码质量和一致性。

## 技术栈

- **框架**: Flutter 3.x
- **语言**: Dart
- **状态管理**: Provider
- **认证**: Google Sign-In
- **UI设计**: Material Design 3
- **架构模式**: MVVM (Model-View-ViewModel)

## 开发规范

1. **代码组织**: 按功能模块划分目录结构
2. **命名规范**: 使用驼峰命名法和描述性名称
3. **注释规范**: 所有公共API和复杂逻辑都有详细中文注释
4. **状态管理**: 使用Provider进行集中状态管理
5. **错误处理**: 统一的异常处理和用户提示

## 扩展指南

### 添加新页面
1. 在`screens/`目录下创建新的页面文件
2. 在`main.dart`中配置路由
3. 如需状态管理，在`providers/`中添加对应Provider

### 添加新服务
1. 在`services/`目录下创建服务类
2. 实现单例模式（如需要）
3. 在相应的Provider中集成服务

### 添加新组件
1. 在`widgets/`目录下创建组件文件
2. 确保组件的可复用性和配置灵活性
3. 添加详细的文档注释

---

本文档随项目发展持续更新，确保与实际代码结构保持同步。