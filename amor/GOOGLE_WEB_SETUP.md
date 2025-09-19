# Google Sign In Web平台配置指南

## 问题描述
当前Web应用显示"无法使用 google.com 继续操作"错误，这是因为：
1. 使用的是示例Client ID，不是真实的Google项目配置
2. 缺少Web平台的授权域名设置
3. 需要在Google Console中正确配置Web应用

## 解决步骤

### 1. 创建或配置Google Cloud项目

1. 访问 [Google Cloud Console](https://console.cloud.google.com/)
2. 创建新项目或选择现有项目
3. 启用 Google Sign-In API

### 2. 配置OAuth 2.0客户端ID

1. 在Google Cloud Console中，转到 **APIs & Services** > **Credentials**
2. 点击 **Create Credentials** > **OAuth 2.0 Client IDs**
3. 选择应用类型为 **Web application**
4. 配置以下信息：

#### 授权的JavaScript来源
```
http://localhost:3000
http://localhost:8080
http://localhost:9000
https://yourdomain.com
```

#### 授权的重定向URI
```
http://localhost:3000
http://localhost:8080/auth/callback
http://localhost:9000
https://yourdomain.com/auth/callback
```

### 3. 获取Web Client ID

配置完成后，你会得到一个Web Client ID，格式类似：
```
1234567890-abcdefghijklmnopqrstuvwxyz.apps.googleusercontent.com
```

### 4. 更新项目配置

#### 更新 web/index.html
将 `YOUR_WEB_CLIENT_ID` 替换为真实的Web Client ID：

```html
<meta name="google-signin-client_id" content="你的真实Web Client ID">
```

#### 更新 google-services.json
确保Android配置文件包含正确的项目信息。

### 5. 本地开发配置

对于本地开发，确保在Google Console中添加了以下授权域名：
- `localhost`
- `127.0.0.1`

### 6. 测试配置

1. 重新启动Flutter Web应用：
```bash
flutter run -d chrome
```

2. 在浏览器中测试Google登录功能

## 常见问题解决

### 错误：redirect_uri_mismatch
- 确保在Google Console中添加了正确的重定向URI
- 检查当前访问的URL是否在授权列表中

### 错误：unauthorized_client
- 确保Client ID正确
- 检查应用类型是否设置为"Web application"

### 错误：access_blocked
- 确保在Google Console中启用了Google Sign-In API
- 检查OAuth同意屏幕配置

## 生产环境部署

部署到生产环境时：
1. 在Google Console中添加生产域名到授权列表
2. 更新Client ID为生产环境专用的ID
3. 确保HTTPS配置正确

## 安全注意事项

1. **不要在代码中硬编码敏感信息**
2. **使用环境变量管理不同环境的配置**
3. **定期轮换API密钥**
4. **限制Client ID的使用域名**

## 环境变量配置（推荐）

创建 `.env` 文件：
```
GOOGLE_WEB_CLIENT_ID=你的Web Client ID
GOOGLE_ANDROID_CLIENT_ID=你的Android Client ID
```

在代码中使用环境变量而不是硬编码。

---

**重要提醒**：当前项目使用的是示例配置，必须替换为真实的Google项目配置才能正常使用Google登录功能。