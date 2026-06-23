[![License](https://img.shields.io/badge/licence-GPLv3-blue)](https://www.gnu.org/licenses/gpl-3.0)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/asl/BandageProPP?include_prereleases)
[![GitHub Downloads](https://img.shields.io/github/downloads/asl/BandageProPP/total.svg?style=social&logo=github&label=Download)](https://github.com/asl/BandageProPP/releases)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/asl/BandageProPP/test.yml?branch=dev)

# <img src="http://rrwick.github.io/Bandage/images/logo.png" alt="Bandage" width="115" height="115" align="middle">BandagePro++

## IMPORTANT

**BandagePro++ is the spiritual successor to the original [Bandage](https://github.com/rrwick/Bandage) by Ryan Wick.** It carries forward Bandage's core philosophy of interactive assembly graph visualization while introducing substantial enhancements to graph editing and usability.

## What's New

BandagePro++ significantly extends the original Bandage experience with a focus on interactive graph manipulation:

* **Undo / Redo support** — Experiment freely with graph edits; any change can be reverted and re-applied.
* **Enhanced graph editing** — Improved tools for manipulating and refining assembly graphs directly within the visualizer.

## Table of Contents
* [Intro](https://github.com/asl/BandageProPP#intro)
* [Help](https://github.com/asl/BandageProPP#help)
* [Pre-built binaries](https://github.com/asl/BandageProPP#pre-built-binaries)
* [Building from source](https://github.com/asl/BandageProPP#building-from-source)
* [Contributing](https://github.com/asl/BandageProPP#contributing)
* [Credits](https://github.com/asl/BandageProPP#credits)
* [License](https://github.com/asl/BandageProPP#license)


## Intro

BandagePro++ is a GUI program that allows users to interact with the assembly graphs made by *de novo* assemblers.

*De novo* assembly graphs contain not only assembled contigs but also the connections between those contigs, which were previously not easily accessible. Bandage visualises assembly graphs, with connections, using graph layout algorithms. Nodes in the drawn graph, which represent contigs, can be automatically labelled with their ID, length or depth. Users can interact with the graph by moving, labelling and colouring nodes, and BandagePro++ extends these interactions with undo/redo support and richer graph editing capabilities. Sequence information can also be extracted directly from the graph viewer. By displaying connections between contigs, Bandage opens up new possibilities for analysing and improving *de novo* assemblies that are not possible by looking at contigs alone.

## Help

BandagePro++ documentation is available on the <a href="https://github.com/asl/BandageProPP/wiki" target="_blank">BandagePro++ GitHub wiki</a>.

BandagePro++ help tips are also built into the program. Throughout the UI, you will find these icons next to controls and settings: <img src="http://rrwick.github.io/Bandage/images/helptext.png" alt="help text icon" width="16" height="16">. Click them to see a description of that element of Bandage.

## Prerequisites (for building from the source code)
  * Qt 6
  * CMake
  * C++17-compliant compiler

## Pre-built binaries

Pre-built Linux and Mac binaries are available from [Releases](https://github.com/asl/BandageProPP/releases) page.

## Building from source

### CMake
```shell
mkdir build
cd build
cmake ..
make
```

## Contributing

New contributors are welcome! If you're interested or have ideas, please use Issues section in the repo.


## Credits

BandagePro++ makes use of the <a href="http://www.ogdf.net/" target="_blank">OGDF</a> library for performing graph layout algorithms. Big thanks goes out to the OGDF developers for their excellent work!

* <a href="https://github.com/rrwick" target="_blank">Ryan Wick</a> (author of original Bandage)
* <a href="https://github.com/rchikhi" target="_blank">Rayan Chikhi</a>
* <a href="https://github.com/epruesse" target="_blank">Elmar Pruesse</a>
* <a href="https://github.com/wafemand" target="_blank">Andrey Zakharov</a>
* <a href="https://github.com/asl" target="_blank">Anton Korobeynikov</a>

## License

GNU General Public License, version 3
