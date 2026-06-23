# Cross-Platform Build System

This directory contains scripts and configurations for building BandagePro on Linux, macOS, and Windows.

## Quick Start

### Using the Universal Build Script (Recommended)

```bash
./build.sh
```

This script will:
- Detect your operating system
- Find qmake in your PATH
- Build BandagePro
- Create a platform-specific package

### Prerequisites

#### Linux (Ubuntu/Debian)
```bash
sudo apt-get update
sudo apt-get install qt5-default qtbase5-dev libqt5svg5-dev build-essential
```

#### Linux (Fedora/RHEL/CentOS)
```bash
sudo dnf install qt5-qtbase-devel qt5-qtsvg-devel gcc-c++ make
```

#### macOS
```bash
brew install qt@5
```

Add Qt to your PATH:
```bash
export PATH="/usr/local/opt/qt@5/bin:$PATH"
```

#### Windows
1. Download and install Qt from https://www.qt.io/download
2. Install Qt 5.15.2 with MSVC 2019 64-bit
3. Use Qt Creator or build from command line with Qt's environment

## Manual Build

### Linux & macOS
```bash
qmake BandagePro.pro
make -j$(nproc)  # Linux
make -j$(sysctl -n hw.ncpu)  # macOS
```

### Windows (Visual Studio Command Prompt)
```cmd
qmake BandagePro.pro
nmake
```

## GitHub Actions CI/CD

The repository includes a GitHub Actions workflow (`.github/workflows/build.yml`) that automatically:

1. **Builds on all platforms** (Linux, macOS, Windows) on every push and pull request
2. **Creates artifacts** for each platform
3. **Publishes releases** automatically when you create a version tag

### Triggering a Release Build

Create and push a version tag:
```bash
git tag v0.9.0
git push origin v0.9.0
```

This will:
- Build on all three platforms
- Create downloadable artifacts
- Create a GitHub release with all platform packages attached

### Workflow Features

- **Linux**: Builds on Ubuntu 20.04, creates `.tar.gz` package
- **macOS**: Builds on latest macOS, creates `.dmg` installer
- **Windows**: Builds on latest Windows, creates `.zip` package with all dependencies

All builds use Qt 5.15.2 for consistency and compatibility.

## Build Output

### Linux
- Executable: `BandagePro`
- Package: `BandagePro-Linux.tar.gz` (contains executable and sample data)

### macOS
- App Bundle: `BandagePro.app`
- Package: `BandagePro.dmg` (disk image with app bundle)

### Windows
- Executable: `BandagePro.exe`
- Package: `BandagePro-Windows/` (directory with executable and Qt DLLs)

## Legacy Build Scripts

The `build_scripts/` directory contains the original build scripts:
- `bandagepro_build_linux.sh` - Original Linux static/dynamic build script
- `bandagepro_build_mac.sh` - Original macOS build script
- `bandagepro_build_windows.bat` - Original Windows build script

These are kept for reference but the new `build.sh` script is recommended.

## Troubleshooting

### qmake not found
Make sure Qt is installed and in your PATH:
```bash
# Check qmake location
which qmake

# Add to PATH if needed (adjust path for your system)
export PATH="/path/to/qt/bin:$PATH"
```

### Missing Qt modules
BandagePro requires:
- Qt Core
- Qt GUI
- Qt Widgets
- Qt SVG

Install with your package manager or Qt installer.

### Windows: nmake not found
Run from "Developer Command Prompt for VS" or Qt's pre-configured command prompt.

### macOS: macdeployqt not found
Ensure the Qt bin directory is in your PATH:
```bash
export PATH="/usr/local/opt/qt@5/bin:$PATH"
```

## Development

### Project Structure
- `BandagePro.pro` - Qt project file (main build configuration)
- `graph/` - Graph data structures and algorithms
- `ui/` - User interface components
- `blast/` - BLAST integration
- `program/` - Application logic
- `ogdf/` - OGDF graph library integration

### Adding New Source Files
Edit `BandagePro.pro` and add your files to the appropriate section:
```qmake
SOURCES += \
    your/new/file.cpp

HEADERS += \
    your/new/file.h
```

Then rebuild:
```bash
qmake BandagePro.pro
make
```

## Contributing

When contributing platform-specific changes:
1. Test on your target platform
2. Update the GitHub Actions workflow if needed
3. Update this documentation
4. Ensure the build script handles your changes

## License

BandagePro is licensed under the GNU General Public License v3.0 - see the COPYING file for details.
