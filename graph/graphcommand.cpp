#include "graphcommand.h"
#include "assemblygraph.h"
#include "../program/globals.h"
#include "../ui/mygraphicsview.h"

GraphStateCommand::GraphStateCommand(AssemblyGraph * graph,
                                     const QByteArray & before, const QByteArray & after,
                                     QUndoCommand * parent)
    : QUndoCommand(parent), m_graph(graph), m_before(before), m_after(after), m_firstRedo(true)
{
    setText("");
}

void GraphStateCommand::redo()
{
    if (m_firstRedo) { m_firstRedo = false; return; }
    restoreState(m_after);
}

void GraphStateCommand::undo()
{
    restoreState(m_before);
}

void GraphStateCommand::restoreState(const QByteArray & gfaData)
{
    // Get the CURRENT scene (not a stored pointer, which may be stale after resetScene())
    QGraphicsScene * scene = g_graphicsView ? g_graphicsView->scene() : nullptr;
    if (scene)
        scene->clear();

    m_graph->loadGraphFromGfaString(gfaData);
}
