import QtQuick 2.15

Item {
    width: 960
    height: 640
    anchors.centerIn: parent
    visible: false
    property var special_now: 0
    property var special_name: [
        {"name":chuntian},
        {"name":zhadan},
        {"name":zhadan},
        {"name":liandui},
        {"name":feiji},
        {"name":shunzi},
        {"name":baojing}
    ]
    function function_special_effects(){
        special_name[special_now].name.visible=true
        anim.start()
        timer.start()
    }
    Timer{
        id:timer
        interval: 3000
        running: false
        repeat: false
        onTriggered: special_name[special_now].name.visible=false
    }
    SequentialAnimation{
        id:anim
        //PropertyAnimation{target: chuntian; property: "y"; from:400;to:10; duration: 500}
        //PropertyAnimation{target: wangzha; property: "y"; from:400;to:10; duration: 500}
        //PropertyAnimation{target: baojing; property: "y";from:400; to:10; duration: 500}
        //PropertyAnimation{target: zhadan; property: "y"; from:400;to:10; duration: 500}
        //PropertyAnimation{target: liandui; property: "y";from:400; to:10; duration: 500}
        PropertyAnimation{target: feiji; property: "y"; from:400;to:10; duration: 500}
        //PropertyAnimation{target: shunzi; property: "y"; from:400;to:10; duration: 500}
//        PropertyAnimation{target: image; property: "x"; to:10; duration: 500}
    }

    SpriteSequence{
        id: chuntian
        visible: false
        width: 200; height: 200;
        anchors.centerIn: parent
        Sprite{
            name: "chuntian"; source: "../../assets/img/Special_effects/chuntian.png"
            frameCount: 27; frameWidth: 344; frameHeight: 312;
            frameDuration: 100;
        }
    }
    SpriteSequence{
        id: wangzha
        visible: false
        width: 200; height: 200;
        anchors.centerIn: parent
        Sprite{
            name: "wangzha"; source: "../../assets/img/Special_effects/wangzha.png"
            frameCount: 8; frameWidth: 109; frameHeight: 184;
            frameDuration: 200;
        }
    }
    SpriteSequence{
        id: baojing
        visible: false
        width: 200; height: 200;
        anchors.centerIn: parent
        Sprite{
            name: "baojing"; source: "../../assets/img/Special_effects/baojing.png"
            frameCount: 2;frameWidth: 44;frameHeight: 44;
            frameDuration: 70;
            frameRate: 20
            frameDurationVariation: 1
        }
    }
    SpriteSequence{
        id: zhadan
        visible: false
        width: 200; height: 200;
       anchors.centerIn: parent
        Sprite{
            name: "zhadan"; source: "../../assets/img/Special_effects/zhadan.png"
            frameCount: 11; frameWidth: 335; frameHeight: 294;
            frameDuration: 70
        }
    }
    SpriteSequence{
        id: liandui
        visible: false
        width: 200; height: 200;
        anchors.centerIn: parent
          Sprite{
              name: "liandui"; source: "../../assets/img/Special_effects/liandui.png"
              frameCount: 10; frameWidth: 350; frameHeight: 224;
              frameDuration: 100
          }
    }
    SpriteSequence{
        id: feiji
        visible: false
        width: 200; height: 200;
        anchors.centerIn: parent
        Sprite{
            name: "feiji"; source: "../../assets/img/Special_effects/feiji.png"
            frameCount: 8; frameWidth: 180; frameHeight: 118;
            frameDuration: 100
        }
    }
    SpriteSequence{
        id: shunzi
        visible: false
        width: 200; height: 200;
        anchors.centerIn: parent
        Sprite{
            name: "shunzi"; source: "../../assets/img/Special_effects/shunzi.png";
            frameCount: 8; frameWidth:81; frameHeight: 36;
            frameDuration: 100
        }
    }
}
