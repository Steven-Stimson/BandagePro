@echo off
REM Bandage Windows Build Script
REM 这个脚本会自动编译 Bandage 并打包成可发布版本

echo ========================================
echo   Bandage Windows Build Script
echo ========================================
echo.

REM 检测 Qt 安装路径
set QTDIR=
if exist "C:\Qt\5.15.2\msvc2019_64\bin\qmake.exe" set QTDIR=C:\Qt\5.15.2\msvc2019_64
if exist "C:\Qt\5.15.2\mingw81_64\bin\qmake.exe" set QTDIR=C:\Qt\5.15.2\mingw81_64
if exist "C:\Qt\6.5.0\msvc2019_64\bin\qmake.exe" set QTDIR=C:\Qt\6.5.0\msvc2019_64
if exist "C:\Qt\6.5.0\mingw_64\bin\qmake.exe" set QTDIR=C:\Qt\6.5.0\mingw_64

if "%QTDIR%"=="" (
    echo [错误] 找不到 Qt 安装
    echo 请修改此脚本中的 QTDIR 变量，指向你的 Qt 安装路径
    echo 例如: set QTDIR=C:\Qt\5.15.2\msvc2019_64
    echo.
    pause
    exit /b 1
)

echo [检测] Qt 路径: %QTDIR%
set PATH=%QTDIR%\bin;%PATH%

REM 检查是否在正确的目录
if not exist "Bandage.pro" (
    echo [错误] 找不到 Bandage.pro 文件
    echo 请确保在 Bandage 源码目录中运行此脚本
    pause
    exit /b 1
)

echo [清理] 清理之前的编译文件...
if exist Makefile nmake clean >nul 2>&1
if exist Makefile.Debug del Makefile.Debug >nul 2>&1
if exist Makefile.Release del Makefile.Release >nul 2>&1
if exist release rmdir /s /q release >nul 2>&1
if exist debug rmdir /s /q debug >nul 2>&1
if exist Bandage-Release rmdir /s /q Bandage-Release >nul 2>&1

echo.
echo [步骤 1/4] 运行 qmake...
qmake Bandage.pro -spec win32-msvc "CONFIG+=release"
if errorlevel 1 (
    echo [错误] qmake 失败
    echo 如果使用 MinGW，请尝试: qmake Bandage.pro -spec win32-g++
    pause
    exit /b 1
)

echo [步骤 2/4] 编译 Bandage...
echo 这可能需要几分钟...
nmake >nul 2>&1
if errorlevel 1 (
    echo nmake 失败，尝试使用 mingw32-make...
    mingw32-make
    if errorlevel 1 (
        echo [错误] 编译失败
        pause
        exit /b 1
    )
)

echo [步骤 3/4] 查找生成的 exe...
if exist "release\Bandage.exe" (
    set EXEPATH=release\Bandage.exe
) else if exist "Bandage.exe" (
    set EXEPATH=Bandage.exe
) else (
    echo [错误] 找不到编译生成的 Bandage.exe
    dir /s /b Bandage.exe
    pause
    exit /b 1
)

echo [成功] 找到: %EXEPATH%

echo [步骤 4/4] 打包发布版本...
mkdir Bandage-Release >nul 2>&1
copy "%EXEPATH%" Bandage-Release\ >nul
if exist "build_scripts\sample_LastGraph" copy "build_scripts\sample_LastGraph" Bandage-Release\ >nul

cd Bandage-Release

echo [打包] 复制 Qt 依赖文件...
windeployqt Bandage.exe --release --no-translations
if errorlevel 1 (
    echo [警告] windeployqt 执行失败，你可能需要手动复制 Qt DLL 文件
)

cd ..

echo.
echo ========================================
echo   编译完成！
echo ========================================
echo.
echo 可执行文件位置: Bandage-Release\Bandage.exe
echo.
echo 你现在可以：
echo 1. 测试运行: cd Bandage-Release ^&^& Bandage.exe
echo 2. 打包分发: 将 Bandage-Release 文件夹压缩成 zip
echo.

REM 询问是否立即运行
set /p RUN="是否立即运行 Bandage? (Y/N): "
if /i "%RUN%"=="Y" (
    start Bandage-Release\Bandage.exe
)

pause
