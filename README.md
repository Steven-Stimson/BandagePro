# Bandage Pro

**Bandage Pro is the spiritual successor to the original [Bandage](https://github.com/rrwick/Bandage) by Ryan Wick.** It carries forward Bandage's core philosophy of interactive assembly graph visualization while introducing substantial enhancements to graph editing and usability.

A fork of [Bandage](https://github.com/rrwick/Bandage) with enhanced functionality.

## What's New

Bandage Pro significantly extends the original Bandage experience with a focus on interactive graph manipulation and editing:

### ✨ Enhanced Graph Editing

This fork adds comprehensive **undo/redo support** and richer graph manipulation capabilities for assembly graph editing:

- **Full Undo/Redo Stack**: Multi-level undo/redo for all graph operations
- **Keyboard Shortcuts**: 
  - `Ctrl+Z` - Undo
  - `Ctrl+Shift+Z` - Redo
- **Menu Integration**: Undo/Redo actions in the Manipulate menu
- **Improved Graph Manipulation**: Enhanced tools for manipulating and refining assembly graphs directly within the visualizer

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
qmake BandagePro.pro
make -j$(nproc)
```

#### macOS
```bash
brew install qt@5
/usr/local/opt/qt@5/bin/qmake BandagePro.pro
make -j$(sysctl -n hw.ncpu)
```

#### Windows
```bash
# Install Qt 5.15+ and add to PATH
qmake BandagePro.pro
nmake
```

For detailed build instructions, see [BUILD.md](BUILD.md).

## Usage

The undo/redo functionality works automatically with existing BandagePro operations:

1. Load a graph file
2. Perform operations (delete, merge, rename nodes)
3. Use `Ctrl+Z` to undo, `Ctrl+Shift+Z` to redo
4. Or use Manipulate → Undo/Redo menu items

## Original Bandage

This project is based on [Bandage](https://github.com/rrwick/Bandage) by Ryan Wick. As a spiritual successor, Bandage Pro aims to preserve the original vision of intuitive assembly graph visualization while extending it with modern graph editing capabilities.

For information about the original Bandage features and usage, please visit the [original repository](https://github.com/rrwick/Bandage).

## License

GNU General Public License v3.0

This program is distributed under the same license as the original Bandage.

## Contributors

- Steven Stimson - Undo/Redo implementation

Based on the original work by Ryan Wick and contributors at [rrwick/Bandage](https://github.com/rrwick/Bandage).
