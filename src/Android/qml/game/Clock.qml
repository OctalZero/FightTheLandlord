import QtQuick 2.0

Item {
    property alias timer_clock: timer
    property var timer_num: 10
    signal timeroverPressed
    width: 50
    height: 50
    Image{
        anchors.fill: parent
        source: "../../assets/img/Game/timer.png"
    }
    Text {
        id: text
        font.pixelSize: 30
        anchors.centerIn: parent
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
