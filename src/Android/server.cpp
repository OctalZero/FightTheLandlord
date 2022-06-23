#include <QtNetwork>
#include <QtCore>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonValue>
#include <iostream>
#include "server.h"
#include "request.h"

Server::Server(QObject *parent)
    :QObject(parent), m_ip("Can't Find IP!"), m_port(0)
{
    m_server = new QTcpServer(this);
    m_serverCardPool = new ServerCardPool;

    connect(this, &Server::signalDistributeCard, m_serverCardPool, &ServerCardPool::distributeCard); // 通知洗牌
    initServer();
    connect(m_server, &QTcpServer::newConnection, this, &Server::appendClient); //将新连接放入list
}

Server::~Server()
{
    delete m_server;
    delete m_serverCardPool;
    for(int g = 0; g < m_tcpClientSocketList.count(); g++){
        delete m_tcpClientSocketList[g];
    }
}

void Server::initServer()
{
    emit signalDistributeCard();

    m_server->listen(); // 监听随机端口

    QString ipAddress;
    QList<QHostAddress> ipAddressesList = QNetworkInterface::allAddresses();
    // 使用第一个非本地主机IPv4地址
    for (int i = 0; i < ipAddressesList.size(); ++i) {
        if(ipAddressesList.at(i) != QHostAddress::LocalHost &&
           ipAddressesList.at(i).toIPv4Address()) {
                ipAddress = ipAddressesList.at(i).toString();
                break;
        }
    }
    // 如果没有找到，使用IPv4本地服务器
    if (ipAddress.isEmpty())
        ipAddress = QHostAddress(QHostAddress::LocalHost).toString();
    // 通过以上方式查找到本机ip

    m_ip = ipAddress;
    m_port = m_server->serverPort();
}

void Server::sendAllInit(const int &type, const Player *player, const QJsonArray &cards, const QJsonValue &seat, const QJsonValue &firstScoreSeat, const QJsonArray &lordCards)
{
    for(int i = 0; i <  m_tcpClientSocketList.count(); i++){
        if(player->getId() == m_tcpClientSocketList[i]->getId()){
             m_tcpClientSocketList[i]->sendInit(type, cards, seat, firstScoreSeat, lordCards);
        }
    }
}

void Server::sendOtherScore(const int &type, const int &id, const int &score)
{
    for(int i = 0; i <  m_tcpClientSocketList.count(); i++){
        if(id != m_tcpClientSocketList[i]->getId()){
             m_tcpClientSocketList[i]->sendScore(type, id, score);
        }
    }
}

void Server::sendOtherOutCard(const int &type, const int &id, const QJsonArray &outcard)
{
    for(int i = 0; i <  m_tcpClientSocketList.count(); i++){
        if(id != m_tcpClientSocketList[i]->getId()){
             m_tcpClientSocketList[i]->sendOutCard(type, id, outcard);
        }
    }
}

void Server::sendOtherNoOutCard(const int &type, const int &id)
{
    for(int i = 0; i <  m_tcpClientSocketList.count(); i++){
        if(id != m_tcpClientSocketList[i]->getId()){
             m_tcpClientSocketList[i]->sendOutNoCard(type, id);
        }
    }
}

void Server::sendOtherLeaveGame(const int &type, const int &id)
{
    for(int i = 0; i <  m_tcpClientSocketList.count(); i++){
        if(id != m_tcpClientSocketList[i]->getId()){
             m_tcpClientSocketList[i]->sendLeaveGame(type, id);
        }
    }
}

void Server::appendClient()
{
    Player *m_tcp = new Player(this,m_server->nextPendingConnection());

    // 连接玩家的信号和服务器的槽
    connect(m_tcp, &Player::signalSendOutCard, this, &Server::sendOtherOutCard);
    connect(m_tcp, &Player::signalSendNoOutCard, this, &Server::sendOtherNoOutCard);
    connect(m_tcp, &Player::signalSendScore, this, &Server::sendOtherScore);
    connect(m_tcp, &Player::signalSendLeaveGame, this, &Server::sendOtherLeaveGame);

    m_tcp->setId(m_tcpClientSocketList.count());
    qDebug()<<"ID:"<<m_tcp->getId()<<"\n";
    m_tcpClientSocketList.append(m_tcp);

    judgeBegin();
}

void Server::judgeBegin(){
    if(m_tcpClientSocketList.count() == 3){
        sendInit();
    }
}
void Server::sendInit()
{
    QJsonArray arr1,arr2,arr3,arrLord;
    for(QVector<Card>::iterator g = m_serverCardPool->play_1().begin(); g < m_serverCardPool->play_1().end(); g++){
        int card{g->getcolor()*13 + g->getpoint()};
        QJsonValue s = card;
        arr1.append(s);
    }
    for(QVector<Card>::iterator g = m_serverCardPool->play_2().begin(); g < m_serverCardPool->play_2().end(); g++){
        int card{g->getcolor()*13 + g->getpoint()};
        QJsonValue s = card;
        arr2.append(s);
    }
    for(QVector<Card>::iterator g = m_serverCardPool->play_3().begin(); g < m_serverCardPool->play_3().end(); g++){
        int card{g->getcolor()*13 + g->getpoint()};
        QJsonValue s = card;
        arr3.append(s);
    }

    for(QVector<Card>::iterator g = m_serverCardPool->landLoard_card().begin(); g < m_serverCardPool->landLoard_card().end(); g++){
        int card{g->getcolor()*13 + g->getpoint()};
        QJsonValue s = card;
        arrLord.append(s); // 地主牌
    }


    QJsonValue id1, id2, id3;
    id1 = 0;
    id2 = 1;
    id3 = 2;

    //随机选出叫分的座位号
    QJsonValue landLord;
    srand(time(NULL));
    landLord = rand() % 3;
//    landLord = 0; // 固定首选叫分调试

    sendAllInit(BeginGame, m_tcpClientSocketList.at(0), arr1, id1, landLord, arrLord);
    sendAllInit(BeginGame, m_tcpClientSocketList.at(1), arr2, id2, landLord, arrLord);
    sendAllInit(BeginGame, m_tcpClientSocketList.at(2), arr3, id3, landLord, arrLord);
}

QString Server::ip() const
{
    return m_ip;
}

int Server::port() const
{
    return m_port;
}

void Server::setIp(QString ip)
{
    if (m_ip == ip)
        return;

    m_ip = ip;
    emit ipChanged(m_ip);
}

void Server::setPort(int port)
{
    if (m_port == port)
        return;

    m_port = port;
    emit portChanged(m_port);
}
