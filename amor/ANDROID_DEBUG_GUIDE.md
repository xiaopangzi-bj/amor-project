# Android 真机调试指南

## 快速开始

### 方法1：使用调试脚本（推荐）
```bash
# 运行调试脚本
debug_apk.bat
```

### 方法2：手动命令

## 1. Debug版本APK（推荐用于调试）

```bash
# 构建debug版本
flutter build apk --debug

# 安装到设备
adb install -r build/app/outputs/flutter-apk/app-debug.apk

# 启动应用
adb shell am start -n com.example.amor/.MainActivity

# 查看实时日志
adb logcat -s flutter:V -s System.out:V -s AndroidRuntime:E
```

**Debug版本优势：**
- 保留所有 `print()` 和 `debugPrint()` 输出
- 支持热重载
- 包含完整调试信息
- 文件大小较大但调试友好

## 2. Profile版本APK

```bash
# 构建profile版本
flutter build apk --profile

# 安装和启动
adb install -r build/app/outputs/flutter-apk/app-profile.apk
adb shell am start -n com.example.amor/.MainActivity
```

**Profile版本特点：**
- 性能接近release版本
- 保留部分调试信息
- 适合性能测试

## 3. Release版本调试

即使是release版本，也可以通过以下方式获取日志：

```bash
# 查看应用崩溃日志
adb logcat -s AndroidRuntime:E

# 查看系统日志
adb logcat -s System.out:V

# 查看特定包名的日志
adb logcat | grep com.example.amor
```

## 4. 常用ADB调试命令

### 设备管理
```bash
# 查看连接的设备
adb devices

# 重启adb服务
adb kill-server
adb start-server
```

### 应用管理
```bash
# 卸载应用
adb uninstall com.example.amor

# 清除应用数据
adb shell pm clear com.example.amor

# 查看应用信息
adb shell dumpsys package com.example.amor
```

### 日志过滤
```bash
# 只看错误日志
adb logcat *:E

# 看Flutter相关日志
adb logcat -s flutter:V

# 保存日志到文件
adb logcat > debug.log
```

## 5. 在代码中添加调试输出

### 使用debugPrint（推荐）
```dart
import 'package:flutter/foundation.dart';

// 只在debug模式下输出
debugPrint('Google登录开始');

// 条件输出
if (kDebugMode) {
  print('详细调试信息: $details');
}
```

### 使用Logger包
在 `pubspec.yaml` 中添加：
```yaml
dependencies:
  logger: ^2.0.1
```

使用示例：
```dart
import 'package:logger/logger.dart';

final logger = Logger();

logger.d('Debug信息');
logger.i('普通信息');
logger.w('警告信息');
logger.e('错误信息');
```

## 6. 网络调试

### 查看网络请求
```bash
# 监控网络活动
adb shell tcpdump -i any -w /sdcard/capture.pcap

# 使用代理工具
# 设置设备代理到电脑的抓包工具（如Charles、Fiddler）
```

## 7. 性能调试

### 使用Flutter Inspector
```bash
# 启动带有inspector的debug版本
flutter run --debug

# 在浏览器中打开 Flutter Inspector
# 通常在 http://localhost:9100
```

### 内存和CPU监控
```bash
# 查看应用内存使用
adb shell dumpsys meminfo com.example.amor

# 查看CPU使用
adb shell top | grep com.example.amor
```

## 8. 常见问题解决

### 设备未识别
1. 确保开启USB调试
2. 安装设备驱动
3. 尝试不同USB端口/线缆

### 应用安装失败
```bash
# 卸载旧版本
adb uninstall com.example.amor

# 强制安装
adb install -r -d build/app/outputs/flutter-apk/app-debug.apk
```

### 日志输出为空
1. 确保使用debug版本
2. 检查日志过滤条件
3. 确认应用正在运行

## 9. 自动化调试脚本

项目根目录下的 `debug_apk.bat` 提供了一键调试功能：

1. **查看应用日志** - 实时监控应用输出
2. **安装Debug APK** - 自动构建并安装debug版本
3. **安装Release APK** - 安装已构建的release版本
4. **清除应用数据** - 重置应用状态

## 10. 最佳实践

1. **开发阶段**：使用debug版本，保留详细日志
2. **测试阶段**：使用profile版本，测试真实性能
3. **发布前**：使用release版本，确保最终体验
4. **日志管理**：生产环境移除敏感信息的日志输出
5. **错误处理**：添加全局错误捕获和上报机制

---

**提示**：建议在开发过程中主要使用debug版本进行调试，只有在需要测试最终性能时才使用release版本。