#ifndef SENCE_H
#define SENCE_H

#include <FelgoApplication>
#include <QQmlApplicationEngine>
#include "server.h"
#include "client.h"
#include "player.h"
#include <QObject>

class Sence: public FelgoApplication
{
    Q_OBJECT
public:
    Sence();
    virtual ~Sence();
    Q_INVOKABLE void newServer(); // 创建服务器
    Q_INVOKABLE void overGame(); // 销毁游戏
    Q_INVOKABLE void newGame(); // 创建新游戏

private:
    QQmlApplicationEngine engine;
    Server* server;
    Client* client;
};

#endif // SENCE_H
