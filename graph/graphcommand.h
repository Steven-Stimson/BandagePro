#ifndef GRAPHCOMMAND_H
#define GRAPHCOMMAND_H

#include <QUndoCommand>
#include <QByteArray>
#include <functional>

struct ViewState;

class GraphStateCommand : public QUndoCommand
{
public:
    using RestoreCallback = std::function<void(const ViewState &)>;

    GraphStateCommand(const QByteArray &before,
                      const QByteArray &after,
                      RestoreCallback callback = nullptr,
                      QUndoCommand *parent = nullptr);

    void undo() override;
    void redo() override;

private:
    void restoreState(const QByteArray &viewStateData);

    QByteArray m_before;
    QByteArray m_after;
    RestoreCallback m_callback;
    bool m_firstRedo;
};

#endif // GRAPHCOMMAND_H
