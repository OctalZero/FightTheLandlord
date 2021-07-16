import QtQuick 2.0
//这是出牌区域
Item {
    property alias outmodel: outlistview.model//组件的listmodel
    property alias listvieww: outlistview.width//组件的宽度
    property alias listview_visible: outlistview.visible
    property alias outcard_imgae_visible: image.visible

    property alias image_tishi_visible: tishi_image.visible
    property alias image_time_over_visible: time_over_image.visible
    property alias timer_tishi: timer_tishi_me
    //分数显示的属性
    property alias one_score_visible: one_image.visible
    property alias two_score_visible: two_image.visible
    property alias three_score_visible: three_image.visible

    width: 400
    height: 90

    Image{
        id:image
        width: 123
        height: 69
        source: "../../assets/img/Game/buchu.png"
        anchors.centerIn: parent
        visible: false
    }

    Image{
        id:tishi_image
        width: 300
        height: 80
        source: "../../assets/img/Game/tishi.png"
        visible: false
        anchors.centerIn: parent
    }

    Image {
        id: time_over_image
        width: 300
        height: 50
        source: "../../assets/img/Game/timeover.png"
        anchors.centerIn: parent
        visible: false
    }
    Image {
        id: one_image
        width: 100
        height: 37
        source: "../../assets/img/Game/one_score.png"
        anchors.centerIn: parent
        visible: false
    }

    Image {
        id: two_image
        width: 100
        height: 37
        source: "../../assets/img/Game/two_score.png"
        anchors.centerIn: parent
        visible: false
    }

    Image {
        id: three_image
        width: 100
        height: 37
        source: "../../assets/img/Game/three_score.png"
        anchors.centerIn: parent
        visible: false
    }

    Timer{
        id:timer_tishi_me
        interval: 1000
        repeat: false
        running: false
        onTriggered: {
            tishi_image.visible=false
            time_over_image.visible=false
        }
    }
    ListView{
        id:outlistview
        width: 65
        height: 90
        spacing: -45//使它重叠
        visible: false
        orientation: ListView.Horizontal//让它水平
        anchors.centerIn: parent
        interactive:false//让它不能滑动
        ListView.delayRemove:false
        delegate:
            CardIntial{
                Component.onCompleted: {
                    changepai(mark)//改变牌值
                }
            }
    }
}
