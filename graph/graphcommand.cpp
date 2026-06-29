#include "graphcommand.h"
#include "viewstate.h"

#include "assemblygraph.h"
#include "io.h"
#include "program/globals.h"
#include "program/settings.h"
#include "../ui/bandagegraphicsview.h"

#include <QTemporaryFile>
#include <QFile>
#include <QGraphicsScene>

GraphStateCommand::GraphStateCommand(const QByteArray &before,
                                     const QByteArray &after,
                                     RestoreCallback callback,
                                     QUndoCommand *parent)
    : QUndoCommand(parent),
      m_before(before),
      m_after(after),
      m_callback(std::move(callback)),
      m_firstRedo(true)
{
    setText("Edit graph");
}

void GraphStateCommand::redo()
{
    if (m_firstRedo) {
        m_firstRedo = false;
        return;
    }
    restoreState(m_after);
}

void GraphStateCommand::undo()
{
    restoreState(m_before);
}

void GraphStateCommand::restoreState(const QByteArray &viewStateData)
{
    if (viewStateData.isEmpty())
        return;

    ViewState viewState = ViewState::deserialize(viewStateData);
    if (viewState.gfaData.isEmpty())
        return;

    // Write the snapshot to a temporary GFA file so the existing graph builder
    // can load it.
    QTemporaryFile tempFile("bandage_undo_XXXXXX.gfa");
    tempFile.setAutoRemove(true);
    if (!tempFile.open())
        return;
    tempFile.write(viewState.gfaData);
    tempFile.close();

    auto builder = io::AssemblyGraphBuilder::get(tempFile.fileName());
    if (!builder)
        return;
    builder->treatJumpsAsLinks(g_settings->jumpsAsLinks);

    auto *newGraph = new AssemblyGraph();
    if (auto err = builder->build(*newGraph)) {
        llvm::consumeError(std::move(err));
        delete newGraph;
        return;
    }

    // Remove the current scene items before deleting the old graph, since the
    // items hold pointers to the old nodes/edges.
    if (g_graphicsView) {
        if (QGraphicsScene *scene = g_graphicsView->scene())
            scene->clear();
    }

    g_assemblyGraph->cleanUp();
    g_assemblyGraph.reset(newGraph);
    g_assemblyGraph->determineGraphInfo();

    if (m_callback)
        m_callback(viewState);
}
