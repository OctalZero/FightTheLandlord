import QtQuick 2.0
import QtMultimedia 5.14
Item {
    property alias music_givecard: music_give
    property alias music_click: clickMusic
    property alias music_one_score: one_score
    property alias music_two_score: two_score
    property alias music_three_score: three_score

    property var music_buyao_nums: [
        {"source":"../../assets/sound/Man_buyao1.ogg"},
        {"source":"../../assets/sound/Man_buyao2.ogg"},
        {"source":"../../assets/sound/Man_buyao3.ogg"},
        {"source":"../../assets/sound/Man_buyao4.ogg"},
    ]

    property var music_buyao_now: 0
    function music_buyao_play(){
        music_buyao_now++
        buyao.play()
    }

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
    MediaPlayer {
        id: clickMusic
        source: "../../assets/sound/Special_menu.ogg"
    }
    MediaPlayer {
        id: music_give
        source: "../../assets/sound/Special_give.ogg"
    }
    MediaPlayer {
        id: chuntian
        source: "../../assets/sound/music_chuntian.ogg"
    }
    MediaPlayer {
        id: zhadan
        source: "../../assets/sound/musci_zhadan.ogg"
    }
    MediaPlayer {
        id: wangzha
        source: "../../assets/sound/Man_wangzha.ogg"
    }
    MediaPlayer {
        id: liandui
        source: "../../assets/sound/music_liandui.ogg"
    }
    MediaPlayer {
        id: feiji
        source: "../../assets/sound/music_feiji.ogg"
    }
    MediaPlayer {
        id: shunzi
        source: "../../assets/sound/music_shunzi.ogg"
    }
    MediaPlayer {
        id: one_score
        source: "../../assets/sound/1fen.mp3"
    }
    MediaPlayer {
        id: two_score
        source: "../../assets/sound/2fen.mp3"
    }
    MediaPlayer {
        id: three_score
        source: "../../assets/sound/3fen.mp3"
    }
    MediaPlayer {
        id: buyao
        source: music_buyao_nums[music_buyao_now%4].source
    }
}
