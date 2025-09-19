# 多平台Google OAuth客户端ID配置指南

## 📋 概述

为了在Android、Web和iOS平台上正确使用Google登录，需要为每个平台创建对应的OAuth客户端ID。

## 🔧 Google Console配置步骤

### 1. 访问Google Cloud Console
1. 打开 [Google Cloud Console](https://console.cloud.google.com/)
2. 选择或创建项目 `amor-app-example`
3. 启用 **Google Sign-In API**

### 2. 创建OAuth 2.0客户端ID

#### 🤖 Android平台
1. 点击 **创建凭据** > **OAuth 2.0客户端ID**
2. 选择应用类型：**Android**
3. 填写信息：
   - **名称**：`Amor Android App`
   - **软件包名称**：`com.example.amor`
   - **SHA-1证书指纹**：运行以下命令获取
   ```bash
   # Debug版本
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   
   # Release版本（如果有）
   keytool -list -v -keystore your-release-key.keystore -alias your-key-alias
   ```

#### 🌐 Web平台
1. 点击 **创建凭据** > **OAuth 2.0客户端ID**
2. 选择应用类型：**Web应用**
3. 填写信息：
   - **名称**：`Amor Web App`
   - **授权的JavaScript来源**：
     ```
     http://localhost:3000
     http://localhost:8080
     http://localhost:9000
     https://yourdomain.com (生产环境)
     ```
   - **授权的重定向URI**：
     ```
     http://localhost:3000/auth/callback
     http://localhost:8080/auth/callback
     https://yourdomain.com/auth/callback
     ```

#### 🍎 iOS平台
1. 点击 **创建凭据** > **OAuth 2.0客户端ID**
2. 选择应用类型：**iOS**
3. 填写信息：
   - **名称**：`Amor iOS App`
   - **Bundle ID**：`com.example.amor`

## 📁 配置文件更新

### Android配置 (google-services.json)
```json
{
  "project_info": {
    "project_number": "YOUR_PROJECT_NUMBER",
    "project_id": "amor-app-example",
    "storage_bucket": "amor-app-example.appspot.com"
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "1:YOUR_PROJECT_NUMBER:android:YOUR_APP_ID",
        "android_client_info": {
          "package_name": "com.example.amor"
        }
      },
      "oauth_client": [
        {
          "client_id": "YOUR_ANDROID_CLIENT_ID.apps.googleusercontent.com",
          "client_type": 1,
          "android_info": {
            "package_name": "com.example.amor",
            "certificate_hash": "YOUR_SHA1_FINGERPRINT"
          }
        },
        {
          "client_id": "YOUR_WEB_CLIENT_ID.apps.googleusercontent.com",
          "client_type": 3
        }
      ]
    }
  ]
}
```

### Web配置 (web/index.html)
```html
<meta name="google-signin-client_id" content="YOUR_WEB_CLIENT_ID.apps.googleusercontent.com">
<script src="https://accounts.google.com/gsi/client" async defer></script>
```

### iOS配置 (ios/Runner/GoogleService-Info.plist)
```xml
<key>CLIENT_ID</key>
<string>YOUR_IOS_CLIENT_ID.apps.googleusercontent.com</string>
<key>REVERSED_CLIENT_ID</key>
<string>com.googleusercontent.apps.YOUR_IOS_CLIENT_ID</string>
```

## 🔄 Flutter代码配置

### 1. 依赖配置 (pubspec.yaml)
```yaml
dependencies:
  google_sign_in: ^6.1.5
  google_sign_in_web: ^0.12.0+2
  google_sign_in_android: ^6.1.18
  google_sign_in_ios: ^5.6.3
```

### 2. 平台特定配置

#### Android (android/app/build.gradle)
```gradle
android {
    defaultConfig {
        // 确保包名匹配
        applicationId "com.example.amor"
    }
}
```

#### iOS (ios/Runner/Info.plist)
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

## 💻 代码实现

### 统一的Google登录服务
```dart
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class GoogleSignInService {
  static GoogleSignIn? _googleSignIn;
  
  static GoogleSignIn get instance {
    if (_googleSignIn == null) {
      if (kIsWeb) {
        // Web平台配置
        _googleSignIn = GoogleSignIn(
          clientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com',
        );
      } else {
        // 移动平台配置（使用配置文件）
        _googleSignIn = GoogleSignIn(
          scopes: ['email', 'profile'],
        );
      }
    }
    return _googleSignIn!;
  }
  
  static Future<GoogleSignInAccount?> signIn() async {
    try {
      return await instance.signIn();
    } catch (error) {
      print('Google Sign In Error: $error');
      return null;
    }
  }
  
  static Future<void> signOut() async {
    await instance.signOut();
  }
}
```

## 🧪 测试配置

### 1. 测试不同平台
```bash
# Android测试
flutter run -d android

# Web测试
flutter run -d chrome

# iOS测试（需要Mac）
flutter run -d ios
```

### 2. 验证客户端ID
- **Android**：检查 `google-services.json` 中的 `client_id`
- **Web**：检查 `web/index.html` 中的 `google-signin-client_id`
- **iOS**：检查 `GoogleService-Info.plist` 中的 `CLIENT_ID`

## ⚠️ 常见问题

### 1. "客户端ID无效"错误
- 确保每个平台使用正确的客户端ID
- 检查包名/Bundle ID是否匹配
- 验证SHA-1指纹是否正确

### 2. Web平台"无法使用google.com继续操作"
- 确保授权域名包含当前域名
- 检查Web客户端ID是否正确配置

### 3. iOS平台无法登录
- 确保URL Schemes配置正确
- 检查Bundle ID是否匹配

## 🚀 部署注意事项

### 生产环境
1. 使用生产环境的客户端ID
2. 更新授权域名为实际域名
3. 使用Release版本的SHA-1指纹

### 安全建议
- 不要在代码中硬编码客户端ID
- 使用环境变量管理不同环境的配置
- 定期轮换客户端密钥

## 📞 支持

如果遇到问题，请检查：
1. Google Cloud Console中的配置
2. 各平台配置文件的客户端ID
3. 网络连接和防火墙设置