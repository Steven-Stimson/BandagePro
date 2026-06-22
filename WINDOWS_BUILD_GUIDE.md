# Windows 编译指南

## 前提条件

1. **安装 Qt**
   - 下载 Qt 安装程序: https://www.qt.io/download-qt-installer
   - 选择 Qt 5.15.2 或更高版本
   - 组件选择：
     - MSVC 2019 64-bit (或 MinGW 64-bit)
     - Qt SVG

2. **安装编译器**
   
   选项 A: Visual Studio (推荐)
   - 下载 Visual Studio 2019/2022 Community Edition
   - 安装时选择 "Desktop development with C++"
   
   选项 B: MinGW
   - Qt 安装程序中自带 MinGW，选择安装即可

## 编译步骤

### 使用 Qt Creator (最简单)

1. 打开 Qt Creator
2. 文件 → 打开文件或项目
3. 选择 `Bandage.pro`
4. 选择编译套件 (MSVC 或 MinGW)
5. 点击左下角的锤子图标 🔨 编译
6. 点击绿色运行按钮 ▶️ 运行

编译后的 exe 在 `build-Bandage-*-Release/release/Bandage.exe`

### 使用命令行 (MSVC)

1. 打开 "Developer Command Prompt for VS 2019" (开始菜单搜索)

2. 进入 Bandage 目录：
```cmd
cd /d D:\WorkDirWSL\BandagePro\Bandage
```

3. 运行 qmake：
```cmd
"C:\Qt\5.15.2\msvc2019_64\bin\qmake.exe" Bandage.pro
```

4. 编译：
```cmd
nmake
```

5. 找到生成的 exe：
```cmd
dir /s Bandage.exe
```

### 使用命令行 (MinGW)

1. 打开命令提示符 (cmd)

2. 添加 Qt 到 PATH：
```cmd
set PATH=C:\Qt\5.15.2\mingw81_64\bin;C:\Qt\Tools\mingw810_64\bin;%PATH%
```

3. 进入 Bandage 目录：
```cmd
cd /d D:\WorkDirWSL\BandagePro\Bandage
```

4. 运行 qmake：
```cmd
qmake Bandage.pro
```

5. 编译：
```cmd
mingw32-make
```

## 打包发布版本

编译成功后，需要将 Qt 的 DLL 文件打包到一起：

1. 创建发布目录：
```cmd
mkdir Bandage-Release
copy release\Bandage.exe Bandage-Release\
```

2. 运行 windeployqt 自动复制依赖：
```cmd
cd Bandage-Release
windeployqt Bandage.exe
```

这会自动复制所有需要的 Qt DLL、插件等文件。

3. 测试：
```cmd
Bandage.exe
```

4. 打包成 zip：
- 右键 Bandage-Release 文件夹
- 发送到 → 压缩(zipped)文件夹

## 常见问题

### 问题 1: qmake 找不到
**解决**: 确保 Qt 的 bin 目录在 PATH 中，或使用完整路径

### 问题 2: 编译错误 "cannot open file 'QtCore5.lib'"
**解决**: 
- 确保安装了对应的 Qt 组件
- 检查是否使用了正确的编译器 (MSVC vs MinGW)

### 问题 3: 运行时缺少 DLL
**解决**: 运行 windeployqt 或手动复制这些 DLL：
- Qt5Core.dll
- Qt5Gui.dll
- Qt5Widgets.dll
- Qt5Svg.dll

### 问题 4: 找不到 MSVC 编译器
**解决**: 
- 确保从 "Developer Command Prompt for VS" 运行
- 或运行: `"C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars64.bat"`

## 快速脚本

将以下内容保存为 `build_windows.bat`：

```batch
@echo off
echo === Bandage Windows Build Script ===
echo.

REM 设置 Qt 路径 (根据你的安装路径修改)
set QTDIR=C:\Qt\5.15.2\msvc2019_64
set PATH=%QTDIR%\bin;%PATH%

REM 清理
if exist Makefile nmake clean
if exist release rmdir /s /q release
if exist debug rmdir /s /q debug

REM 编译
echo Running qmake...
qmake Bandage.pro
if errorlevel 1 goto error

echo Building...
nmake
if errorlevel 1 goto error

REM 打包
echo Creating release package...
if not exist Bandage-Release mkdir Bandage-Release
copy release\Bandage.exe Bandage-Release\
cd Bandage-Release
windeployqt Bandage.exe
cd ..

echo.
echo === Build Complete ===
echo Executable: Bandage-Release\Bandage.exe
echo.
pause
exit /b 0

:error
echo.
echo === Build Failed ===
pause
exit /b 1
```

然后双击运行 `build_windows.bat` 即可自动编译。

## 在 WSL 中准备文件

如果你在 WSL 中工作，可以直接访问 Windows 文件：
```bash
cd /mnt/d/WorkDirWSL/BandagePro/Bandage
# 文件会自动同步到 D:\WorkDirWSL\BandagePro\Bandage
```

然后在 Windows 中按照上述步骤编译。
