import QtQuick 2.0
import QtQuick.Controls 2.12
Popup {
    anchors.centerIn: parent
    height: 100
    width: 100
    closePolicy :Popup.NoAutoClose//让其不能点击外部退出
    modal: true

    background: Rectangle{//将背景变成透明色
        color: "transparent"
    }

    BusyIndicator{
        anchors.centerIn: parent
        implicitWidth: 96
        implicitHeight: 96
    }
}
