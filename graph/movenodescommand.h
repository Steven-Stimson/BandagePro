#pragma once
#include <QUndoCommand>
#include <QPointF>
#include <QString>
#include <vector>

class MoveNodesCommand : public QUndoCommand {
public:
    struct NodeMove { QString nodeName; QPointF shift; };
    explicit MoveNodesCommand(std::vector<NodeMove> moves);
    void undo() override;
    void redo() override;
private:
    void apply(qreal direction);

    std::vector<NodeMove> m_moves;
    bool m_firstRedo = true;
};
