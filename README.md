# Bandage Pro

A fork of [Bandage](https://github.com/rrwick/Bandage) with enhanced functionality.

## What's New

This fork adds comprehensive **undo/redo support** for graph manipulation operations:

### ✨ New Features

- **Full Undo/Redo Stack**: Multi-level undo/redo for all graph operations
- **Keyboard Shortcuts**: 
  - `Ctrl+Z` - Undo
  - `Ctrl+Shift+Z` - Redo
- **Menu Integration**: Undo/Redo actions in the Manipulate menu

### 🔄 Supported Operations

- **Delete Nodes**: Restore deleted nodes with complete state (sequence, depth, color, labels, edges)
- **Merge Nodes**: Undo node merging operations
- **Rename Nodes**: Revert node name changes
- **Change Node Depth**: Restore previous depth values

### 🛠️ Technical Implementation

- Built on Qt's `QUndoStack` and `QUndoCommand` framework
- Complete state snapshot for reliable restoration
- Preserves all node properties: sequence data, depth, colors, custom labels
- Maintains graph topology: edges and connections

## Download

Pre-built binaries for Linux, macOS, and Windows are available in [Releases](https://github.com/Steven-Stimson/BandagePro/releases).

## Build from Source

### Requirements

- Qt 5.15+
- C++11 compiler
- OGDF (included)

### Quick Build

#### Linux
```bash
sudo apt-get install qt5-qmake qtbase5-dev libqt5svg5-dev build-essential
qmake Bandage.pro
make -j$(nproc)
```

#### macOS
```bash
brew install qt@5
/usr/local/opt/qt@5/bin/qmake Bandage.pro
make -j$(sysctl -n hw.ncpu)
```

#### Windows
```bash
# Install Qt 5.15+ and add to PATH
qmake Bandage.pro
nmake
```

For detailed build instructions, see [BUILD.md](BUILD.md).

## Usage

The undo/redo functionality works automatically with existing Bandage operations:

1. Load a graph file
2. Perform operations (delete, merge, rename nodes)
3. Use `Ctrl+Z` to undo, `Ctrl+Shift+Z` to redo
4. Or use Manipulate → Undo/Redo menu items

## Original Bandage

This project is based on [Bandage](https://github.com/rrwick/Bandage) by Ryan Wick.

For information about the original Bandage features and usage, please visit the [original repository](https://github.com/rrwick/Bandage).

## License

GNU General Public License v3.0

This program is distributed under the same license as the original Bandage.

## Contributors

- Steven Stimson - Undo/Redo implementation

Based on the original work by Ryan Wick and contributors at [rrwick/Bandage](https://github.com/rrwick/Bandage).
