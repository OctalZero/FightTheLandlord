import QtQuick 2.10
import QtQuick.Controls 2.12
import Felgo 3.0
import QtQuick.Layouts 1.2
import "../common"
Popup{
    id:setting

    property alias music_ground: background_music
    property alias music_sound: sound_effect

    signal music_backgroundPressed
    signal music_effectPressed

    modal: true//是否模态
    anchors.centerIn: parent
    closePolicy: Popup.NoAutoClose//让其不能点击外部退出

    width: 400
    height: 250
//    width: gameWindowAnchorItem.width/2
//    height: gameWindowAnchorItem.height/2

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 ;duration: 1000}
    }

    background: Image {
        id: image_background
        source: "../../assets/img/Background/background_setting_dialog.png"
    }

    Item {//返回按钮
        id:back
        width: 50
        height: 50
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        SpriteSequence {
            anchors.fill: parent
            Sprite{
                frameX: 0;frameY: 0;
                source: "../../assets/img/Lobby/lobby.png"
                frameCount: 1; frameWidth: 92; frameHeight: 92; frameDuration: 0
            }
        }
        MouseAreaBase{
            onClicked: setting.close()
        }
    }

    Row{
        id:row_backmusic
        width: 300
        height: 100
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.verticalCenter
        anchors.bottomMargin: 5
        Text {
            width: 150
            height: 80
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 40
            text: qsTr("游戏音乐")
        }
        Switch{
            width: 100
            height: 80
            id:background_music
            checked: true
            onCheckedChanged: {
                music_backgroundPressed()
            }
        }
    }

    Row{
        id:row_sound_effect
        width: 300
        height: 100
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.verticalCenter
        anchors.topMargin: 5

        Text {
            width: 150
            height: 80
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 40
            text: qsTr("游戏音效")
        }
        Switch{
            width: 100
            height: 80
            id:sound_effect
            checked: true
            onCheckedChanged: {
                music_effectPressed()
            }
        }

    }
}
