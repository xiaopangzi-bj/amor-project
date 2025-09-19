# 快速设置多平台Google OAuth客户端ID指南

## 🚀 快速开始

### 1. Google Console配置

#### 步骤1: 访问Google Cloud Console
1. 打开 [Google Cloud Console](https://console.cloud.google.com/)
2. 选择或创建项目
3. 启用 Google Sign-In API

#### 步骤2: 创建OAuth 2.0客户端ID

**Android平台:**
```
应用类型: Android
包名: com.example.amor (从android/app/build.gradle获取)
SHA-1指纹: 运行 setup_oauth_config.bat 选项3获取
```

**Web平台:**
```
应用类型: Web应用
授权的JavaScript来源: http://localhost:8080, https://yourdomain.com
授权的重定向URI: http://localhost:8080, https://yourdomain.com
```

**iOS平台:**
```
应用类型: iOS
Bundle ID: com.example.amor (从ios/Runner/Info.plist获取)
```

### 2. 更新配置文件

#### Android (android/app/google-services.json)
```json
{
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "你的移动SDK应用ID",
        "android_client_info": {
          "package_name": "com.example.amor"
        }
      },
      "oauth_client": [
        {
          "client_id": "你的Android客户端ID.apps.googleusercontent.com",
          "client_type": 1,
          "android_info": {
            "package_name": "com.example.amor",
            "certificate_hash": "你的SHA1指纹"
          }
        }
      ]
    }
  ]
}
```

#### Web (web/index.html)
```html
<meta name="google-signin-client_id" content="你的Web客户端ID.apps.googleusercontent.com">
```

#### iOS (ios/Runner/GoogleService-Info.plist)
```xml
<key>CLIENT_ID</key>
<string>你的iOS客户端ID.apps.googleusercontent.com</string>
<key>REVERSED_CLIENT_ID</key>
<string>com.googleusercontent.apps.你的客户端ID</string>
```

### 3. 更新Flutter代码配置

#### 环境变量配置 (.env)
```env
# Google OAuth 客户端ID配置
GOOGLE_ANDROID_CLIENT_ID=你的Android客户端ID.apps.googleusercontent.com
GOOGLE_WEB_CLIENT_ID=你的Web客户端ID.apps.googleusercontent.com
GOOGLE_IOS_CLIENT_ID=你的iOS客户端ID.apps.googleusercontent.com

# 项目配置
PROJECT_ID=你的项目ID
```

### 4. 测试配置

#### 运行测试命令:
```bash
# Android测试
flutter run -d android

# Web测试
flutter run -d chrome

# iOS测试 (需要Mac)
flutter run -d ios
```

### 5. 验证清单

- [ ] Google Console中创建了3个平台的客户端ID
- [ ] 更新了android/app/google-services.json
- [ ] 更新了web/index.html中的客户端ID
- [ ] 更新了ios/Runner/GoogleService-Info.plist
- [ ] 创建了.env文件并配置了客户端ID
- [ ] 测试了各平台的Google登录功能

## 🔧 自动化工具

运行 `setup_oauth_config.bat` 获取交互式配置帮助:
- 查看当前配置状态
- 生成SHA-1指纹
- 验证配置完整性
- 获取详细设置指导

## ⚠️ 常见问题

1. **SHA-1指纹不匹配**: 确保使用正确的keystore生成指纹
2. **Web域名未授权**: 在Google Console中添加所有需要的域名
3. **包名不匹配**: 确保Google Console中的包名与应用一致
4. **客户端ID未生效**: 重启应用并清除缓存

## 📞 获取帮助

如果遇到问题，请检查:
1. MULTI_PLATFORM_OAUTH_SETUP.md - 详细配置指南
2. setup_oauth_config.bat - 自动化配置工具
3. lib/config/oauth_config.dart - 配置管理代码