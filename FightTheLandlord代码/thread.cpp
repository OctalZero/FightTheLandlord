#include <QtNetwork>
#include "thread.h"

Thread::Thread(QObject *parent)
    : QThread(parent),quit(false)
{
}

Thread::~Thread()
{
    mutex.lock(); // 设置互斥锁为了对成员quit进行写操作
    quit = true; // 为了退出run()中的while(!quit)
    cond.wakeOne(); // 唤醒当前线程
    mutex.unlock(); // 解锁
    wait(); // 如果不wait可能导致Thread已经析构，而run还未结束，最后可能在run中由于访问Thread已经析构的成员而导致崩溃等现象
}

void Thread::link(const QString &hostName, quint16 port) // 连接服务器
{
    QMutexLocker locker(&mutex); // QMutex的一个便利类，创建时相当于mutex.lock(),被销毁时相当于mutex.unlock(),在写复杂代码时很有效（局部变量的生存期）
    this->hostName = hostName; // 第一个hostName是线程成员变量，第二个是局部变量，是传入参数的引用，别被名字搞混了
    this->port = port;

    if (!isRunning())
        start();
    else
        cond.wakeOne(); // 唤醒一个满足等待条件的线程，这个线程即是被cond.wait()挂起的线程
}

void Thread::run() // 多线程最重要的就是run()函数了
{
    mutex.lock(); // 由于下面获取hostName和port，这两个参数也可能在主线程改变（requestNewDatas）故需要加锁

    QString serverName = hostName;
    quint16 serverPort = port;
    mutex.unlock();

    while (!quit) { // 只要quit为false就一直循环
        const int Timeout = 5 * 1000; // 5秒延时

        QTcpSocket socket;
        socket.connectToHost(serverName, serverPort); // connectToHost是异步操作
        if (!socket.waitForConnected(Timeout)) { // 阻塞等待连接成功
            emit error(socket.error(), socket.errorString());
            return;
        }
    }

    mutex.lock();
    cond.wait(&mutex); // 接收一次消息后阻塞等待条件
    serverName = hostName; // 下次仍然重设hostName及port
    serverPort = port;
    mutex.unlock();
}

void Thread::sendDatas()
{

}

void Thread::readDatas()
{
    QTcpSocket socket;
    QDataStream in(&socket); // 开始读取数据
    in.setVersion(QDataStream::Qt_4_0); // 同样设置了版本号
    QString data;
    const int Timeout = 5 * 1000; // 5秒延时

    do {
        if (!socket.waitForReadyRead(Timeout)) { // 这里主要为了等待数据达到blockSize的长度
            emit error(socket.error(), socket.errorString());
            return;
        }

        in.startTransaction();
        in >> data; //数据长度赋予data
    } while (!in.commitTransaction()); // 通过commitTransaction判断发送是否发生异常

    mutex.lock();
    emit newDatas(data); // 自定义信号，newDatas被emit
    mutex.unlock();

}


