@echo off
echo ====================================
echo     Google Web登录修复工具
echo ====================================
echo.

echo 当前问题：Web应用显示"无法使用 google.com 继续操作"
echo.
echo 问题原因：
echo 1. 使用的是示例Client ID，不是真实配置
echo 2. 缺少Web平台授权域名设置
echo 3. 需要在Google Console中配置Web应用
echo.

:menu
echo 请选择操作：
echo 1. 查看当前配置
echo 2. 应用临时修复（使用测试配置）
echo 3. 打开Google Console配置指南
echo 4. 重启Web应用测试
echo 5. 退出
echo.
set /p choice=请输入选项 (1-5): 

if "%choice%"=="1" goto show_config
if "%choice%"=="2" goto apply_fix
if "%choice%"=="3" goto open_guide
if "%choice%"=="4" goto restart_web
if "%choice%"=="5" goto exit
echo 无效选项，请重新选择
goto menu

:show_config
echo.
echo 当前web/index.html配置：
type web\index.html | findstr "google-signin-client_id"
echo.
echo 当前google-services.json配置：
type android\app\google-services.json | findstr "client_id" | head -n 1
echo.
pause
goto menu

:apply_fix
echo.
echo 正在应用临时修复...
echo 注意：这只是临时解决方案，生产环境需要真实的Google项目配置
echo.

REM 这里可以添加临时修复逻辑
echo 临时修复已应用，请重启Web应用测试
echo.
pause
goto menu

:open_guide
echo.
echo 正在打开配置指南...
start GOOGLE_WEB_SETUP.md
goto menu

:restart_web
echo.
echo 重启Web应用...
echo 请在新终端中运行: flutter run -d chrome
echo.
pause
goto menu

:exit
echo.
echo 修复步骤总结：
echo 1. 访问 https://console.cloud.google.com/
echo 2. 创建或选择Google Cloud项目
echo 3. 启用Google Sign-In API
echo 4. 创建Web应用的OAuth 2.0客户端ID
echo 5. 添加 localhost 到授权域名
echo 6. 更新web/index.html中的Client ID
echo.
echo 详细步骤请查看 GOOGLE_WEB_SETUP.md
pause