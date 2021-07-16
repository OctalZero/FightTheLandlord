import QtQuick 2.15
//这是一张带有mousearea的牌 有选取和未选取的状态
Item {
    width: 123
    height: 190
    //保存所有的牌的位置
    property alias imagestate: image.state
    property alias mymousearea: mousearea//将mousearea的属性在外部改变

    property var marks: [//存储每张牌对应的精灵表
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

    //根据给的mark改变对应牌的界面
    function changepai(){
        sprite.frameX=marks[arguments[0]-1].x
        sprite.frameY=marks[arguments[0]-1].y
        sprite.frameWidth=marks[arguments[0]-1].w
        sprite.frameHeight=marks[arguments[0]-1].h
    }
    //牌的主体
    Item {
        id:image
        width: 123
        height: 170
        state: "in"
        MouseArea{//实现多选
            id:mousearea
            width: 41
            height: 170
            anchors.left: parent.left
            hoverEnabled: true
            //单选
            onClicked: {
                image.state==="in"?image.state="out":image.state="in"
            }

            //实现多选
//            onExited: {
//                parent.enabled=false
//                parent.enabled=true
//            }
//            onEntered: {
//                image.state==="in"?image.state="out":image.state="in"
//            }
        }

        SpriteSequence {
            anchors.fill: parent
            Sprite{
                id:sprite
                frameX: 0;frameY: 0;
                source: "../../assets/img/Game/cards.png"
                frameCount: 1; frameWidth: 110; frameHeight: 150; frameDuration: 0
            }
        }
        //两种状态 选取和未选取
        states:[
            State{
                name:"out"
                AnchorChanges{
                    target: image
                    anchors.bottom: undefined
                    anchors.top:parent.top
                }
            },
            State{
                name:"in"
                AnchorChanges{
                    target: image
                    anchors.top: undefined
                    anchors.bottom:parent.bottom
                }
            }
        ]

    }

}
