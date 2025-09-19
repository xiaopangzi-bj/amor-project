@echo off
chcp 65001 >nul
echo ========================================
echo    多平台Google OAuth配置工具
echo ========================================
echo.

:menu
echo 请选择操作：
echo 1. 查看当前配置状态
echo 2. 配置Android客户端ID
echo 3. 配置Web客户端ID  
echo 4. 配置iOS客户端ID
echo 5. 生成SHA-1指纹
echo 6. 验证配置
echo 7. 打开配置指南
echo 8. 退出
echo.
set /p choice=请输入选项 (1-8): 

if "%choice%"=="1" goto check_config
if "%choice%"=="2" goto config_android
if "%choice%"=="3" goto config_web
if "%choice%"=="4" goto config_ios
if "%choice%"=="5" goto generate_sha1
if "%choice%"=="6" goto verify_config
if "%choice%"=="7" goto open_guide
if "%choice%"=="8" goto exit
goto menu

:check_config
echo.
echo ========================================
echo           当前配置状态
echo ========================================
echo.
echo 📱 Android配置:
if exist "android\app\google-services.json" (
    echo    ✅ google-services.json 存在
    findstr "client_id" android\app\google-services.json | head -1
) else (
    echo    ❌ google-services.json 不存在
)
echo.
echo 🌐 Web配置:
if exist "web\index.html" (
    echo    ✅ index.html 存在
    findstr "google-signin-client_id" web\index.html
) else (
    echo    ❌ index.html 不存在
)
echo.
echo 🍎 iOS配置:
if exist "ios\Runner\GoogleService-Info.plist" (
    echo    ✅ GoogleService-Info.plist 存在
    findstr "CLIENT_ID" ios\Runner\GoogleService-Info.plist | head -1
) else (
    echo    ❌ GoogleService-Info.plist 不存在
)
echo.
pause
goto menu

:config_android
echo.
echo ========================================
echo         配置Android客户端ID
echo ========================================
echo.
echo 步骤：
echo 1. 访问 Google Cloud Console
echo 2. 创建 Android OAuth 2.0 客户端ID
echo 3. 下载 google-services.json
echo 4. 替换 android/app/google-services.json
echo.
echo 当前配置文件位置: android\app\google-services.json
if exist "android\app\google-services.json" (
    echo 文件已存在，请手动替换为新的配置文件
) else (
    echo 文件不存在，请下载并放置到指定位置
)
echo.
pause
goto menu

:config_web
echo.
echo ========================================
echo          配置Web客户端ID
echo ========================================
echo.
set /p web_client_id=请输入Web客户端ID: 
if "%web_client_id%"=="" (
    echo 客户端ID不能为空
    pause
    goto menu
)

echo 正在更新 web/index.html...
powershell -Command "(Get-Content 'web\index.html') -replace 'content=\"[^\"]*\.apps\.googleusercontent\.com\"', 'content=\"%web_client_id%\"' | Set-Content 'web\index.html'"
echo ✅ Web客户端ID已更新
echo.
pause
goto menu

:config_ios
echo.
echo ========================================
echo         配置iOS客户端ID
echo ========================================
echo.
echo 步骤：
echo 1. 访问 Google Cloud Console
echo 2. 创建 iOS OAuth 2.0 客户端ID
echo 3. 下载 GoogleService-Info.plist
echo 4. 替换 ios/Runner/GoogleService-Info.plist
echo.
echo 当前配置文件位置: ios\Runner\GoogleService-Info.plist
if exist "ios\Runner\GoogleService-Info.plist" (
    echo 文件已存在，请手动替换为新的配置文件
) else (
    echo 文件不存在，请下载并放置到指定位置
)
echo.
pause
goto menu

:generate_sha1
echo.
echo ========================================
echo          生成SHA-1指纹
echo ========================================
echo.
echo 正在生成Debug版本SHA-1指纹...
echo.
keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android 2>nul | findstr "SHA1"
if errorlevel 1 (
    echo ❌ 无法找到debug.keystore文件
    echo 请确保已安装Android SDK并运行过项目
) else (
    echo ✅ Debug SHA-1指纹已生成
    echo 请复制上面的SHA1值到Google Console
)
echo.
pause
goto menu

:verify_config
echo.
echo ========================================
echo           验证配置
echo ========================================
echo.
echo 正在验证配置...
echo.

set config_ok=1

echo 检查Android配置...
if not exist "android\app\google-services.json" (
    echo ❌ Android: google-services.json 缺失
    set config_ok=0
) else (
    findstr "123456789012" android\app\google-services.json >nul
    if not errorlevel 1 (
        echo ⚠️  Android: 使用示例客户端ID
        set config_ok=0
    ) else (
        echo ✅ Android: 配置正常
    )
)

echo 检查Web配置...
if not exist "web\index.html" (
    echo ❌ Web: index.html 缺失
    set config_ok=0
) else (
    findstr "YOUR_WEB_CLIENT_ID" web\index.html >nul
    if not errorlevel 1 (
        echo ⚠️  Web: 需要配置真实客户端ID
        set config_ok=0
    ) else (
        echo ✅ Web: 配置正常
    )
)

echo 检查iOS配置...
if not exist "ios\Runner\GoogleService-Info.plist" (
    echo ❌ iOS: GoogleService-Info.plist 缺失
    set config_ok=0
) else (
    findstr "123456789012" ios\Runner\GoogleService-Info.plist >nul
    if not errorlevel 1 (
        echo ⚠️  iOS: 使用示例客户端ID
        set config_ok=0
    ) else (
        echo ✅ iOS: 配置正常
    )
)

echo.
if "%config_ok%"=="1" (
    echo 🎉 所有平台配置验证通过！
) else (
    echo ⚠️  发现配置问题，请参考指南进行修复
)
echo.
pause
goto menu

:open_guide
echo.
echo 正在打开配置指南...
start MULTI_PLATFORM_OAUTH_SETUP.md
goto menu

:exit
echo.
echo 感谢使用多平台OAuth配置工具！
echo.
pause
exit

:error
echo 发生错误，请重试
pause
goto menu