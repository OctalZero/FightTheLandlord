import Felgo 3.0
import QtQuick 2.15
import "../common"
import QtMultimedia 5.14

//这是欢迎界面的场景
SceneBase {
    id: welcomeScene

    //进入大厅的信号..............................................................
    signal lobbyPressed

    property bool ismusic_effect: true//点击按钮时是否打开音效

    //音效创建...................................................................
    MediaPlayer {//点击的音效
        id: clickMusic
        source: "../../assets/sound/Special_menu.ogg"
    }

    // 背景图片.................................................................
    Image {
        anchors.fill: parent.gameWindowAnchorItem
        source: "../../assets/img/Background/background_welcome.png"
    }

    // 元气斗地主logo图片...........................................................
    Item{
        x:120
        y:50
        width: 200
        height: 100
        SpriteSequence {
            anchors.fill: parent
            Sprite{
                frameX: 0;frameY: 114;
                source: "../../assets/img/Welcome/welcome.png"
                frameCount: 1; frameWidth: 416; frameHeight: 148; frameDuration: 0
            }
        }
    }

    //进入游戏图片...................................................................
    Item{
        anchors.centerIn: parent.gameWindowAnchorItem
        height: 52
        anchors.verticalCenterOffset: 81
        anchors.horizontalCenterOffset: 0
        width:182
        SpriteSequence {
            anchors.fill: parent
            Sprite{
                frameX: 0;
                frameY: 0;
                source: "../../assets/img/Welcome/welcome.png"
                frameCount: 1; frameWidth: 355; frameHeight: 114; frameDuration: 0
            }
        }
        MouseAreaBase{
            onClicked: {
                lobbyPressed()
                if(ismusic_effect)
                    clickMusic.play()
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
