#include "client.h"
#include "request.h"
#include <QtNetwork>
#include <algorithm>

Client::Client(QObject *parent)
    : QObject(parent),serverSocket{new QTcpSocket},playerCardPool{new PlayerCardPool},
      m_score{-1},m_rightScore{-1},m_leftScore{-1},m_outCardSeat{-1},m_noOutNum{0},m_callScoreNum{0}
{

    // 找出要连接到哪个IP
    QString ipAddress;
    QList<QHostAddress> ipAddressesList = QNetworkInterface::allAddresses();
    // 使用第一个非本地主机IPv4地址
    for (int i = 0; i < ipAddressesList.size(); ++i) {
        if (ipAddressesList.at(i) != QHostAddress::LocalHost &&
                ipAddressesList.at(i).toIPv4Address()) {
            ipAddress = ipAddressesList.at(i).toString();
            break;
        }
    }
    // 如果没有找到，使用IPv4本地服务器
    if (ipAddress.isEmpty())
        ipAddress = QHostAddress(QHostAddress::LocalHost).toString();

    connect(serverSocket,&QTcpSocket::readyRead,this,&Client::readDatas);
}

Client::~Client()
{
    delete serverSocket;
    delete playerCardPool;
    m_handPool.clear();
    m_landLordCard.clear();
    m_rightOutCard.clear();
    m_leftOutCard.clear();
    m_seatId = -1;
    m_cardNum = 17;
    m_score = -1;
    m_leftSeat = -1;
    m_rightSeat = -1;
    m_landLord = -1;
    m_firstScoreSeat = -1;
    m_rightScore = -1;
    m_leftScore = -1;
    m_rightCardNum = 17;
    m_leftCardNum = 17;
    m_outCardSeat = -1;
    m_noOutNum = 0;
    m_callScoreNum = 0;

}

void Client::link()
{
    QString serverName = this->m_cip;
    quint16 serverPort = this->m_cport;


    if(serverSocket->isOpen())
        serverSocket->abort(); // 终止之前的连接，重置套接字
    serverSocket->connectToHost(serverName, serverPort);
}

