# <img src="http://rrwick.github.io/Bandage/images/logo.png" alt="Bandage" width="115" height="115" align="middle">BandagePro++

## IMPORTANT

**BandagePro++ is the spiritual successor to the original [Bandage](https://github.com/rrwick/Bandage).** It carries forward Bandage's core philosophy of interactive assembly graph visualization while introducing substantial enhancements to graph editing and usability.

## What's New

BandagePro++ significantly extends the original Bandage experience with a focus on interactive graph manipulation:

* **Undo / Redo support** — Experiment freely with graph edits; any change can be reverted and re-applied.
* **Enhanced graph editing** — Improved tools for manipulating and refining assembly graphs directly within the visualizer.

## Intro

BandagePro++ is a GUI program that allows users to interact with the assembly graphs made by *de novo* assemblers.

*De novo* assembly graphs contain not only assembled contigs but also the connections between those contigs, which were previously not easily accessible. Bandage visualises assembly graphs, with connections, using graph layout algorithms. Nodes in the drawn graph, which represent contigs, can be automatically labelled with their ID, length or depth. Users can interact with the graph by moving, labelling and colouring nodes, and BandagePro++ extends these interactions with undo/redo support and richer graph editing capabilities. Sequence information can also be extracted directly from the graph viewer. By displaying connections between contigs, Bandage opens up new possibilities for analysing and improving *de novo* assemblies that are not possible by looking at contigs alone.


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

## License

GNU General Public License, version 3
