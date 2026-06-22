# Bandage Pro - Enhanced Version

This is an enhanced version of [Bandage](https://github.com/rrwick/Bandage) with additional features.

## New Features

### 1. Undo/Redo Functionality ✨
Full undo/redo support for all graph editing operations:
- **Delete nodes** - Undo node deletions with full state restoration
- **Merge nodes** - Revert node merges
- **Change node properties** - Undo name and depth changes
- **Keyboard shortcuts**: 
  - Undo: `Ctrl+Z` (or `Cmd+Z` on Mac)
  - Redo: `Ctrl+Shift+Z` or `Ctrl+Y` (or `Cmd+Shift+Z` on Mac)

See [UNDO_REDO_IMPLEMENTATION.md](UNDO_REDO_IMPLEMENTATION.md) for technical details.

### 2. Cross-Platform Build System 🛠️
Automated builds for Linux, macOS, and Windows:
- **GitHub Actions CI/CD** - Automatic builds on every push
- **Universal build script** - Single script works on all platforms
- **Release automation** - Tag a version and get packaged binaries

See [BUILD.md](BUILD.md) for build instructions.

## Quick Start

### Download Pre-built Binaries
Download the latest release for your platform from the [Releases](../../releases) page:
- **Linux**: `Bandage-Linux-x86_64.tar.gz`
- **macOS**: `Bandage-macOS.dmg`
- **Windows**: `Bandage-Windows-x86_64.zip`

### Build from Source

#### Prerequisites
- Qt 5.15 or later
- C++ compiler (GCC, Clang, or MSVC)

#### Build
```bash
./build.sh
```

See [BUILD.md](BUILD.md) for detailed build instructions.

## Usage

### Basic Workflow
1. **Load a graph**: File → Load graph (supports FASTG, GFA, LastGraph, etc.)
2. **Draw the graph**: Click "Draw graph" to visualize
3. **Edit**: Select nodes and use the Actions menu to:
   - Delete nodes
   - Merge nodes
   - Change properties
4. **Undo/Redo**: Use Ctrl+Z to undo any changes

### Graph File Formats
Bandage supports various assembly graph formats:
- **FASTG** - SPAdes and other assemblers
- **GFA** - Graphical Fragment Assembly format
- **LastGraph** - Velvet assembler format
- **Trinity.fasta** - Trinity assembler
- **ASQG** - SGA assembler

### Export Options
- **Images**: Save as PNG, JPG, SVG
- **FASTA**: Export sequences
- **GFA**: Export modified graph

## Features (Original + Enhanced)

### Visualization
- Interactive graph visualization
- Zoom and pan
- Node coloring schemes (depth, BLAST hits, custom)
- Adjustable node width and layout

### Graph Editing ⭐ NEW
- Delete nodes (with undo)
- Merge nodes (with undo)
- Duplicate nodes
- Hide/show nodes
- Change node names and depths (with undo)

### Analysis
- BLAST search integration
- Path finding
- Contiguity analysis
- Graph statistics

### Undo/Redo System ⭐ NEW
- Complete history tracking
- Restore deleted nodes with full state
- Undo any graph modification
- Standard keyboard shortcuts

## Documentation

- [BUILD.md](BUILD.md) - Comprehensive build instructions
- [UNDO_REDO_IMPLEMENTATION.md](UNDO_REDO_IMPLEMENTATION.md) - Technical details of undo/redo system
- [Original README](README.md) - Original Bandage documentation

## Development

### Project Structure
```
Bandage/
├── graph/           # Graph data structures
│   ├── graphcommand.h/cpp  # Undo/redo commands ⭐ NEW
│   └── assemblygraph.h/cpp # Main graph class
├── ui/              # User interface
│   └── mainwindow.h/cpp    # Main window with undo stack ⭐ NEW
├── blast/           # BLAST integration
├── program/         # Application logic
├── ogdf/            # OGDF graph library
└── build_scripts/   # Build utilities
```

### Contributing
Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on your platform
5. Submit a pull request

### Testing
After building, test with the sample graph:
```bash
./Bandage build_scripts/sample_LastGraph
```

## Requirements

### Runtime
- Qt 5.12 or later (included in Windows/macOS packages)
- OpenGL support (for visualization)

### Build
- Qt 5.15 or later with development headers
- C++11 compatible compiler
- CMake or qmake

## License

This project maintains the original GPLv3 license from Bandage.

```
Bandage is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
```

See [COPYING](COPYING) for full license text.

## Credits

### Original Bandage
- **Author**: Ryan Wick
- **Repository**: https://github.com/rrwick/Bandage
- **Paper**: Wick RR, Schultz MB, Zobel J, Holt KE (2015) Bandage: interactive visualization of de novo genome assemblies. Bioinformatics 31(20):3350-3352

### Enhancements
- **Undo/Redo System**: Added comprehensive command pattern implementation
- **Build System**: Automated cross-platform builds with GitHub Actions

## Support

For issues, questions, or contributions:
- Open an issue on GitHub
- Check the original Bandage documentation
- See [BUILD.md](BUILD.md) for build troubleshooting

## Changelog

### Version 0.9.0+ (Enhanced)
- ✨ Added full undo/redo functionality for graph operations
- 🛠️ Implemented cross-platform build system
- 🚀 GitHub Actions CI/CD for automated builds
- 📝 Comprehensive build and feature documentation

### Version 0.9.0 (Original)
- See original Bandage repository for full history