void Client::readDatas()
{
    QByteArray byteArray = serverSocket->readAll();
    QJsonParseError jsonError;
    QJsonDocument doucment = QJsonDocument::fromJson(byteArray, &jsonError);

    if (!doucment.isNull() && (jsonError.error == QJsonParseError::NoError))
    {
        if (doucment.isObject()) {
            QJsonObject jsonObj = doucment.object();
            QJsonArray cards, landLordCard, outCard;
            int Types{-1}, seatId{-1}, firstScoreSeat{-1}, score{-1};

            if (jsonObj.contains(QStringLiteral("type"))) {
                Types = jsonObj.value("type").toInt();
            }
            if (jsonObj.contains(QStringLiteral("cards"))) {
                cards = jsonObj.value("cards").toArray();
            }
            if (jsonObj.contains(QStringLiteral("seatId"))) {
                seatId = jsonObj.value("seatId").toInt();
            }
            if (jsonObj.contains(QStringLiteral("firstScoreSeat"))) {
                firstScoreSeat = jsonObj.value("firstScoreSeat").toInt();
            }
            if (jsonObj.contains(QStringLiteral("score"))) {
                score = jsonObj.value("score").toInt();
            }
            if (jsonObj.contains(QStringLiteral("landLordCard"))) {
                landLordCard = jsonObj.value("landLordCard").toArray();
            }
            if (jsonObj.contains(QStringLiteral("outCard"))) {
                outCard = jsonObj.value("outCard").toArray();
            }

            switch(Types){
            case BeginGame:{
                emit signalStartGame();
                sendHandCard(cards); // 发手牌
                sendLandLordCard(landLordCard); // 存入地主牌
                m_seatId = seatId;
                m_firstScoreSeat = firstScoreSeat;
                judgeSeat(); // 判断位置
                judgeScoreSeat(); // 判断叫分位置
                break;
            }
            case CallScore:{
                if( m_rightSeat== seatId){
                    m_rightScore = score;
                    showRightScore();
                    m_callScoreNum++;
                    if(judgeLandLord() !=  true){ // 判断是否能选出地主
                        emit signalFirstScore();
                    }
                }
                if(m_leftSeat == seatId){
                    m_leftScore = score;
                    showLeftScore();
                    m_callScoreNum++;
                    judgeLandLord(); // 判断是否能选出地主
                }
                break;
            }
            case OutCard:{
                if(seatId == m_rightSeat){
                    playerCardPool->clearRightCardShape(); // 清空之前的上家牌
                    clearRightOutCard();
                    playerCardPool->setRightRound(tranArrayToList(outCard));
                    for(QJsonArray::iterator g = outCard.begin(); g < outCard.end(); g++){
                        int a = (*g).toInt();
                        m_rightOutCard.append(a);
                    }
                    emit signalShowRightOutCard();
                    m_noOutNum = 0; // 重置不出次数
                    if(checkGameOver() == false){
                        emit signalOutCardTime();
                    }
                }
                if(seatId == m_leftSeat){
                    playerCardPool->clearLeftCardShape(); // 清空之前的下家牌
                    clearLeftOutCard();
                    playerCardPool->setLeftRound(tranArrayToList(outCard));
                    for(QJsonArray::iterator g = outCard.begin(); g < outCard.end(); g++){
                        int a = (*g).toInt();
                        m_leftOutCard.append(a);
                    }
                    emit signalShowLeftOutCard();
                    m_noOutNum = 0; // 重置不出次数
                    checkGameOver();
                }
                break;
            }
            case NoOutCard:{
                if(seatId == m_rightSeat){
                    m_noOutNum++; // 增加一次不出次数
                    playerCardPool->clearRightCardShape();
                    clearRightOutCard();
                    emit signalShowRightNoOutCard();
                    if(m_noOutNum == 2){
                        emit signalOutOneButton();
                        m_noOutNum = 0; // 重新清空不出次数
                    }
                    else{
                        emit signalOutCardTime();
                    }
                }
                if(seatId == m_leftSeat){
                    m_noOutNum++; // 增加一次不出次数
                    playerCardPool->clearLeftCardShape();
                    clearLeftOutCard();
                    emit signalShowLeftNoOutCard();
                }
                break;
            }
            case LeaveGame:{
                emit signalOtherLeaveGame();
                break;
            }
            }

        }
    }
}

void Client::sendHandCard(QJsonArray cards)
{
    for(QJsonArray::iterator g = cards.begin(); g < cards.end(); g++){
        qDebug()<< *g <<"\n";
        int a = (*g).toInt();
        m_handPool.append(a);
    }
    for(int i = 0; i <  m_handPool.count(); i++){
        qDebug()<< m_handPool.at(i) << "\n";
    }
    emit signalSendCard();
}

void Client::sendLandLordCard(QJsonArray cards)
{
    m_landLordCard.clear();
    for(QJsonArray::iterator g = cards.begin(); g < cards.end(); g++){
        qDebug()<< *g <<"\n";
        int a = (*g).toInt();
        m_landLordCard.append(a);
    }
    for(int i = 0; i <  m_landLordCard.count(); i++){
        qDebug()<< "landCard:"<<m_landLordCard.at(i) << "\n";
    }
}

void Client::addLordCard()
{
    for(QVector<int>::iterator g = m_landLordCard.begin(); g < m_landLordCard.end(); g++){
        m_handPool.append(*g);
    }
}

void Client::judgeSeat()
{
    if(m_seatId == 0){
        m_leftSeat = 1;
        m_rightSeat = 2;
        emit signalSelfIsSun();
    }
    if(m_seatId == 1){
        m_leftSeat = 2;
        m_rightSeat = 0;
        emit signalSelfIsZhu();
    }
    if(m_seatId == 2){
        m_leftSeat = 0;
        m_rightSeat = 1;
        emit signalSelfIsSha();
    }
}

void Client::judgeScoreSeat()
{
    if(m_seatId == m_firstScoreSeat) emit signalFirstScore();
}

