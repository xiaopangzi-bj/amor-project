@echo off
echo ====================================
echo        Flutter APK 真机调试工具
echo ====================================
echo.

:menu
echo 请选择调试方式：
echo 1. 查看应用日志 (logcat)
echo 2. 安装并启动Debug APK
echo 3. 安装并启动Release APK
echo 4. 清除应用数据
echo 5. 退出
echo.
set /p choice=请输入选项 (1-5): 

if "%choice%"=="1" goto logcat
if "%choice%"=="2" goto debug_apk
if "%choice%"=="3" goto release_apk
if "%choice%"=="4" goto clear_data
if "%choice%"=="5" goto exit
echo 无效选项，请重新选择
goto menu

:logcat
echo.
echo 开始监控应用日志...
echo 按 Ctrl+C 停止监控
echo.
adb logcat -s flutter:V -s System.out:V -s AndroidRuntime:E
goto menu

:debug_apk
echo.
echo 构建并安装Debug APK...
flutter build apk --debug
if exist "build\app\outputs\flutter-apk\app-debug.apk" (
    adb install -r build\app\outputs\flutter-apk\app-debug.apk
    echo 启动应用...
    adb shell am start -n com.example.amor/.MainActivity
    echo Debug APK 已安装并启动
) else (
    echo Debug APK 构建失败
)
goto menu

:release_apk
echo.
echo 安装Release APK...
if exist "build\app\outputs\flutter-apk\app-release.apk" (
    adb install -r build\app\outputs\flutter-apk\app-release.apk
    echo 启动应用...
    adb shell am start -n com.example.amor/.MainActivity
    echo Release APK 已安装并启动
) else (
    echo Release APK 不存在，请先构建
)
goto menu

:clear_data
echo.
echo 清除应用数据...
adb shell pm clear com.example.amor
echo 应用数据已清除
goto menu

:exit
echo 退出调试工具
pause