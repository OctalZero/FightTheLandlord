import Felgo 3.0
import QtQuick 2.10
import QtQuick.Controls 2.12
import QtMultimedia 5.14
import "../common"
import "../dialogs"

//这是大厅界面
SceneBase {
    id: lobbyScene

    //3个按钮的信号..................................................................

    signal gamePressed
    signal creationPressed
    signal joinPressed

    property bool ismusic_effect: true//点击按钮时是否打开音效

    //音效创建......................................................................
    MediaPlayer {//点击音效
        id: clickMusic
        source: "../../assets/sound/Special_menu.ogg"
    }

    // 背景图片....................................................................
    Image {
        anchors.fill: parent.gameWindowAnchorItem// 全屏
        source: "../../assets/img/Background/background_lobby.png"
    }

    //人物图片.......................................................................

    Image {
        id:image_role

        //定位在左上角
        anchors.left: parent.gameWindowAnchorItem.left
        anchors.leftMargin: 10
        anchors.top: parent.gameWindowAnchorItem.top
        anchors.topMargin: 10

        width: 260
        height: 290
        SpriteSequence {
            anchors.fill: parent
            Sprite{
                frameX: 0;frameY: 92;
                source: "../../assets/img/Lobby/lobby.png"
                frameCount: 1; frameWidth: 512; frameHeight: 512; frameDuration: 0
            }
        }
    }

    // 返回按钮..................................................................

    Item {
        id:button_back
        width: 35
        height: 35
        //定位右上角
        anchors.right: lobbyScene.gameWindowAnchorItem.right
        anchors.rightMargin: 10
        anchors.top: lobbyScene.gameWindowAnchorItem.top
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

    //选择什么模式...........................................................

    //创建房间按钮..........................................................
    Item {
        id:button_create

        //定位在返回按钮的下方60px
        anchors.right: lobbyScene.gameWindowAnchorItem.right
        anchors.rightMargin: 10
        anchors.top:button_back.bottom
        anchors.topMargin: 60

        width: 240
        height: 50
        MouseAreaBase{
            onClicked: {
                creationPressed()
                    if(ismusic_effect)
                clickMusic.play()
            }
        }
        SpriteSequence {
            anchors.fill: parent
            Sprite{
                frameX: 281;frameY: 0;
                source: "../../assets/img/Lobby/lobby.png"
                frameCount: 1; frameWidth: 189; frameHeight: 48; frameDuration: 0
            }
        }
        Text {
            anchors.centerIn: parent
            text: "创建房间"
        }
    }
    //加入房间按钮.................................................................
    Item {
        id:button_join

        //定位在创建按钮的正下方20px
        anchors.right: lobbyScene.gameWindowAnchorItem.right
        anchors.rightMargin: 10
        anchors.top: button_create.bottom
        anchors.topMargin: 20

        width: 240
        height: 50
        MouseAreaBase{
            onClicked: {
                joinPressed()
                if(ismusic_effect)
                    clickMusic.play()
            }

        }
        SpriteSequence {
            anchors.fill: parent
            Sprite{
                frameX: 281;frameY: 0;
                source: "../../assets/img/Lobby/lobby.png"
                frameCount: 1; frameWidth: 189; frameHeight: 48; frameDuration: 0
            }
        }
        Text {
            anchors.centerIn: parent
            text: "进入房间"
        }
    }

    //人机模式.....................................................................
    Item {
        id:button_machine

        //定位在加入房间的正下方20px
        anchors.right: lobbyScene.gameWindowAnchorItem.right
        anchors.rightMargin: 10
        anchors.top: button_join.bottom
        anchors.topMargin: 20

        y: 220
        width: 240
        height: 50
        MouseAreaBase{
            onClicked: {
                man_machinedialog.open()
                //gamePressed()
                if(ismusic_effect)
                    clickMusic.play()
            }
        }
        SpriteSequence {
            anchors.fill: parent
            Sprite{
                frameX: 281;frameY: 0;
                source: "../../assets/img/Lobby/lobby.png"
                frameCount: 1; frameWidth: 189; frameHeight: 48; frameDuration: 0
            }
        }
        Text {
            anchors.centerIn: parent
            text: "人机模式"
        }
    }
    Man_machineDialog{
        id:man_machinedialog
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
