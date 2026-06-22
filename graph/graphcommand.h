#ifndef GRAPHCOMMAND_H
#define GRAPHCOMMAND_H

#include <QUndoCommand>
#include <QByteArray>

class AssemblyGraph;

class GraphStateCommand : public QUndoCommand
{
public:
    GraphStateCommand(AssemblyGraph * graph,
                      const QByteArray & before, const QByteArray & after,
                      QUndoCommand * parent = nullptr);
    void undo() override;
    void redo() override;

private:
    void restoreState(const QByteArray & gfaData);

    AssemblyGraph * m_graph;
    QByteArray m_before;
    QByteArray m_after;
    bool m_firstRedo;
};

#endif // GRAPHCOMMAND_H
