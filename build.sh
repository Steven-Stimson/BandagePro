#!/bin/bash

# Universal build script for Bandage
# Supports Linux, macOS, and Windows (via Git Bash/MSYS2/WSL)

set -e

echo "=== Bandage Build Script ==="
echo ""

# Detect operating system
OS="unknown"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "win32" ]]; then
    OS="windows"
fi

echo "Detected OS: $OS"
echo ""

# Check for qmake
QMAKE=$(which qmake 2>/dev/null || which qmake6 2>/dev/null || echo "")
if [ -z "$QMAKE" ]; then
    echo "Error: qmake not found in PATH"
    echo "Please install Qt development tools:"
    echo "  - Linux: sudo apt-get install qt5-default qtbase5-dev libqt5svg5-dev"
    echo "  - macOS: brew install qt@5"
    echo "  - Windows: Download from https://www.qt.io/download"
    exit 1
fi

echo "Using qmake: $QMAKE"
echo "Qt version: $($QMAKE -v | grep 'Qt version')"
echo ""

# Clean previous build
echo "Cleaning previous build..."
make clean 2>/dev/null || true
rm -f Bandage Bandage.exe
rm -rf build/ release/ debug/

# Build
echo "Running qmake..."
$QMAKE Bandage.pro

echo "Building..."
if [ "$OS" == "windows" ]; then
    nmake || make
else
    make -j$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)
fi

echo ""
echo "=== Build Complete ==="
echo ""

# Package based on OS
case $OS in
    linux)
        if [ -f Bandage ]; then
            echo "Creating Linux package..."
            mkdir -p Bandage-Linux
            cp Bandage Bandage-Linux/
            cp build_scripts/sample_LastGraph Bandage-Linux/ 2>/dev/null || true
            chmod +x Bandage-Linux/Bandage
            tar czf Bandage-Linux.tar.gz Bandage-Linux/
            echo "Package created: Bandage-Linux.tar.gz"
        fi
        ;;
    macos)
        if [ -f Bandage ]; then
            echo "Creating macOS app bundle..."

            mkdir -p Bandage.app/Contents/MacOS
            mkdir -p Bandage.app/Contents/Resources
            cp Bandage Bandage.app/Contents/MacOS/

            if [ -f images/application.icns ]; then
                cp images/application.icns Bandage.app/Contents/Resources/
            fi

            cat > Bandage.app/Contents/Info.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>Bandage</string>
    <key>CFBundleIconFile</key>
    <string>application.icns</string>
    <key>CFBundleIdentifier</key>
    <string>com.bandage.Bandage</string>
    <key>CFBundleName</key>
    <string>Bandage</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>0.9.0</string>
</dict>
</plist>
EOF

            if which macdeployqt >/dev/null 2>&1; then
                echo "Running macdeployqt..."
                macdeployqt Bandage.app -dmg
                echo "Package created: Bandage.dmg"
            else
                echo "macdeployqt not found, app bundle created but not deployed"
                echo "App bundle: Bandage.app"
            fi
        fi
        ;;
    windows)
        if [ -f release/Bandage.exe ]; then
            cp release/Bandage.exe .
        fi

        if [ -f Bandage.exe ]; then
            echo "Creating Windows package..."
            mkdir -p Bandage-Windows
            cp Bandage.exe Bandage-Windows/
            cp build_scripts/sample_LastGraph Bandage-Windows/ 2>/dev/null || true

            if which windeployqt >/dev/null 2>&1; then
                echo "Running windeployqt..."
                windeployqt Bandage-Windows/Bandage.exe
            else
                echo "windeployqt not found, you may need to manually copy Qt DLLs"
            fi

            echo "Package directory: Bandage-Windows/"
        fi
        ;;
esac

echo ""
echo "Build successful!"