void Client::selectLandLord()
{
    qDebug()<<"left:"<<m_leftSeat<<"\n";
    qDebug()<<"right:"<<m_rightSeat<<"\n";
    if(m_seatId == m_landLord){
        m_cardNum = 20;
        m_leftCardNum = 17;
        m_rightCardNum = 17;
        m_outCardSeat = m_seatId; // 设置出牌座位
        emit signalLordIsMe();
    }
    if(m_leftSeat == m_landLord){
        m_leftCardNum = 20;
        m_cardNum = 17;
        m_rightCardNum = 17;
        m_outCardSeat = m_leftSeat; // 设置出牌座位
        emit signalLordIsLeft();
    }
    if(m_rightSeat == m_landLord){
        m_rightCardNum = 20;
        m_cardNum = 17;
        m_leftCardNum = 17;
        m_outCardSeat = m_rightSeat; // 设置出牌座位
        emit signalLordIsRight();
    }
}

void Client::judgeOutCard()
{
    if(m_outCardSeat == m_seatId) emit signalOutOneButton();
}

QList<QVariant> Client::tranArrayToList(QJsonArray cards)
{
    QList<QVariant> outcard;
    for(QJsonArray::iterator g = cards.begin(); g < cards.end(); g++){
        int a = (*g).toInt();
        outcard.append(a);
    }
    return outcard;
}

void Client::sendOutNoCard()
{
    const int Timeout = 5 * 1000; // 5秒延时

    if (!serverSocket->isOpen()) {
        serverSocket->connectToHost(m_cip, m_cport);
        serverSocket->waitForConnected(Timeout);
    }

    if (!serverSocket->isOpen()) return; // 超时

    QJsonObject json;
    json.insert("type", NoOutCard);

    QJsonDocument document;
    document.setObject(json);
    serverSocket->write(document.toJson(QJsonDocument::Compact));
}

void Client::showRightScore()
{
    if(m_rightScore == 1){
        emit signalShowRightOneScore();
    }   else if(m_rightScore == 2){
        emit signalShowRightTwoScore();
    }   else if(m_rightScore == 3){
        emit signalShowRightThreeScore();
    }
}

void Client::showLeftScore()
{
    if(m_leftScore == 1){
        emit signalShowLeftOneScore();
    }   else if(m_leftScore == 2){
        emit signalShowLeftTwoScore();
    }   else if(m_leftScore == 3){
        emit signalShowLeftThreeScore();
    }
}

void Client::clearLeftOutCard()
{
    if(m_leftOutCard.count() != 0)
        m_leftOutCard.clear();
}

void Client::clearRightOutCard()
{
    if(m_rightOutCard.count() != 0)
        m_rightOutCard.clear();
}

bool Client::checkGameOver()
{
    if(m_cardNum == 0){
        if(m_seatId == m_landLord){
            emit signalLordWinGame();
        }  else {
            emit signalFarmerWinGame();
        }
        return true;
    }
    else if(m_rightCardNum == 0 && m_rightSeat == m_landLord){
        emit signalFarmerLossGame();
        return true;
    }
    else if(m_leftCardNum == 0 && m_leftSeat == m_landLord){
        emit signalFarmerLossGame();
        return true;
    }
    else if(m_rightCardNum == 0 && m_seatId == m_landLord){
        emit signalLordLossGame();
        return true;
    }
    else if (m_leftCardNum == 0 && m_seatId == m_landLord) {
        emit signalLordLossGame();
        return true;
    }
    else if(m_rightCardNum == 0 && m_seatId != m_landLord){
        emit signalFarmerWinGame();
        return  true;
    }
    else if(m_leftCardNum == 0 && m_seatId != m_landLord){
        emit signalFarmerWinGame();
        return  true;
    }
    else{
        return false;
    }
}

void Client::sendLeaveGame()
{
    const int Timeout = 5 * 1000; // 5秒延时

    if (!serverSocket->isOpen()) {
        serverSocket->connectToHost(m_cip, m_cport);
        serverSocket->waitForConnected(Timeout);
    }

    if (!serverSocket->isOpen()) return; // 超时

    QJsonObject json;
    json.insert("type", LeaveGame);

    QJsonDocument document;
    document.setObject(json);
    serverSocket->write(document.toJson(QJsonDocument::Compact));
}

