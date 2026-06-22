# Undo/Redo Feature Implementation

## Overview
This implementation adds comprehensive undo/redo functionality to Bandage, allowing users to revert any graph editing operations.

## Implementation Details

### New Files
1. **graph/graphcommand.h** - Header file defining undo command classes
2. **graph/graphcommand.cpp** - Implementation of undo commands

### Command Classes
The implementation uses Qt's QUndoCommand framework with the following command types:

1. **DeleteNodesCommand**
   - Captures node and edge snapshots before deletion
   - Can restore deleted nodes with all their properties (depth, sequence, colors, labels)
   - Handles reverse complement relationships

2. **MergeNodesCommand**
   - Records the state before merging nodes
   - Tracks original nodes and new merged node
   - Can validate if merge is possible

3. **ChangeNodeNameCommand**
   - Records old and new node names
   - Updates the graph's node map on undo/redo

4. **ChangeNodeDepthCommand**
   - Records old and new depth values
   - Restores depth on undo

### Modified Files
1. **Bandage.pro** - Added new source and header files
2. **ui/mainwindow.h** - Added QUndoStack member variable
3. **ui/mainwindow.cpp** - Integrated undo stack into the UI:
   - Creates undo/redo actions with standard keyboard shortcuts (Ctrl+Z, Ctrl+Shift+Z)
   - Modified removeSelection() to use DeleteNodesCommand
   - Modified mergeSelectedNodes() to use MergeNodesCommand
   - Modified changeNodeName() to use ChangeNodeNameCommand
   - Modified changeNodeDepth() to use ChangeNodeDepthCommand

## Usage
Once compiled, users can:
- Use **Edit → Undo** (or Ctrl+Z) to undo the last graph operation
- Use **Edit → Redo** (or Ctrl+Shift+Z / Ctrl+Y) to redo an undone operation
- The undo history is maintained throughout the session

## Supported Operations
- Delete nodes
- Merge nodes
- Change node names
- Change node depths

## Future Enhancements
To fully complete the undo/redo system, the following operations could be added:
- Duplicate nodes
- Hide/show nodes
- Change node colors
- Change node labels
- Edge modifications

## Building
Build Bandage as usual with qmake and make:
```bash
qmake Bandage.pro
make
```

## Testing
After building:
1. Load a graph file
2. Select and delete some nodes
3. Press Ctrl+Z to undo the deletion
4. Press Ctrl+Shift+Z to redo
5. Try merging nodes and undoing the merge
