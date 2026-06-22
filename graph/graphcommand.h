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


#ifndef GRAPHCOMMAND_H
#define GRAPHCOMMAND_H

#include <QUndoCommand>
#include <QList>
#include <QString>
#include <QByteArray>
#include <QColor>
#include <vector>

class AssemblyGraph;
class DeBruijnNode;
class DeBruijnEdge;
class MyGraphicsScene;

struct NodeSnapshot
{
    QString name;
    double depth;
    QByteArray sequence;
    QString rcNodeName;
    bool isDrawn;
    QColor colour;
    QString customLabel;

    NodeSnapshot() : depth(0.0), isDrawn(false) {}
};

struct EdgeSnapshot
{
    QString startNodeName;
    QString endNodeName;
    int overlap;
    int overlapType;
    bool isDrawn;

    EdgeSnapshot() : overlap(0), overlapType(0), isDrawn(false) {}
};

class DeleteNodesCommand : public QUndoCommand
{
public:
    DeleteNodesCommand(AssemblyGraph * graph,
                      const std::vector<DeBruijnNode *> & nodes,
                      MyGraphicsScene * scene,
                      QUndoCommand * parent = nullptr);

    void undo() override;
    void redo() override;

private:
    AssemblyGraph * m_graph;
    MyGraphicsScene * m_scene;
    QList<NodeSnapshot> m_deletedNodes;
    QList<EdgeSnapshot> m_deletedEdges;
    bool m_firstRedo;
};

class MergeNodesCommand : public QUndoCommand
{
public:
    MergeNodesCommand(AssemblyGraph * graph,
                     const QList<DeBruijnNode *> & nodes,
                     MyGraphicsScene * scene,
                     bool recalculateDepth,
                     QUndoCommand * parent = nullptr);

    void undo() override;
    void redo() override;
    bool isValid() const { return m_valid; }

private:
    AssemblyGraph * m_graph;
    MyGraphicsScene * m_scene;
    bool m_recalculateDepth;
    bool m_valid;
    bool m_firstRedo;

    QList<NodeSnapshot> m_originalNodes;
    QList<EdgeSnapshot> m_removedEdges;
    NodeSnapshot m_newPosNode;
    NodeSnapshot m_newNegNode;
    QList<EdgeSnapshot> m_newEdges;
};

class ChangeNodeNameCommand : public QUndoCommand
{
public:
    ChangeNodeNameCommand(AssemblyGraph * graph,
                         DeBruijnNode * node,
                         const QString & newName,
                         QUndoCommand * parent = nullptr);

    void undo() override;
    void redo() override;

private:
    AssemblyGraph * m_graph;
    QString m_nodeName;
    QString m_oldName;
    QString m_newName;
    bool m_firstRedo;
};

class ChangeNodeDepthCommand : public QUndoCommand
{
public:
    ChangeNodeDepthCommand(AssemblyGraph * graph,
                          DeBruijnNode * node,
                          double newDepth,
                          QUndoCommand * parent = nullptr);

    void undo() override;
    void redo() override;

private:
    AssemblyGraph * m_graph;
    QString m_nodeName;
    double m_oldDepth;
    double m_newDepth;
    bool m_firstRedo;
};

#endif // GRAPHCOMMAND_H
