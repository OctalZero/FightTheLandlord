import QtQuick 2.0
import QtMultimedia 5.14
Item {
    property alias music_givecard: music_give
    function function_sound_effects(){
        var num=arguments[0]
        if(num===0){
            chuntian.play()
        }
        if(num===1){
            wangzha.play()
        }
        if(num===2){
            zhadan.play()
        }
        if(num===3){
            liandui.play()
        }
        if(num===4){
            feiji.play()
        }
        if(num===5){
            shunzi.play()
        }
    }

    //音效创建......................................................................
    MediaPlayer {//点击音效
        id: clickMusic
        source: "../../assets/sound/Special_menu.ogg"
    }
    MediaPlayer {//点击音效
        id: music_give
        source: "../../assets/sound/Special_give.ogg"
    }
    MediaPlayer {//点击音效
        id: chuntian
        source: "../../assets/sound/music_chuntian.ogg"
    }
    MediaPlayer {//点击音效
        id: zhadan
        source: "../../assets/sound/musci_zhadan.ogg"
    }
    MediaPlayer {//点击音效
        id: wangzha
        source: "../../assets/sound/Man_wangzha.ogg"
    }
    MediaPlayer {//点击音效
        id: liandui
        source: "../../assets/sound/music_liandui.ogg"
    }
    MediaPlayer {//点击音效
        id: feiji
        source: "../../assets/sound/music_feiji.ogg"
    }
    MediaPlayer {//点击音效
        id: shunzi
        source: "../../assets/sound/music_shunzi.ogg"
    }

}
