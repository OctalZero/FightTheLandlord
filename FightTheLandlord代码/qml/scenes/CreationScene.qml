import QtQuick 2.0
import QtQuick 2.12
import Felgo 3.0
import QtQuick.Controls 2.12
import QtMultimedia 5.14
import QtQuick.Layouts 1.2
import "../common"
import "../dialogs"
SceneBase {
    id:creationScene

    signal gamePressed
    property bool ismusic_effect: true//点击按钮时是否打开音效
    width: 960
    height: 640

    // 读入IP地址
    function changeIp(){
        label_iptext.text= server.ip;
    }
    // 读入端口
    function changePort(){
        label_porttext.text= server.port;
    }
    // 切换为游戏界面
    Connections
    {
        target:client
        onSignalStartGame: {
            gamePressed()
        }
    }

    //背景图片..................................................
    Image {
        id: image
        anchors.fill: parent.gameWindowAnchorItem
        source: "../../assets/img/Background/background_join.png"
    }

    //音效创建......................................................................
    MediaPlayer {//点击音效
        id: clickMusic
        source: "../../assets/sound/Special_menu.ogg"
    }

    //返回按钮
    Item {
        id:button_back
        width: 50
        height: 50

        //定位右上角
        anchors.right: parent.gameWindowAnchorItem.right
        anchors.rightMargin: 10
        anchors.top: parent.gameWindowAnchorItem.top
        anchors.topMargin: 10
        //点击（触发音效和返回信号）
        MouseAreaBase{
            onClicked: {
                if(ismusic_effect)
                    clickMusic.play()
                backButtonPressed()
            }
        }
        //图片
        SpriteSequence {
            anchors.fill: parent
            Sprite{
                frameX: 0;frameY: 0;
                source: "../../assets/img/Lobby/lobby.png"
                frameCount: 1; frameWidth: 92; frameHeight: 92; frameDuration: 0
            }
        }
    }
    Row{
        id:row_ip

        x: 185
        y: 157
        width: 520
        height: 60

        //定位


        Label {
            id: label_ip
            width: 120
            height: 57
            font.pointSize: 40
            text: qsTr("    IP:")
        }

        Label {
            id: label_iptext
            width: 400
            height: 57
            font.pointSize: 40
            text: qsTr("")

        }
    }


    Row{
        id:row_port

        x: 202
        y: 300
        width: 520
        height: 60

        //定位


        Label {
            id: label_port
            width: 120
            height: 57
            font.pointSize: 40
            text: qsTr("端口:")

        }

        Label {
            id: label_porttext
            width: 400
            height: 57
            font.pointSize: 40
            text: qsTr("")

        }
    }
}


