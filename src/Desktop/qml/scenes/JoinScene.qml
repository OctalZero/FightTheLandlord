import QtQuick 2.0
import QtQuick 2.12
import Felgo 3.0
import QtQuick.Controls 2.12
import QtMultimedia 5.14
import QtQuick.Layouts 1.2
import "../common"
import "../dialogs"
SceneBase {
    id:joinScene

    signal gamePressed
    property alias wait_dialog: dialog_wait
    property bool ismusic_effect: true//点击按钮时是否打开音效
    width: 960
    height: 640
    // 读取IP地址
    function changeIp(){
        client.setCip(textedit_iptext.text);
    }
    // 读取端口
    function changePort(){
        var t = parseInt(textedit_porttext.text);
        client.setCport(t);
    }
    // 连入客户端
    function link(){
        client.link()
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
        id: image_background
        anchors.fill: parent.gameWindowAnchorItem
        source: "../../assets/img/Background/background_join.png"
    }
    //音效创建......................................................................

    MediaPlayer {
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
        width: 520
        height: 60

        //定位
        anchors.horizontalCenter: parent.gameWindowAnchorItem.horizontalCenter
        anchors.bottom: row_port.top
        anchors.bottomMargin: 90
        Label {
            id: label_ip
            width: 150
            height: 57
            font.pointSize: 40
            text: qsTr("    IP:")
        }

        TextEdit {
            id: textedit_iptext
            width: 370
            height: 57
            font.pointSize: 40
            text: qsTr("")

        }
    }


    Row{
        id:row_port
        width: 520
        height: 60

        //定位
        anchors.horizontalCenter: parent.gameWindowAnchorItem.horizontalCenter
        anchors.bottom: button_play.top
        anchors.bottomMargin: 90

        Label {
            id: label_port
            width: 150
            height: 57
            font.pointSize: 40
            text: qsTr("端口:")

        }

        TextEdit {
            id: textedit_porttext
            width: 370
            height: 57
            font.pointSize: 40
            text: qsTr("")

        }
    }

    Image {
        id:button_play

        //定位在返回按钮的下方60px
        anchors.horizontalCenter: parent.gameWindowAnchorItem.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 90
        width: 450
        height: 150
        source: "../../assets/img/Creation/button_joingame.png"
        MouseAreaBase{
            onClicked: {
                if(ismusic_effect)
                    clickMusic.play()
                dialog_wait.open()
                changeIp();
                changePort();
                link();

            }
        }

        Text {
            anchors.centerIn: parent
            font.pointSize: 30
            text: "加入游戏"
            color: "white"
        }
    }

    WaitDialog{//等待dialog
        id:dialog_wait
        width: 100
        height: 100
    }
}


