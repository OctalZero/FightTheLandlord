import Felgo 3.0
import QtQuick 2.0

Scene {
    id: sceneBase

    // 默认情况下，将“不透明度”（opacity）设置为0-这将从带有PropertyChanges的main.qml更改
    opacity: 0
    // 如果不透明度为0，我们将visible属性设置为false，因为渲染器跳过不可见项，这是一种性能改进
    visible: opacity > 0
    // 如果场景不可见，我们就禁用它。在qt5中，如果组件不可见，也会启用它们。这意味着即使我们隐藏场景，场景中的任何MouseArea仍将处于活动状态，因为我们不希望发生这种情况，因此如果场景被隐藏，我们将禁用该场景（以及它的子对象）
    enabled: visible

    // 不透明度的每一个变化都将通过动画来完成
    Behavior on opacity {
        NumberAnimation {property: "opacity"; easing.type: Easing.InOutQuad}
    }

}
