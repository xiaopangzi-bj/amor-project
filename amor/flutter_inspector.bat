@echo off
echo ====================================
echo      Flutter Inspector 调试工具
echo ====================================
echo.

:menu
echo 请选择调试方式：
echo 1. 启动Flutter Inspector (连接真机)
echo 2. 启动Flutter Inspector (连接模拟器)
echo 3. 查看可用设备
echo 4. 启动性能分析
echo 5. 退出
echo.
set /p choice=请输入选项 (1-5): 

if "%choice%"=="1" goto inspector_device
if "%choice%"=="2" goto inspector_emulator
if "%choice%"=="3" goto list_devices
if "%choice%"=="4" goto performance
if "%choice%"=="5" goto exit
echo 无效选项，请重新选择
goto menu

:inspector_device
echo.
echo 启动Flutter Inspector连接真机...
echo 请确保：
echo 1. 手机已连接并开启USB调试
echo 2. 应用已安装debug版本
echo.
flutter run --debug
goto menu

:inspector_emulator
echo.
echo 启动Flutter Inspector连接模拟器...
flutter run --debug -d emulator
goto menu

:list_devices
echo.
echo 查看可用设备...
flutter devices
echo.
pause
goto menu

:performance
echo.
echo 启动性能分析...
echo 这将启动应用并开启性能监控
flutter run --debug --enable-software-rendering --trace-startup
goto menu

:exit
echo.
echo Flutter Inspector使用提示：
echo 1. 应用启动后，在浏览器中访问显示的URL
echo 2. 通常是 http://localhost:9100 或类似地址
echo 3. 可以查看Widget树、性能、网络等信息
echo.
echo 退出调试工具
pause