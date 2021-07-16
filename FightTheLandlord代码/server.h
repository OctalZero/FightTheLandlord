#ifndef SERVER_H
#define SERVER_H

#include <QObject>
#include <QString>
#include <QVector>
#include <QtNetwork>
#include "player.h"
#include "servercardpool.h"

class Server : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString ip READ ip WRITE setIp NOTIFY ipChanged)
    Q_PROPERTY(int port READ port WRITE setPort NOTIFY portChanged)

public:
    explicit Server(QObject* parent = nullptr);
    ~Server();
    QString ip() const;
    int port() const;

public slots:
    void setIp(QString ip);
    void setPort(int port);

signals:
    void ipChanged(QString ip);
    void portChanged(int port);
    void signalDistributeCard();

private slots:
    void appendClient(); // 添加连入的客户端
    void sendAllInit(const int &type, const Player *player, const QJsonArray &cards, const QJsonValue &seat, const QJsonValue &firstScoreSeat, const QJsonArray &lordCards); // 发给指定玩家牌初始信息
    void sendOtherScore(const int &type, const int &id, const int &score); //发给其他玩家自己的叫分
    void sendOtherOutCard(const int &type, const int &id, const QJsonArray &outcard); // 发给其他玩家自己出的牌
    void sendOtherNoOutCard(const int &type, const int &id); // 发给其他玩家自己不出牌的信息
    void sendOtherLeaveGame(const int &type, const int &id); // 发给其他玩家离开游戏

private:
    void initServer();
    void judgeBegin();  // 判断开始
    void sendInit(); //发送初始信息

private:
    QString m_ip;
    int m_port;
    QTcpServer *m_server;
    ServerCardPool *m_serverCardPool;
    QList<Player *> m_tcpClientSocketList;
};

#endif
