#ifndef SERVERCARDPOOL_H
#define SERVERCARDPOOL_H
#include "cardpool.h"
#include <QObject>
class ServerCardPool: public CardPool
{
    Q_OBJECT

public:
    QVector<Card> play_1();
    QVector<Card> play_2();
    QVector<Card> play_3();
    QVector<Card> landLoard_card();

public slots:
    void initPool();
    void distributeCard();

private:
    QVector<Card> _play_1;
    QVector<Card> _play_2;
    QVector<Card> _play_3;
    QVector<Card> _landLoard_card;
};

#endif // SERVERCARDPOOL_H
