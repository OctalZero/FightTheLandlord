#ifndef CARDPOOL_H
#define CARDPOOL_H
#include <QVector>
#include <QObject>
#include "card.h"

class CardPool: public QObject
{
    Q_OBJECT

public:
    void clearPool();
    void insertCard(Card card);
    void delCard(Card card);

protected:
    QVector<Card> _pool;
};

#endif // CARDPOOL_H
