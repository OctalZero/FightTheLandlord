import QtQuick 2.0
//这只是一张普通的牌 有正反面的状态
Item {
    width: 65
    height: 90
    state:"front"

    //存储精灵表单的信息
    property var marks: [
        {"x":0,"y":0,"w":110,"h":150},
        {"x":110,"y":0,"w":110,"h":150},
        {"x":220,"y":0,"w":110,"h":150},
        {"x":330,"y":0,"w":110,"h":150},
        {"x":440,"y":0,"w":110,"h":150},
        {"x":550,"y":0,"w":110,"h":150},
        {"x":660,"y":0,"w":110,"h":150},
        {"x":770,"y":0,"w":110,"h":150},
        {"x":880,"y":0,"w":110,"h":150},
        {"x":990,"y":0,"w":110,"h":150},
        {"x":1100,"y":0,"w":110,"h":150},
        {"x":1210,"y":0,"w":110,"h":150},
        {"x":1320,"y":0,"w":110,"h":150},
        {"x":1430,"y":0,"w":110,"h":150},
        {"x":1540,"y":0,"w":110,"h":150},
        {"x":1650,"y":0,"w":110,"h":150},
        {"x":1760,"y":0,"w":110,"h":150},
        {"x":1870,"y":0,"w":110,"h":150},
        {"x":0,"y":150,"w":110,"h":150},
        {"x":110,"y":150,"w":110,"h":150},
        {"x":220,"y":150,"w":110,"h":150},
        {"x":330,"y":150,"w":110,"h":150},
        {"x":440,"y":150,"w":110,"h":150},
        {"x":550,"y":150,"w":110,"h":150},
        {"x":660,"y":150,"w":110,"h":150},
        {"x":770,"y":150,"w":110,"h":150},
        {"x":880,"y":150,"w":110,"h":150},
        {"x":990,"y":150,"w":110,"h":150},
        {"x":1100,"y":150,"w":110,"h":150},
        {"x":1210,"y":150,"w":110,"h":150},
        {"x":1320,"y":150,"w":110,"h":150},
        {"x":1430,"y":150,"w":110,"h":150},
        {"x":1540,"y":150,"w":110,"h":150},
        {"x":1650,"y":150,"w":110,"h":150},
        {"x":1760,"y":150,"w":110,"h":150},
        {"x":1870,"y":150,"w":110,"h":150},
        {"x":0,"y":300,"w":110,"h":150},
        {"x":110,"y":300,"w":110,"h":150},
        {"x":220,"y":300,"w":110,"h":150},
        {"x":330,"y":300,"w":110,"h":150},
        {"x":440,"y":300,"w":110,"h":150},
        {"x":550,"y":300,"w":110,"h":150},
        {"x":660,"y":300,"w":110,"h":150},
        {"x":770,"y":300,"w":110,"h":150},
        {"x":880,"y":300,"w":110,"h":150},
        {"x":990,"y":300,"w":110,"h":150},
        {"x":1100,"y":300,"w":110,"h":150},
        {"x":1210,"y":300,"w":110,"h":150},
        {"x":1320,"y":300,"w":110,"h":150},
        {"x":1430,"y":300,"w":110,"h":150},
        {"x":1540,"y":300,"w":110,"h":150},
        {"x":1650,"y":300,"w":110,"h":150},
        {"x":1760,"y":300,"w":110,"h":150},
        {"x":1870,"y":300,"w":110,"h":150},
    ]

    function changepai(){
        sprite.frameX=marks[arguments[0]-1].x
        sprite.frameY=marks[arguments[0]-1].y
        sprite.frameWidth=marks[arguments[0]-1].w
        sprite.frameHeight=marks[arguments[0]-1].h
    }

    //牌的正面
    Item{
        id:image_front
        width: 65
        height: 90
        SpriteSequence {
            anchors.fill: parent
            Sprite{
                id:sprite
                frameX: 0;frameY: 0;
                source: "../../assets/img/Game/cards.png"
                frameCount: 1; frameWidth: 110; frameHeight: 150; frameDuration: 0
            }
        }
    }

    //牌的背面
    Image {
        anchors.fill:parent
        id: image_back
        source: "../../assets/img/Game/back_card.png"
    }

    //牌正面和背面的状态
    states:[
        State{
            name:"front"
            PropertyChanges{
                target: image_front
                visible:true
            }
            PropertyChanges{
                target: image_back
                visible:false
            }
        },
        State{
            name:"back"
            PropertyChanges{
                target: image_front
                visible:false
            }
            PropertyChanges{
                target: image_back
                visible:true
            }
        }
    ]
    //转换动画
    transitions: Transition {
        RotationAnimation { properties: "visible"; duration: 500}
    }

}