void Client::checkCardShape()
{
    CardShape shape{playerCardPool->JudgeSelfCard()};
    if(shape.Type == BombCard){
        emit signalBombCardShape();
    }   else if(shape.Type == BombKingCard){
        emit signalBombKingCardShape();
    }   else if(shape.Type == DoubleLineCard){
        emit signalDoubleLineCardShape();
    }   else if(shape.Type == PlaneCard || shape.Type == PlaneWithOneCard || shape.Type == PlaneWithTwoCard){
        emit signalPlaneCard();
    }
}

QString Client::cip() const
{
    return m_cip;
}

int Client::cport() const
{
    return m_cport;
}

QVector<int> Client::getHandPool()
{
    return m_handPool;
}

QVector<int> Client::getLandLordCard()
{
    return m_landLordCard;
}

int Client::getLeftCardNum()
{
    return m_leftCardNum;
}

int Client::getRightCardNum()
{
    return  m_rightCardNum;
}

int Client::getMeCardNum()
{
    return  m_cardNum;
}

void Client::sendScore()
{
    const int Timeout = 5 * 1000; // 5秒延时

    if (!serverSocket->isOpen()) {
        serverSocket->connectToHost(m_cip, m_cport);
        serverSocket->waitForConnected(Timeout);
    }

    if (!serverSocket->isOpen()) return; // 超时

    QJsonObject json;
    json.insert("type", CallScore);
    json.insert("score",m_score);

    QJsonDocument document;
    document.setObject(json);
    serverSocket->write(document.toJson(QJsonDocument::Compact));
}

void Client::addCallScoreNum()
{
    m_callScoreNum++;
}

bool Client::judgeLandLord()
{
    if(m_callScoreNum >= 3){
        // 判断地主
        if(m_score > m_rightScore && m_score > m_leftScore){
            m_landLord = m_seatId;
        }   else if(m_seatId == m_firstScoreSeat && m_score >= m_rightScore && m_score >= m_leftScore){
            m_landLord = m_seatId;
        }   else if(m_rightScore > m_score && m_rightScore > m_leftScore){
            m_landLord = m_rightSeat;
        }   else if(m_rightSeat == m_firstScoreSeat && m_rightScore >= m_score && m_rightScore >= m_leftScore){
            m_landLord = m_rightSeat;
        }   else if(m_leftScore > m_score && m_leftScore > m_rightScore){
            m_landLord = m_leftSeat;
        }   else if(m_leftSeat == m_firstScoreSeat && m_leftScore >= m_score && m_leftScore >= m_rightScore){
            m_landLord = m_leftSeat;
        }   else if(m_seatId == ((m_firstScoreSeat+1)%3) && m_score >= m_leftScore && m_score >= m_rightScore){
            m_landLord = m_seatId;
        }   else if(m_rightSeat == ((m_firstScoreSeat+1)%3) && m_rightScore >= m_leftScore && m_rightScore >= m_score){
            m_landLord = m_rightSeat;
        }   else if(m_leftSeat == ((m_firstScoreSeat+1)%3) && m_leftScore >= m_score && m_leftScore >= m_rightScore){
            m_landLord = m_leftSeat;
        }

        if(m_seatId == m_landLord){
            addLordCard();
            emit signalSendCard(); // 更新手牌
            m_outCardSeat = m_seatId;
        }
        emit signalDisplayLandLordCard(); // 显示地主牌信号
        selectLandLord(); // 选地主
        judgeOutCard(); // 判断出牌座位
        return true;
    }
    else{
        return  false;
    }
}

