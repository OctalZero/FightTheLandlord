import Felgo 3.0
import QtQuick 2.0
import "scenes"
import QtMultimedia 5.14
GameWindow {
    id: window
    screenWidth: 960
    screenHeight: 640

    //暂时不用
    // create and remove entities at runtime
//    EntityManager {
//        id: entityManager
//    }

    //首先把所有界面先创建

    //音效创建.............................................................
    MediaPlayer {//游戏背景音乐
        id: music_background
        source: "../assets/sound/music_background.ogg"
        loops: MediaPlayer.Infinite //一直循环
    }

    // 欢迎界面............................................................
    WelcomeScene {
        id: welcomeScene

        onLobbyPressed: window.state = "lobby"//点击转换为大厅界面
    }

    // 大厅界面............................................................
    LobbyScene {
        id: lobbyScene

        onGamePressed: window.state = "game" // 点击进入游戏界面

        onCreationPressed : {
            sence.newServer()
            creationScene.changeIp()
            creationScene.changePort()
            window.state="creation"//点击进入创建游戏界面
        }
        onJoinPressed: window.state="join"//点击进入加入游戏界面


        onBackButtonPressed: window.state = "welcome"//返回按钮
    }

    //游戏界面.............................................................
    GameScene {
        id: gameScene
        onBackButtonPressed: {

            window.state = "lobby"//点击返回大厅界面
        }

        onGame_music_backgroundPressed: {//切换背景音乐
            if(music_background.playbackState===1){
                music_background.pause()
            }else{
                music_background.play()
            }
        }

        onGame_music_effectPressed: {//切换点击按钮音乐
            if(ismusic_effect===true){
                ismusic_effect=false
                welcomeScene.ismusic_effect=false
                lobbyScene.ismusic_effect=false
                creationScene.ismusic_effect=false
                joinScene.ismusic_effect=false
            }else{
                ismusic_effect=true
                welcomeScene.ismusic_effect=true
                lobbyScene.ismusic_effect=true
                creationScene.ismusic_effect=true
                joinScene.ismusic_effect=true
            }
        }
    }

    //创建游戏界面.......................................................
    CreationScene{
        id:creationScene
        onGamePressed: window.state="game"//点击进入加入游戏界面

        onBackButtonPressed: window.state = "welcome"//返回按钮
    }


    //加入游戏界面.......................................................
    JoinScene{
        id:joinScene
        onGamePressed: {
            wait_dialog.close()
            window.state="game"//点击进入加入游戏界面
        }

        onBackButtonPressed: window.state = "welcome"//返回按钮
    }

    //初始化为欢迎界面...................................................
    state: "welcome"
    activeScene: welcomeScene

    // 保存所有界面的状态...............................................
    // 状态机在更改状态时会注意反转属性更改，例如将不透明度更改回0
    states: [
        State {
            name: "welcome"
            PropertyChanges {target: welcomeScene; opacity: 1}
            PropertyChanges {target: window; activeScene: welcomeScene}
        },
        State {
            name: "lobby"
            PropertyChanges {target: lobbyScene; opacity: 1}
            PropertyChanges {target: window; activeScene: lobbyScene}
        },
        State {
            name: "game"
            PropertyChanges {target: gameScene; opacity: 1}
            PropertyChanges {target: window; activeScene: gameScene}
        },
        State {
            name: "creation"
            PropertyChanges {target: creationScene; opacity: 1}
            PropertyChanges {target: window; activeScene: creationScene}
        },
        State {
            name: "join"
            PropertyChanges {target: joinScene; opacity: 1}
            PropertyChanges {target: window; activeScene: joinScene}
        }
    ]

    //在加载完界面 开始播放音乐
    Component.onCompleted: {
        music_background.play()
    }
}
