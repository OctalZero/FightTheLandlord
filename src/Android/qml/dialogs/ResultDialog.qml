import QtQuick 2.0
import QtQuick.Controls 2.12
import Felgo 3.0
import "../Test"
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
        {"source":"../../assets/img/Dialog/farmer1_loss.png"},
        {"source":"../../assets/img/Dialog/owner1_win.png"},
        {"source":"../../assets/img/Dialog/owner1_loss.png"}
    ]
    modal: true//是否模态
    anchors.centerIn: parent
    closePolicy: Popup.NoAutoClose//让其不能点击外部退出

    width: gameWindowAnchorItem.width*2/3
    height: gameWindowAnchorItem.height*2/3


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
        source: "../../assets/img/Background/background_result_dialog.jpg"
    }


    contentItem: Item{
        id:content_item
        anchors.fill: dialog_result
        Image{
            id:image_win_loss
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 30
            width: 300
            height: 100
            visible: true
            source: string_win_loss[win_or_loss_num].source
        }
        Image{
            id:people_win_or_loss
            source: string_peoples[win_or_loss_people].source
            anchors.top: image_win_loss.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            width: 435
            height: 352
        }

        Image {
            width: 155
            height: 75
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            source: "../../assets/img/Game/button_buchu.png"
            MouseAreaBase{
                onClicked: {

                    quit_game()
                }

            }
        }
//        ListModel{
//            id:listmodel
//            ListElement{
//                player_name:"zxd"
//                basic_score:"10"
//                multiple:"10"
//                beans:"1000"
//            }
//            ListElement{
//                player_name:"xfd"
//                basic_score:"10"
//                multiple:"10"
//                beans:"1000"
//            }
//            ListElement{
//                player_name:"zcr"
//                basic_score:"10"
//                multiple:"10"
//                beans:"1000"
//            }
//        }

//        ListView{
//            id:listview

//            anchors.centerIn: parent
//            width: 600
//            height: 300
//            model:listmodel
//            delegate: ResultPlayer{
//                text_playname:player_name
//                text_basicscore:basic_score
//                text_multiple:multiple
//                text_beans:beans
//            }
//        }
//        Text {
//            id: text_message
//            width: 300
//            height: 100
//            anchors.horizontalCenter: parent.horizontalCenter
//            anchors.bottom: parent.bottom
//            anchors.bottomMargin: 30
//            color: "blue"
//            font.pixelSize: 50
//            text: qsTr("点击外部继续～～～")
//        }
    }

}
