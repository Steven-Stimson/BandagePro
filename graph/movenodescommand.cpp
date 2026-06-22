#include "movenodescommand.h"

#include "assemblygraph.h"
#include "debruijnnode.h"
#include "graphicsitemnode.h"
#include "program/globals.h"

MoveNodesCommand::MoveNodesCommand(std::vector<NodeMove> moves)
    : m_moves(std::move(moves))
{
    setText("Move nodes");
}

void MoveNodesCommand::apply(qreal direction)
{
    std::vector<GraphicsItemNode *> nodes;
    for (auto &m : m_moves) {
        auto it = g_assemblyGraph->m_deBruijnGraphNodes.find(m.nodeName.toStdString());
        if (it == g_assemblyGraph->m_deBruijnGraphNodes.end())
            continue;

        DeBruijnNode *node = it.value();
        GraphicsItemNode *graphicsItemNode = node->getGraphicsItemNode();
        if (!graphicsItemNode)
            continue;

        graphicsItemNode->shiftPoints(m.shift * direction);
        graphicsItemNode->remakePath();
        nodes.push_back(graphicsItemNode);
    }

    if (!nodes.empty())
        nodes.front()->fixEdgePaths(&nodes);
}

void MoveNodesCommand::undo()
{
    apply(-1.0);
}

void MoveNodesCommand::redo()
{
    if (m_firstRedo) {
        m_firstRedo = false;
        return;
    }
    apply(1.0);
}
