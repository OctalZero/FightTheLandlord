import QtQuick 2.0

Item {
    property alias timer_clock: timer
    property var timer_num: 20
    signal timeroverPressed
    width: 60
    height: 60
    Image{
        anchors.fill: parent
        source: "../../assets/img/Game/timer.png"
    }
    Text {
        id: text
        font.pixelSize: 30
        //anchors.centerIn: parent
        y:15
        anchors.horizontalCenter: parent.horizontalCenter
        text: timer_num
    }
    Timer{
        id:timer
        interval: 1000
        repeat: true
        running: false
        onTriggered: {
            timer_num--
            if(timer_num<=0){
                timeroverPressed()
                timer.stop()
            }
        }
    }
}
