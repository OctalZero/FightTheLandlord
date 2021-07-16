import QtQuick 2.0
import QtQuick.Controls 2.12
Popup {
    anchors.centerIn: parent
    width: 300
    height: 150

    modal: true

    background: Image{//将背景变成透明色
        source: "../../assets/img/Background/man-machine.png"
        anchors.fill: parent
    }
}
