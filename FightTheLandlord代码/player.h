#ifndef PLAYER_H
#define PLAYER_H

#include <QObject>
#include <QTcpSocket>

class Player : public QObject
{
    Q_OBJECT

public:
    explicit Player(QObject *parent = nullptr, QTcpSocket *tcpSocket = nullptr);
    QTcpSocket* getSocket() const;
    void setId(int id);
    int getId() const;

signals:
    void signalSendScore(const int &type, const int &id, const int &score);
    void signalSendOutCard(const int &type, const int &id, const QJsonArray &outcard);
    void signalSendNoOutCard(const int &type, const int &id);
    void signalSendLeaveGame(const int &type, const int &id);

public:
    void sendInit(const int type, const QJsonArray &cards, const QJsonValue &seat, const QJsonValue &firstScoreSeat, const QJsonArray &lordCards);
    void sendScore(const int &type, const int &id, const int &score);
    void sendOutCard(const int &type, const int &id, const QJsonArray &outcard);
    void sendOutNoCard(const int &type, const int &id);
    void sendLeaveGame(const int &type, const int &id);

private slots:
    void readDatas();

private:
    QTcpSocket *m_tcpSocket;
    int  m_id; //玩家座位号
};

#endif // PLAYER_H
