#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "sence.h"

Sence::Sence():
    server{nullptr}, client{new Client()}
{
    engine.rootContext()->setContextProperty("sence", this);
    engine.rootContext()->setContextProperty("server", server);
    engine.rootContext()->setContextProperty("client", client);

    this->initialize(&engine);
    this->setLicenseKey(PRODUCT_LICENSE_KEY); // 项目许可证
    this->setMainQmlFileName(QStringLiteral("qml/Main.qml")); // 用于发布
    this->setMainQmlFileName(QStringLiteral("qrc:/qml/Main.qml"));
    engine.load(QUrl(this->mainQmlFileName()));
}

Sence::~Sence()
{
    delete server;
    delete client;
}

void Sence::newServer()
{
    server = new Server();
    engine.rootContext()->setContextProperty("server", server);
    client->setCip(server->ip());
    client->setCport(server->port());
    client->link();
}

void Sence::overGame()
{
    if(server != nullptr)   delete server;
    delete client;
}

void Sence::newGame()
{
    server = nullptr;
    client = new Client();
    engine.rootContext()->setContextProperty("sence", this);
    engine.rootContext()->setContextProperty("server", server);
    engine.rootContext()->setContextProperty("client", client);
}
