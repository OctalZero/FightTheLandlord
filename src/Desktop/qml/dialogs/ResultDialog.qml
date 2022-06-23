import QtQuick 2.0
import QtQuick.Controls 2.12
import Felgo 3.0
import "../common"
Popup{
    id: dialog_result

    signal quit_game
    property var win_or_loss_num: 0
    property var string_win_loss:[
        {"source":"../../assets/img/Dialog/result_win.png"},
        {"source":"../../assets/img/Dialog/result_lose.png"}
    ]
    property var win_or_loss_people:0
    property var string_peoples: [
        {"source":"../../assets/img/Dialog/farmer1_win.png"},
        {"source":"../../assets/img/Dialog/farmer1_lose.png"},
        {"source":"../../assets/img/Dialog/owner1_win.png"},
        {"source":"../../assets/img/Dialog/owner1_lose.png"}
    ]
    modal: true//是否模态
    anchors.centerIn: parent
    closePolicy: Popup.NoAutoClose//让其不能点击外部退出

    //width: gameWindowAnchorItem.width*2/3
    //height: gameWindowAnchorItem.height*2/3


    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 ;duration: 1000}
    }
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 ;duration: 1000 }
    }

    //背景图片
    background:
        Image {
        id: image_background
        anchors.fill: parent
        source: "../../assets/img/Background/result.jpg"
    }


    contentItem: Item{
        id:content_item
        anchors.fill: parent
        Image{
            id:image_win_loss
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 5
            width: 300
            height: 90
            visible: true
            source: string_win_loss[win_or_loss_num].source
        }
        Image{
            id:people_win_or_loss
            source: string_peoples[win_or_loss_people].source
            anchors.top: image_win_loss.bottom
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            width: 100
            height: 90
        }

        Image {
            width: 155
            height: 50
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            source: "../../assets/img/Dialog/button_back_lobby.png"
            MouseAreaBase{
                onClicked: {
                    quit_game()
                }

            }
        }
    }

}
