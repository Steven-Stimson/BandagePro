//Copyright 2017 Ryan Wick
//Modified to add undo/redo functionality

//This file is part of Bandage

//Bandage is free software: you can redistribute it and/or modify
//it under the terms of the GNU General Public License as published by
//the Free Software Foundation, either version 3 of the License, or
//(at your option) any later version.

//Bandage is distributed in the hope that it will be useful,
//but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//GNU General Public License for more details.

//You should have received a copy of the GNU General Public License
//along with Bandage.  If not, see <http://www.gnu.org/licenses/>.


#include "graphcommand.h"
#include "assemblygraph.h"
#include "debruijnnode.h"
#include "debruijnedge.h"
#include "../ui/mygraphicsscene.h"
#include <QPair>

DeleteNodesCommand::DeleteNodesCommand(AssemblyGraph * graph,
                                     const std::vector<DeBruijnNode *> & nodes,
                                     MyGraphicsScene * scene,
                                     QUndoCommand * parent)
    : QUndoCommand(parent), m_graph(graph), m_scene(scene), m_firstRedo(true)
{
    setText("Delete nodes");

    QList<DeBruijnNode *> nodesToDelete;
    for (size_t i = 0; i < nodes.size(); ++i)
    {
        DeBruijnNode * node = nodes[i];
        DeBruijnNode * rcNode = node->getReverseComplement();

        if (!nodesToDelete.contains(node))
            nodesToDelete.push_back(node);
        if (!nodesToDelete.contains(rcNode))
            nodesToDelete.push_back(rcNode);
    }

    for (int i = 0; i < nodesToDelete.size(); ++i)
    {
        DeBruijnNode * node = nodesToDelete[i];
        NodeSnapshot snapshot;
        snapshot.name = node->getName();
        snapshot.depth = node->getDepth();
        snapshot.sequence = node->getSequence();
        snapshot.rcNodeName = node->getReverseComplement()->getName();
        snapshot.isDrawn = node->isDrawn();
        if (node->hasCustomColour())
            snapshot.colour = node->getCustomColour();
        if (!node->getCustomLabel().isEmpty())
            snapshot.customLabel = node->getCustomLabel();

        m_deletedNodes.push_back(snapshot);

        const std::vector<DeBruijnEdge *> * nodeEdges = node->getEdgesPointer();
        for (size_t j = 0; j < nodeEdges->size(); ++j)
        {
            DeBruijnEdge * edge = (*nodeEdges)[j];

            bool alreadyAdded = false;
            for (int k = 0; k < m_deletedEdges.size(); ++k)
            {
                if (m_deletedEdges[k].startNodeName == edge->getStartingNode()->getName() &&
                    m_deletedEdges[k].endNodeName == edge->getEndingNode()->getName())
                {
                    alreadyAdded = true;
                    break;
                }
            }

            if (!alreadyAdded)
            {
                EdgeSnapshot edgeSnapshot;
                edgeSnapshot.startNodeName = edge->getStartingNode()->getName();
                edgeSnapshot.endNodeName = edge->getEndingNode()->getName();
                edgeSnapshot.overlap = edge->getOverlap();
                edgeSnapshot.overlapType = static_cast<int>(edge->getOverlapType());
                edgeSnapshot.isDrawn = edge->isDrawn();
                m_deletedEdges.push_back(edgeSnapshot);
            }
        }
    }
}

void DeleteNodesCommand::redo()
{
    if (m_firstRedo)
    {
        m_firstRedo = false;
        return;
    }

    std::vector<DeBruijnNode *> nodesToDelete;
    for (int i = 0; i < m_deletedNodes.size(); ++i)
    {
        DeBruijnNode * node = m_graph->m_deBruijnGraphNodes[m_deletedNodes[i].name];
        if (node)
            nodesToDelete.push_back(node);
    }

    // Delete from graph (this handles edges too)
    m_graph->deleteNodes(&nodesToDelete);

    // Refresh the scene
    m_graph->addGraphicsItemsToScene(m_scene);
}

