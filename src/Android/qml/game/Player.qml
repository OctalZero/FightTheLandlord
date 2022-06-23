import QtQuick 2.0
//这是玩家（包括头像、牌数、地主标记）组件
Item {
    property alias residustext: residus.text//将剩余张数的文本别名
    property alias landlordbrand: landlord_brand//将地主标志引出 让外其更改是否显示地主标志

    property var head_portrait_num: 0
    property var string_head_portraits:[
        {"source":"../../assets/img/Lobby/sunwukong.png"},
        {"source":"../../assets/img/Lobby/zhubajie.png"},
        {"source":"../../assets/img/Lobby/saseng.png"},
        {"source":"../../assets/img/Lobby/tangseng.png"}
    ]
    width: 200
    height: 80
        Image {//头像区域
            width:80
            height: 80
            source: "../../assets/img/Game/frame_player.png"
            Image{
                id:head_portrait
                anchors.fill: parent
                source: string_head_portraits[head_portrait_num].source
            }
        }

        Image {//剩余牌数字
            x: 95
            y: 4
            width: 47
            height: 72
            source: "../../assets/img/Game/back_card.png"
            Text {//显示剩余张数
                id: residus
                anchors.centerIn: parent
                font.pixelSize: 30
                color: "white"
                text: qsTr("17")
            }
        }

        Image {//地主牌
            id:landlord_brand
            x: 160
            y: 2
            width: 34
            height: 76
            visible: false//初始化为不显示
            source: "../../assets/img/Game/flag_lord.png"
        }


}
