#include "servercardpool.h"

void random(int a[], int n)
{
   int index, tmp, i;
   srand(time(NULL));
   for (i = 0; i <n; i++)
    {
       index = rand() % (n - i) + i;
       if (index != i)
         {
            tmp = a[i];
            a[i] = a[index];
            a[index] = tmp;
         }
    }
}

QVector<Card> ServerCardPool::play_1()
{
    return _play_1;
}

QVector<Card> ServerCardPool::play_2()
{
    return _play_2;
}

QVector<Card> ServerCardPool::play_3()
{
    return _play_3;
}

QVector<Card> ServerCardPool::landLoard_card()
{
    return  _landLoard_card;
}

void ServerCardPool::initPool()
{
    for (int i = 0; i <= 3; i++) {
        for (int j = 1; j <= 13; j++) {
            Card card;
            card.setcolor(i);
            card.setpoint(j);
            _pool.append(card);
        }
    }
    Card smallKing;
    smallKing.setcolor(3);
    smallKing.setpoint(14);
    _pool.append(smallKing);
    Card bigKing;
    bigKing.setcolor(3);
    bigKing.setpoint(15);
    _pool.append(bigKing);
}

void ServerCardPool::distributeCard()
{
    int a[54];
    for(int i = 1; i <= 54; i++) {
        a[i-1] = i;
    }
    random(a, 54);
    for(int i = 1; i <= 54; i++) {
        int color = a[i-1] / 13;
        int num = (a[i-1] % 13);
        Card card;
        card.setpoint(num);
        card.setcolor(color);
        if (i <= 17) {
            _play_1.append(card);
        }else if (i >17 && i <=34) {
            _play_2.append(card);
        }else if (i >34 && i <=51) {
            _play_3.append(card);
        }else {
            _landLoard_card.append(card);
        }
    }
}
