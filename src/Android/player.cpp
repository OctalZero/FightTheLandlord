#include <QJsonParseError>
#include <QJsonObject>
#include <QJsonArray>
#include "request.h"
#include "player.h"

Player::Player(QObject *parent, QTcpSocket *tcpSocket)
        :QObject(parent)
{
    if (tcpSocket == nullptr)
        m_tcpSocket = new QTcpSocket(this);
    m_tcpSocket = tcpSocket;

    connect(m_tcpSocket, &QTcpSocket::readyRead, this, &Player::readDatas);
}

QTcpSocket* Player::getSocket() const
{
    return m_tcpSocket;
}

void Player::setId(int id)
{
    m_id = id;
}

int Player::getId() const
{
    return m_id;
}

void Player::sendInit(const int type, const QJsonArray &cards, const QJsonValue &seat, const QJsonValue &firstScoreSeat, const QJsonArray &lordCards)
{
    if(m_tcpSocket->isOpen()){
        QJsonObject jsonObj;
        jsonObj.insert("type",type);
        jsonObj.insert("cards",cards);
        jsonObj.insert("seatId",seat);
        jsonObj.insert("firstScoreSeat",firstScoreSeat);
        jsonObj.insert("landLordCard",lordCards);

        QJsonDocument document;
        document.setObject(jsonObj);
        m_tcpSocket->write(document.toJson(QJsonDocument::Compact));
    }
}

void Player::sendScore(const int &type, const int &id, const int &score)
{
    if(m_tcpSocket->isOpen()){
        QJsonObject jsonObj;
        jsonObj.insert("type",type);
        jsonObj.insert("seatId",id);
        jsonObj.insert("score",score);

        QJsonDocument document;
        document.setObject(jsonObj);
        m_tcpSocket->write(document.toJson(QJsonDocument::Compact));
    }
}

void Player::sendOutCard(const int &type, const int &id, const QJsonArray &outcard)
{
    if(m_tcpSocket->isOpen()){
        QJsonObject jsonObj;
        jsonObj.insert("type",type);
        jsonObj.insert("seatId",id);
        jsonObj.insert("outCard",outcard);

        QJsonDocument document;
        document.setObject(jsonObj);
        m_tcpSocket->write(document.toJson(QJsonDocument::Compact));
    }
}

void Player::sendOutNoCard(const int &type, const int &id)
{
    if(m_tcpSocket->isOpen()){
        QJsonObject jsonObj;
        jsonObj.insert("type",type);
        jsonObj.insert("seatId",id);

        QJsonDocument document;
        document.setObject(jsonObj);
        m_tcpSocket->write(document.toJson(QJsonDocument::Compact));
    }
}

void Player::sendLeaveGame(const int &type, const int &id)
{
    if(m_tcpSocket->isOpen()){
        QJsonObject jsonObj;
        jsonObj.insert("type",type);
        jsonObj.insert("seatId",id);

        QJsonDocument document;
        document.setObject(jsonObj);
        m_tcpSocket->write(document.toJson(QJsonDocument::Compact));
    }
}

void Player::readDatas()
{
    QByteArray byteArray = m_tcpSocket->readAll();
    QJsonParseError jsonError;
    QJsonDocument doucment = QJsonDocument::fromJson(byteArray, &jsonError);

    if (!doucment.isNull() && (jsonError.error == QJsonParseError::NoError))
    {
        if (doucment.isObject()) {
            QJsonObject jsonObj = doucment.object();
            QJsonArray outCard;
            int Types{-1},score{-1};

            if (jsonObj.contains(QStringLiteral("type"))) {
                Types = jsonObj.value("type").toInt();
            }
            if (jsonObj.contains(QStringLiteral("score"))) {
                score = jsonObj.value("score").toInt();
            }
            if (jsonObj.contains(QStringLiteral("outCard"))) {
                outCard = jsonObj.value("outCard").toArray();
            }

            switch(Types){
            case CallScore:{
                emit signalSendScore(Types,m_id,score);
                break;
            }
            case OutCard:{
                emit signalSendOutCard(Types,m_id,outCard); // 发送给服务器发送出的牌消息信号
                break;
            }
            case NoOutCard:{
                emit signalSendNoOutCard(Types,m_id);
                break;
            }
            case LeaveGame:{
                emit signalSendLeaveGame(Types,m_id);
            }
            }

        }
    }
}
