import QtQuick 2.15
import "../common"
Item {
    property alias mouseareaoutcard: mousearea_out_card.enabled
    property alias buttonoutcard: button_out_card.visible
    property alias out_card_row_visivle: three.visible
    property alias one_button_visible: button_out_card_one.visible
    property alias scores_button_visible: two.visible
    property alias clock_timer: clock.timer_clock
    property alias clock_timer_num: clock.timer_num

    width: 450
    height: 50
    signal outcardPressed//出牌信号
    signal incardPressed//不出牌信号
    signal tishiPressed
    signal time_overPressed

    signal one_score
    signal two_score
    signal three_score
    Image{//出牌按钮
        id:button_out_card_one
        width: 100
        height: 50
        visible: false
        anchors.centerIn: parent
        source: "../../assets/img/Game/button_chupai.png"
        MouseAreaBase{
            onClicked:{
                console.log("出牌")
                outcardPressed()
            }
        }
    }

    Row{
        id:two
        padding: 10
        visible: false
        anchors.fill: parent
        Image {
            width: 100
            height: 50
            source: "../../assets/img/Game/button_one_score.png"
            MouseAreaBase{
                onClicked: {
                    one_score()
                }
            }
        }
        Image {
            width: 100
            height: 50
            source: "../../assets/img/Game/button_two_score.png"
            MouseAreaBase{
                onClicked: {
                    two_score()
                }
            }
        }
        Image {
            width: 100
            height: 50
            source: "../../assets/img/Game/button_three_score.png"
            MouseAreaBase{
                onClicked: {
                    three_score()
                }
            }
        }
    }

    Row{
        id:three
        padding:10
        visible: false
        anchors.fill: parent
        Image{
            width: 100
            height: 50
            source: "../../assets/img/Game/button_buchu.png"
            MouseAreaBase{
                onClicked: {
                    clock.timer_clock.stop()
                    incardPressed()
                }
            }
        }
        Clock{
            id:clock
            onTimeroverPressed: {
                time_overPressed()
            }
        }

        Image{
            width: 100
            height: 50
            source: "../../assets/img/Game/button_tishi.png"
            MouseAreaBase{
                id:mousearea_tishi
                onClicked:{
                    tishiPressed()
                }
            }
        }
        Image{//出牌按钮
            id:button_out_card
            width: 100
            height: 50
            source: "../../assets/img/Game/button_chupai.png"
            MouseAreaBase{
                id:mousearea_out_card
                onClicked:{
                    outcardPressed()
                }
            }
        }
    }
}
