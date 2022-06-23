import QtQuick 2.0
import Felgo 3.0
Item {
    width: 600
    height: 100
    property alias text_playname: playname.text
    property alias text_basicscore: basic_score.text
    property alias text_multiple: multiple.text
    property alias text_beans: beans.text
    Row{
        Text {
            id: playname
            width: 150
            height: 100
            font.pixelSize:90
            text: qsTr("zxd")
        }
        Text {
            id: basic_score
            width: 150
            height: 100
            font.pixelSize: 90
            text: qsTr("10")
        }
        Text {
            id: multiple
            width: 150
            height: 100
            font.pixelSize: 90
            text: qsTr("10")
        }
        Text {
            id: beans
            width: 150
            height: 100
            font.pixelSize: 90
            text: qsTr("1000")
        }
    }
}
