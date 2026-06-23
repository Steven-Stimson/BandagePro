# <img src="http://rrwick.github.io/Bandage/images/logo.png" alt="Bandage" width="115" height="115" align="middle">BandagePro++

## Intro

**BandagePro++ is the spiritual successor to the original [Bandage](https://github.com/rrwick/Bandage)**. It carries forward Bandage's core philosophy of interactive assembly graph visualization while introducing substantial enhancements to graph editing and usability.

## What's New
### v0.1
BandagePro++ significantly extends the original Bandage experience with a focus on interactive graph manipulation:

- **Full Undo/Redo Stack**: Multi-level undo/redo for all graph operations
  - **Keyboard Shortcuts**: 
    - `Ctrl+Z` - Undo
    - `Ctrl+Shift+Z` - Redo

## Prerequisites (for building from the source code)
  * Qt 6
  * CMake
  * C++17-compliant compiler

## Pre-built binaries

Pre-built Linux and Mac binaries are available from [Releases](https://github.com/Steven-Stimson/BandagePro/releases) page.

## Building from source

### CMake
```shell
git clone https://github.com/Steven-Stimson/BandagePro.git
cd BandagePro
mkdir build
cd build
cmake ..
make
```

## Contributing

New contributors are welcome! If you're interested or have ideas, please use Issues section in the repo.

## License

GNU General Public License, version 3
