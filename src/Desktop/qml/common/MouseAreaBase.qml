import QtQuick 2.0
//此鼠标区域可以按下时半透明 释放时显示
MouseArea{
    anchors.fill: parent
    //按下时的样式
    onPressed:parent.opacity = 0.5
    //释放时的样式
    onReleased: parent.opacity = 1
}
