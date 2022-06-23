#ifndef CLIENT_H
#define CLIENT_H

#include <QObject>
#include <QTcpSocket>
#include "cardpool.h"
#include "playercardpool.h"

class Client : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString cip READ cip WRITE setCip NOTIFY cipChanged)
    Q_PROPERTY(int cport READ cport WRITE setCport NOTIFY cportChanged)

public:
   Client(QObject *parent = nullptr);
   ~Client();
   QString cip() const;
   int cport() const;
   Q_INVOKABLE QVector<int> getHandPool();
   Q_INVOKABLE QVector<int> getLandLordCard();
   Q_INVOKABLE int getLeftCardNum();
   Q_INVOKABLE int getRightCardNum();
   Q_INVOKABLE int getMeCardNum();
   Q_INVOKABLE void sendScore(); // 向其他玩家发送自己的叫分
   Q_INVOKABLE void addCallScoreNum(); // 增加叫分次数
   Q_INVOKABLE bool judgeLandLord(); // 判断是否能选出地主
   Q_INVOKABLE void checkOutCard(); // 检查牌型
   Q_INVOKABLE void noOutCard(); // 不出牌
   Q_INVOKABLE void setHandPool(QVector<int> handpool);
   Q_INVOKABLE QVector<int> getRightOutCard();
   Q_INVOKABLE QVector<int> getLeftOutCard();
   Q_INVOKABLE void setCallScore(int score);
   Q_INVOKABLE void setOutCard(QVector<int> outcard);
   Q_INVOKABLE void setSelfRound(QList<QVariant> outcard); // 添加自己想要出的牌到牌库
   Q_INVOKABLE void setRightRound(); // 添加上家想要出的牌到牌库
   Q_INVOKABLE void setLeftfRound(); // 添加下家想要出的牌到牌库
   Q_INVOKABLE void changeSelfCardNum(); // 改变自己牌数
   Q_INVOKABLE void changeRightCardNum(); // 改变上家牌数
   Q_INVOKABLE void changeLeftCardNum(); // 改变下家牌数
   Q_INVOKABLE void sendOutCard(); // 向其他玩家发送自己出的牌
   Q_INVOKABLE void clearSelfCard(); // 清空牌库中上一轮自己出的牌
   Q_INVOKABLE void clearSelfCardShape();// 清空牌库中上一轮自己出的牌型
   Q_INVOKABLE void clearLeftOutCard(); // 清空上家出牌显示
   Q_INVOKABLE void clearRightOutCard(); // 清空下家出牌显示
   Q_INVOKABLE bool checkGameOver(); // 检测游戏状态
   Q_INVOKABLE void sendLeaveGame(); // 向其他玩家发送自己离开的信息
   Q_INVOKABLE void checkCardShape(); // 检测牌型

signals:
   void signalStartGame();
   void signalSendCard();
   void signalFirstScore();
   void signalLordIsMe();
   void signalLordIsLeft();
   void signalLordIsRight();
   void signalDisplayLandLordCard();
   void signalOutCardTime();
   void signalErrorType();
   void signalTrueType();
   void signalShowLeftOutCard();
   void signalShowRightOutCard();
   void signalShowLeftNoOutCard();
   void signalShowRightNoOutCard();
   void signalOutOneButton();
   void signalShowLeftOneScore();
   void signalShowLeftTwoScore();
   void signalShowLeftThreeScore();
   void signalShowRightOneScore();
   void signalShowRightTwoScore();
   void signalShowRightThreeScore();
   void signalSelfIsSun();
   void signalSelfIsZhu();
   void signalSelfIsSha();
   void signalFarmerWinGame();
   void signalFarmerLossGame();
   void signalLordWinGame();
   void signalLordLossGame();
   void signalOtherLeaveGame();
   void signalBombCardShape();
   void signalBombKingCardShape();
   void signalDoubleLineCardShape();
   void signalPlaneCard();
   void cipChanged(QString cip);
   void cportChanged(int cport);

public slots:
   void link();
   void setCip(QString cip);
   void setCport(int cport);

private slots:
      void readDatas();

private:
    void sendHandCard(QJsonArray cards); // 发手牌
    void sendLandLordCard(QJsonArray cards); // 存入地主牌
    void addLordCard(); // 添加地主牌到手牌
    void judgeSeat(); // 判断座位
    void judgeScoreSeat(); // 判断叫分位置
    void selectLandLord(); // 选择地主
    void judgeOutCard(); // 判断出牌座位
    QList<QVariant> tranArrayToList(QJsonArray cards); // 转换类型
    void sendOutNoCard(); // 向其他玩家发送自己不出牌
    void showRightScore(); // 显示上家叫分
    void showLeftScore(); // 显示下家叫分

private:
    QTcpSocket* serverSocket; // 服务器套接字
    PlayerCardPool* playerCardPool; // 玩家牌库
    QVector<int> m_handPool; // 手牌
    QVector<int> m_landLordCard; // 地主牌
    QVector<int> m_rightOutCard; // 上家出牌
    QVector<int> m_leftOutCard; // 下家出牌
    int m_seatId; // 座位号
    int m_cardNum; // 手牌数
    int m_score; // 自己叫分
    int m_leftSeat; // 下家座位号
    int m_rightSeat; // 上家座位号
    int m_landLord; // 地主座位号
    int m_firstScoreSeat; // 第一个叫分的座位
    int m_rightScore; // 上家叫分
    int m_leftScore; // 下家叫分
    int m_rightCardNum; // 上家手牌数
    int m_leftCardNum; // 下家手牌数
    int m_outCardSeat; // 出牌座位
    int m_noOutNum; // 其他玩家不抢次数
    int m_callScoreNum; // 叫分次数
    QString m_cip; // ip地址
    quint16 m_cport; // 端口号
};

#endif
