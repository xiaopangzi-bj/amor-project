# Google登录配置指南

## 概述
本项目已集成Google单点登录功能。要使用此功能，您需要配置Firebase项目和Google登录。

## 配置步骤

### 1. 创建Firebase项目
1. 访问 [Firebase控制台](https://console.firebase.google.com/)
2. 点击"创建项目"
3. 输入项目名称（例如：amor-app）
4. 启用Google Analytics（可选）
5. 创建项目

### 2. 添加Android应用
1. 在Firebase控制台中，点击"添加应用" > "Android"
2. 输入Android包名：`com.example.amor`
3. 输入应用昵称：`Amor`
4. 下载 `google-services.json` 文件
5. 将文件放置在 `android/app/` 目录下，替换现有的示例文件

### 3. 添加iOS应用
1. 在Firebase控制台中，点击"添加应用" > "iOS"
2. 输入iOS包名：`com.example.amor`
3. 输入应用昵称：`Amor`
4. 下载 `GoogleService-Info.plist` 文件
5. 将文件放置在 `ios/Runner/` 目录下，替换现有的示例文件

### 4. 启用Google登录
1. 在Firebase控制台中，进入"Authentication" > "Sign-in method"
2. 启用"Google"登录方式
3. 配置OAuth同意屏幕（如果需要）

### 5. 更新配置文件

#### Android配置
确保 `android/app/build.gradle.kts` 包含：
```kotlin
plugins {
    id("com.google.gms.google-services")
}
```

确保 `android/build.gradle.kts` 包含：
```kotlin
buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.4.0")
    }
}
```

#### iOS配置
确保 `ios/Runner/Info.plist` 包含正确的URL scheme：
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>REVERSED_CLIENT_ID</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>YOUR_REVERSED_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

### 6. 安装依赖
运行以下命令安装Flutter依赖：
```bash
flutter pub get
```

### 7. 测试登录功能
1. 运行应用：`flutter run`
2. 点击"使用 Google 账户登录"按钮
3. 选择Google账户完成登录

## 注意事项

1. **包名一致性**：确保Firebase项目中的包名与 `android/app/build.gradle.kts` 和 `ios/Runner/Info.plist` 中的包名一致。

2. **SHA-1指纹**：对于Android，您可能需要添加应用的SHA-1指纹到Firebase项目中。

3. **测试环境**：在开发阶段，可以使用调试密钥的SHA-1指纹。生产环境需要使用发布密钥的SHA-1指纹。

4. **隐私政策**：如果应用需要发布到应用商店，确保添加隐私政策链接。

## 故障排除

### 常见问题
1. **登录失败**：检查Firebase配置文件和包名是否正确
2. **网络错误**：确保设备有网络连接
3. **权限问题**：检查应用权限设置

### 调试步骤
1. 检查控制台日志
2. 验证Firebase项目配置
3. 确认依赖版本兼容性

## 安全建议

1. 不要在代码中硬编码API密钥
2. 使用环境变量管理敏感信息
3. 定期更新依赖包
4. 启用Firebase安全规则

## 支持
如果遇到问题，请检查：
- [Flutter Google Sign In文档](https://pub.dev/packages/google_sign_in)
- [Firebase文档](https://firebase.google.com/docs)
- [Google Sign-In文档](https://developers.google.com/identity/sign-in)
