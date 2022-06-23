#include "cardpool.h"

void CardPool::clearPool()
{
    _pool.clear();
}

void CardPool::insertCard(Card card)
{
    QVector<Card>::iterator g;
    for(g = _pool.begin(); g != _pool.end(); g++) {
        if (g->compare(*g, card)) {
            _pool.insert(g, card);
        }
    }
}

void CardPool::delCard(Card card)
{
    QVector<Card>::iterator g;
    for(g = _pool.begin(); g != _pool.end(); g++) {
        if (g->compare(*g, card)) {
            _pool.erase(g);
        }
    }
}