void Client::checkOutCard()
{
    if(m_leftOutCard.count() == 0 && m_rightOutCard.count() == 0){ //自己是第一个出牌的或者出牌了没人要
        if(playerCardPool->player_2_round().count() == 0){
            emit signalErrorType();
        } else if(playerCardPool->JudgeSelfCard().Type == ErrorCard){
            emit signalErrorType();
        }   else{
            emit signalTrueType();
        }
    }   else if (m_rightOutCard.count() != 0){
        if(playerCardPool->player_2_round().count() == 0){
            emit signalErrorType();
        }else if(playerCardPool->compareRightCards()){
            emit signalTrueType();
        }   else{
            emit signalErrorType();
        }
    }   else if (m_rightOutCard.count() == 0 && m_leftOutCard.count() != 0){
        if(playerCardPool->player_2_round().count() == 0){
            emit signalErrorType();
        } else if(playerCardPool->compareLeftCards()){
            emit signalTrueType();
        }   else{
            emit signalErrorType();
        }
    }

}

void Client::noOutCard()
{
    clearSelfCard();
    clearSelfCardShape();
    sendOutNoCard();
}

void Client::setHandPool(QVector<int> handpool)
{
    m_handPool = handpool;
}

QVector<int> Client::getLeftOutCard()
{
    return m_leftOutCard;
}

void Client::setCallScore(int score)
{
    m_score = score;
}

void Client::setOutCard(QVector<int> outcard)
{
    playerCardPool->setOutCard(outcard);
}

void Client::setSelfRound(QList<QVariant> outcard)
{
    playerCardPool->setSelfRound(outcard);
}

void Client::setLeftfRound()
{
    QList<QVariant> outcard;
    for(QVector<int>::iterator g = m_leftOutCard.begin(); g < m_leftOutCard.end(); g++){
        QVariant s = *g;
        outcard.append(s);
    }
    playerCardPool->setLeftRound(outcard);
}

void Client::setRightRound()
{
    QList<QVariant> outcard;
    for(QVector<int>::iterator g = m_rightOutCard.begin(); g < m_rightOutCard.end(); g++){
        QVariant s = *g;
        outcard.append(s);
    }
    playerCardPool->setRightRound(outcard);
}

void Client::changeSelfCardNum()
{
    m_cardNum -= playerCardPool->getOutCard().count();
    qDebug()<<"meCard:"<<m_cardNum<<"\n";
}

void Client::changeLeftCardNum()
{
    m_leftCardNum -= m_leftOutCard.count();
    qDebug()<<"leftCard:"<<m_leftOutCard.count()<<"\n";
}

void Client::changeRightCardNum()
{
    m_rightCardNum -= m_rightOutCard.count();
    qDebug()<<"rightCard:"<<m_rightOutCard.count()<<"\n";
}

QVector<int> Client::getRightOutCard()
{
    return m_rightOutCard;
}

void Client::sendOutCard()
{
    const int Timeout = 5 * 1000; // 5秒延时

    if (!serverSocket->isOpen()) {
        serverSocket->connectToHost(m_cip, m_cport);
        serverSocket->waitForConnected(Timeout);
    }

    if (!serverSocket->isOpen()) return; // 超时

    QJsonArray outCard;
    //    for(QVector<int>::iterator g = playerCardPool->getOutCard().begin(); g < playerCardPool->getOutCard().end(); g++){
    for(int g = 0; g < playerCardPool->getOutCard().count(); g++){
        QJsonValue s = playerCardPool->getOutCard().value(g);
        qDebug()<<"outcard:"<<s<<"\n";
        outCard.append(s);
    }

    QJsonObject json;
    json.insert("type", OutCard);
    json.insert("outCard", outCard);

    QJsonDocument document;
    document.setObject(json);
    serverSocket->write(document.toJson(QJsonDocument::Compact));
}

void Client::clearSelfCard()
{
    playerCardPool->clearSelfCard();
}

void Client::clearSelfCardShape()
{
    playerCardPool->clearSelfCardShape();
}

void Client::setCip(QString cip)
{
    if (m_cip == cip)
        return;

    m_cip = cip;
    emit cipChanged(m_cip);
}

void Client::setCport(int cport)
{
    if (m_cport == cport)
        return;

    m_cport = cport;
    emit cportChanged(m_cport);
}
