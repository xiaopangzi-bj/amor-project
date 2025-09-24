#!/bin/bash

# Flutter启动脚本
# 设置Flutter路径并启动项目

# 设置Flutter路径
export PATH="$PATH:$HOME/development/flutter/bin"

# 检查Flutter是否可用
if ! command -v flutter &> /dev/null; then
    echo "错误: Flutter未找到。请确保Flutter已正确安装。"
    exit 1
fi

# 显示Flutter版本
echo "Flutter版本:"
flutter --version

# 获取依赖包
echo "正在获取依赖包..."
flutter pub get

# 启动项目
echo "启动Flutter项目..."
flutter run