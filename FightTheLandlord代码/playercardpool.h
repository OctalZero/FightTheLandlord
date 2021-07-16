#ifndef PLAYERCARDPOOL_H
#define PLAYERCARDPOOL_H
#include <QVector>
#include <QList>
#include <QVariant>
#include <cardpool.h>

#include <QVector>
#include <QList>
#include <QVariant>
#include <cardpool.h>

typedef std::pair<int, int> PAIR;



enum CardTypes {
    ErrorCard, // 错误牌型 0
    SigleCard, // 单牌 main1 add0 series1 1
    DoubleCard, // 对子 main2 add0 series1 2
    ThreeCard, // 三不带 main3 add0 series1 3
    ThreeWithOneCard, // 三带一 main3 add1 series1 4
    ThreeWithTwoCard, // 三带二 main3 add2 series1 5
    LineCard, //顺子 main1 add0 series>=5 6
    DoubleLineCard, //连对 main2 add0 series>=3 7
    PlaneCard, // 飞机 main3 add0 series>=2 8
    PlaneWithOneCard, // 飞机带单 main3 add1 series>=2 9
    PlaneWithTwoCard, // 飞机带对 main3 add2 series>=2 10
    FourWithTwoSingleCard, // 四带二 main4 add2 series=1 11
    FourWithTwoDoubleCard, // 四带两对 main4 add2 series=1 12
    BombCard, // 炸弹 main4 add0 series=1 13
    BombKingCard // 王炸 main2 add0 series2 14
};
class Card;

struct CardShape {
    CardTypes Type;
    int main;
    int add;
    int series;
    int main_num;
};

class PlayerCardPool: public CardPool
{
    Q_OBJECT
public:
    CardTypes Judge_Card(int card_num[], int len);
    CardShape JudgeCard(QVector<Card> player); // 判断牌型
    CardShape JudgeSelfCard();
    bool compareRightCards(); // 跟上家出牌比较
    bool compareLeftCards(); // 跟下家出牌比较
    void setID();
    void setSelfRound(QList<QVariant> nums); // 添加自己想要出的牌
    void setRightRound(QList<QVariant> nums); // 添加上家想要出的牌
    void setLeftRound(QList<QVariant> nums); // 添加下家想要出的牌
    void setPtrRound(QJsonObject &json);
    void setOutCard(QVector<int> outcard); // 读取要出的牌
    void clearSelfCard(); // 清空上一轮自己出的牌
    void clearSelfCardShape(); // 清空上一轮自己出的牌型
    void clearRightCardShape(); // 清空牌库中上一轮上家出的牌型
    void clearLeftCardShape(); // 清空牌库中上一轮下家出的牌型
    CardShape getPlay_2_Shape();

    QVector<Card> player_1_round();
    QVector<Card> player_2_round();
    QVector<Card> player_3_round();
    QVector<int> getOutCard();

private:
    CardShape _play_1_shape; // 上家牌型
    CardShape _play_2_shape; // 自己牌型
    CardShape _play_3_shape; // 下家牌型
    QVector<Card> _player_1_round;  // 上家牌库
    QVector<Card> _player_2_round;  // 自己牌库
    QVector<Card> _player_3_round;  // 下家牌库
    QVector<int> m_outCard; // 出的牌
};

#endif // PLAYERCARDPOOL_H