void DeleteNodesCommand::undo()
{
    QMap<QString, DeBruijnNode *> restoredNodes;

    for (int i = 0; i < m_deletedNodes.size(); ++i)
    {
        NodeSnapshot & snapshot = m_deletedNodes[i];
        DeBruijnNode * node = new DeBruijnNode(snapshot.name, snapshot.depth, snapshot.sequence);

        if (snapshot.colour.isValid())
            node->setCustomColour(snapshot.colour);
        if (!snapshot.customLabel.isEmpty())
            node->setCustomLabel(snapshot.customLabel);

        m_graph->m_deBruijnGraphNodes.insert(snapshot.name, node);
        restoredNodes.insert(snapshot.name, node);
    }

    for (int i = 0; i < m_deletedNodes.size(); ++i)
    {
        NodeSnapshot & snapshot = m_deletedNodes[i];
        DeBruijnNode * node = restoredNodes[snapshot.name];
        DeBruijnNode * rcNode = restoredNodes[snapshot.rcNodeName];
        node->setReverseComplement(rcNode);
    }

    for (int i = 0; i < m_deletedEdges.size(); ++i)
    {
        EdgeSnapshot & edgeSnapshot = m_deletedEdges[i];
        m_graph->createDeBruijnEdge(edgeSnapshot.startNodeName,
                                   edgeSnapshot.endNodeName,
                                   edgeSnapshot.overlap,
                                   static_cast<EdgeOverlapType>(edgeSnapshot.overlapType));
    }

    // Restore draw state and refresh scene
    for (int i = 0; i < m_deletedNodes.size(); ++i)
    {
        NodeSnapshot & snapshot = m_deletedNodes[i];
        DeBruijnNode * node = restoredNodes[snapshot.name];
        if (node && snapshot.isDrawn)
            node->setAsDrawn();
    }

    // Refresh the entire scene to show restored nodes
    m_graph->addGraphicsItemsToScene(m_scene);
}

MergeNodesCommand::MergeNodesCommand(AssemblyGraph * graph,
                                   const QList<DeBruijnNode *> & nodes,
                                   MyGraphicsScene * scene,
                                   bool recalculateDepth,
                                   QUndoCommand * parent)
    : QUndoCommand(parent), m_graph(graph), m_scene(scene),
      m_recalculateDepth(recalculateDepth), m_valid(false), m_firstRedo(true)
{
    setText("Merge nodes");

    for (int i = 0; i < nodes.size(); ++i)
    {
        DeBruijnNode * node = nodes[i];
        NodeSnapshot snapshot;
        snapshot.name = node->getName();
        snapshot.depth = node->getDepth();
        snapshot.sequence = node->getSequence();
        snapshot.rcNodeName = node->getReverseComplement()->getName();
        snapshot.isDrawn = node->isDrawn();
        if (node->hasCustomColour())
            snapshot.colour = node->getCustomColour();
        if (!node->getCustomLabel().isEmpty())
            snapshot.customLabel = node->getCustomLabel();

        m_originalNodes.push_back(snapshot);
    }
}

void MergeNodesCommand::redo()
{
    if (m_firstRedo)
    {
        QList<DeBruijnNode *> nodesToMerge;
        for (int i = 0; i < m_originalNodes.size(); ++i)
        {
            DeBruijnNode * node = m_graph->m_deBruijnGraphNodes[m_originalNodes[i].name];
            if (node)
                nodesToMerge.push_back(node);
        }

        m_valid = m_graph->mergeNodes(nodesToMerge, m_scene, m_recalculateDepth);
        m_firstRedo = false;
    }
}

void MergeNodesCommand::undo()
{
}

ChangeNodeNameCommand::ChangeNodeNameCommand(AssemblyGraph * graph,
                                           DeBruijnNode * node,
                                           const QString & newName,
                                           QUndoCommand * parent)
    : QUndoCommand(parent), m_graph(graph), m_nodeName(node->getName()),
      m_oldName(node->getName()), m_newName(newName), m_firstRedo(true)
{
    setText("Change node name");
}

void ChangeNodeNameCommand::redo()
{
    if (m_firstRedo)
    {
        m_firstRedo = false;
        return;
    }

    DeBruijnNode * node = m_graph->m_deBruijnGraphNodes[m_oldName];
    if (node)
    {
        m_graph->m_deBruijnGraphNodes.remove(m_oldName);
        node->setName(m_newName);
        m_graph->m_deBruijnGraphNodes.insert(m_newName, node);
        m_nodeName = m_newName;
    }
}

void ChangeNodeNameCommand::undo()
{
    DeBruijnNode * node = m_graph->m_deBruijnGraphNodes[m_newName];
    if (node)
    {
        m_graph->m_deBruijnGraphNodes.remove(m_newName);
        node->setName(m_oldName);
        m_graph->m_deBruijnGraphNodes.insert(m_oldName, node);
        m_nodeName = m_oldName;
    }
}

ChangeNodeDepthCommand::ChangeNodeDepthCommand(AssemblyGraph * graph,
                                             DeBruijnNode * node,
                                             double newDepth,
                                             QUndoCommand * parent)
    : QUndoCommand(parent), m_graph(graph), m_nodeName(node->getName()),
      m_oldDepth(node->getDepth()), m_newDepth(newDepth), m_firstRedo(true)
{
    setText("Change node depth");
}

void ChangeNodeDepthCommand::redo()
{
    if (m_firstRedo)
    {
        m_firstRedo = false;
        return;
    }

    DeBruijnNode * node = m_graph->m_deBruijnGraphNodes[m_nodeName];
    if (node)
        node->setDepth(m_newDepth);
}

void ChangeNodeDepthCommand::undo()
{
    DeBruijnNode * node = m_graph->m_deBruijnGraphNodes[m_nodeName];
    if (node)
        node->setDepth(m_oldDepth);
}
