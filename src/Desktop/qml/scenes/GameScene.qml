import QtQuick 2.10
import Felgo 3.0
import QtQuick.Controls 2.1
import "../common"
import "../game"
import "../dialogs"
//游戏界面（主要界面）
SceneBase {
    id: gameScene
    width: 960
    height: 640
    signal game_music_backgroundPressed
    signal game_music_effectPressed

    property bool ismusic_effect: true//点击按钮时是否打开音效
    signal readcard
    onReadcard: {
        cards.read_hand_card();
    }
    // 读入手牌
    Connections
    {
        target:client
        onSignalSendCard: {
            cards.read_hand_card();
        }
    }
    // 读取分数
    Connections
    {
        target:client
        onSignalFirstScore: {
            scores_button_true();
        }
    }
    // 显示我是地主
    Connections
    {
        target:client
        onSignalLordIsMe: {
            landLord_Is_Me();
            change_me_card_num();
        }
    }
    // 显示上家是地主
    Connections
    {
        target:client
        onSignalLordIsRight: {
            landLord_Is_Right();
            change_right_card_num();
        }
    }
    // 显示下家是地主
    Connections
    {
        target:client
        onSignalLordIsLeft: {
            landLord_Is_Left();
            change_left_card_num();
        }
    }
    // 显示地主牌
    Connections
    {
        target:client
        onSignalDisplayLandLordCard: {
            landLord_card_display();
            one_score_me_player_false();
            two_score_me_player_false();
            three_score_me_player_false();
            one_score_right_player_false();
            two_score_right_player_false();
            three_score_right_player_false();
            one_score_left_player_false();
            two_score_left_player_false();
            three_score_left_player_false();
        }
    }
    // 显示出牌按钮
    Connections
    {
        target:client
        onSignalOutCardTime: {
            player_self_hide_buchu();
            change_button_out_card_true();
        }
    }
    // 显示单个出牌按钮
    Connections
    {
        target:client
        onSignalOutOneButton: {
            one_button_true();
        }
    }
    // 正确牌型处理
    Connections
    {
        target:client
        onSignalTrueType: {
            client.sendOutCard();
            cards.deletecard();
            outcards_me.listview_visible=true
            if(ismusic_effect){
                sound_effects.music_givecard.play();
            }
            buttons.clock_timer.stop()
            client.checkCardShape();
            client.changeSelfCardNum();
            change_me_card_num();
            change_button_out_card_false();
            one_button_false();
//            client.clearSelfCard(); // 清空检测的牌
            client.checkGameOver(); // 检测游戏结束
        }
    }
    // 错误牌型处理
    Connections
    {
        target:client
        onSignalErrorType: {
            player_me_tishi()//显示选择的牌型为非法牌型提示
            cards.recycle(); // 选择的牌退回底部
            outcards_me.listview_visible=false
//            client.clearSelfCard(); // 清空检测的牌
        }
    }
    // 上家出牌显示
    Connections
    {
        target:client
        onSignalShowRightOutCard: {
            right_player_out_card();
            client.changeRightCardNum();
            change_right_card_num();
            client.clearSelfCard();
            client.clearSelfCardShape();
            change_button_out_card_true();
        }
    }
    // 下家出牌显示
    Connections
    {
        target:client
        onSignalShowLeftOutCard: {
            left_player_out_card();
            client.changeLeftCardNum();
            change_left_card_num();
        }
    }
    // 上家不出显示
    Connections
    {
        target:client
        onSignalShowRightNoOutCard: {
            player_right_show_buchu();
        }
    }
    // 下家不出显示
    Connections
    {
        target:client
        onSignalShowLeftNoOutCard: {
            player_left_show_buchu()
        }
    }
    // 上家叫一分显示
    Connections
    {
        target:client
        onSignalShowRightOneScore: {
            one_score_right_player_true()
            if(ismusic_effect){
                sound_effects.music_one_score.play()
            }
        }
    }
    // 上家叫两分显示
    Connections
    {
        target:client
        onSignalShowRightTwoScore: {
            two_score_right_player_true()
            if(ismusic_effect){
                sound_effects.music_two_score.play()
            }
        }
    }
    // 上家叫三分显示
    Connections
    {
        target:client
        onSignalShowRightThreeScore: {
            three_score_right_player_true()
            if(ismusic_effect){
                sound_effects.music_three_score.play()
            }
        }
    }
    // 下家叫一分显示
    Connections
    {
        target:client
        onSignalShowLeftOneScore: {
            one_score_left_player_true()
            if(ismusic_effect){
                sound_effects.music_one_score.play()
            }
        }
    }
    // 下家叫两分显示
    Connections
    {
        target:client
        onSignalShowLeftTwoScore: {
            two_score_left_player_true()
            if(ismusic_effect){
                sound_effects.music_two_score.play()
            }
        }
    }
    // 下家叫三分显示
    Connections
    {
        target:client
        onSignalShowLeftThreeScore: {
            three_score_left_player_true()
            if(ismusic_effect){
                sound_effects.music_three_score.play()
            }
        }
    }
    // 孙悟空头像
    Connections
    {
        target:client
        onSignalSelfIsSun: {
            head_portrait_player_me_is_sun()
        }
    }
    // 猪八戒头像
    Connections
    {
        target:client
        onSignalSelfIsZhu: {
            head_portrait_player_me_is_zhu()
        }
    }
    // 沙僧头像
    Connections
    {
        target:client
        onSignalSelfIsSha: {
            head_portrait_player_me_is_sha()
        }
    }
    // 地主游戏获胜
    Connections
    {
        target:client
        onSignalLordWinGame: {
            resultdialog_people(2)
        }
    }
    // 地主游戏失败
    Connections
    {
        target:client
        onSignalLordLossGame: {
            resultdialog_people(3)
        }
    }
    // 农民游戏获胜
    Connections
    {
        target:client
        onSignalFarmerWinGame: {
            resultdialog_people(0)
        }
    }
    // 农民游戏失败
    Connections
    {
        target:client
        onSignalFarmerLossGame: {
            resultdialog_people(1)
        }
    }
    // 玩家中途退出
    Connections
    {
        target:client
        onSignalOtherLeaveGame: {
            quit_midway()
        }
    }
    // 炸弹特效
    Connections
    {
        target:client
        onSignalBombCardShape: {
            function_special(2)
        }
    }
    // 王炸特效
    Connections
    {
        target:client
        onSignalBombKingCardShape: {
            function_special(1)
        }
    }
    // 连对特效
    Connections
    {
        target:client
        onSignalDoubleLineCardShape: {
            function_special(3)
        }
    }
    // 飞机特效
    Connections
    {
        target:client
        onSignalPlaneCard: {
            function_special(4)
        }
    }
    //以下是功能函数及接口.....................................................................
    //函数如何使用：改变每个函数的nums数组 就可以显示对应的牌
    //以下接口是（左侧玩家出牌区域、右侧玩家出牌区域、地主牌区域）

    function read_leftplayer_card(){
        var nums=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]//把数据传给这个数组
        leftplayer_listmodel.clear()//先将listmodle清除数据
        for(var i=0;i<nums.length;i++){//将数组的数据传入相应区域的中转listmdoel
            leftplayer_listmodel.append({"mark":nums[i]})
        }
        outcards_left.listview_visible=true
        outcards_left.outmodel=leftplayer_listmodel//将中转listmodel赋值给显示的listmodel就可以实现显示
    }

    function read_rightplayer_card(){
        var nums=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]//把数据传给这个数组
        rightplayer_listmodel.clear()
        for(var i=0;i<nums.length;i++){
            rightplayer_listmodel.append({"mark":nums[i]})
        }
        outcards_right.listview_visible=true
        outcards_right.outmodel=rightplayer_listmodel
    }

    function read_landlordarea_card(){
        var nums=[7,8,9]//把数据传给这个数组
        landlordarea_listmodel.clear()
        for(var i=0;i<nums.length;i++){
            landlordarea_listmodel.append({"mark":nums[i]})
        }

        landlorearea.landlordareamodel=landlordarea_listmodel
    }

    // 自己是地主
    function landLord_Is_Me(){
        player_me.landlordbrand.visible=true
    }
    // 上家是地主
    function landLord_Is_Right(){
        player_right.landlordbrand.visible=true
    }
    // 下家是地主
    function landLord_Is_Left(){
        player_left.landlordbrand.visible=true
    }
    // 显示地主牌
    function landLord_card_display(){
        var nums = client.getLandLordCard()
        landlordarea_listmodel.clear()
        for(var i=0;i<nums.length;i++){
            landlordarea_listmodel.append({"mark":nums[i]})
        }
        landlorearea.landlordareamodel=landlordarea_listmodel
        landlorearea.changeCardstate()
    }
    // 更改自己牌数
    function change_me_card_num(){
        var num = client.getMeCardNum();
        player_me.residustext=num
    }
    // 更改上家牌数
    function change_right_card_num(){
        var num = client.getRightCardNum();
        player_right.residustext=num
    }
    // 更改下家牌数
    function change_left_card_num(){
        var num = client.getLeftCardNum();
        player_left.residustext=num
    }
    // 出牌按钮显示
    function change_button_out_card_true(){
        buttons.out_card_row_visivle=true
        buttons.clock_timer_num=20
        buttons.clock_timer.start()
    }
    // 出牌按钮消失
    function change_button_out_card_false(){
        buttons.out_card_row_visivle=false
    }
    // 检查出牌合法
    function check_out_cards(){
        cards.find_card();
        client.checkOutCard();
    }
    // 不出牌
    function no_out_cards(){
        player_self_show_buchu();
        client.noOutCard();
        change_button_out_card_false();
    }
    // 上家出牌显示
    function right_player_out_card(){
        var nums=client.getRightOutCard()
        rightplayer_listmodel.clear()
        for(var i=0;i<nums.length;i++){
            rightplayer_listmodel.append({"mark":nums[i]})
        }
        outcards_right.listview_visible=true
        outcards_right.outcard_imgae_visible=false
        outcards_right.outmodel=rightplayer_listmodel
    }
    // 下家出牌显示
    function left_player_out_card(){
        var nums=client.getLeftOutCard()
        leftplayer_listmodel.clear()
        for(var i=0;i<nums.length;i++){
            leftplayer_listmodel.append({"mark":nums[i]})
        }
        outcards_left.listview_visible=true
        outcards_left.outcard_imgae_visible=false
        outcards_left.outmodel=leftplayer_listmodel
    }
    // 自己显示不出
    function player_self_show_buchu(){
        outcards_me.listview_visible=false
        outcards_me.outcard_imgae_visible=true
        if(ismusic_effect){
            sound_effects.music_buyao_play()
        }
    }
    // 自己不出消失
    function player_self_hide_buchu(){
        outcards_me.listview_visible=false
        outcards_me.outcard_imgae_visible=false
    }
    // 上家显示不出
    function player_right_show_buchu(){
        outcards_right.listview_visible=false
        outcards_right.outcard_imgae_visible=true
        if(ismusic_effect){
            sound_effects.music_buyao_play()
        }
    }
    // 下家显示不出
    function player_left_show_buchu(){
        outcards_left.listview_visible=false
        outcards_left.outcard_imgae_visible=true
        if(ismusic_effect){
            sound_effects.music_buyao_play()
        }
    }
    // 牌型错误提示
    function player_me_tishi(){
        cards.image_tishi_visible=true
        cards.timer_tishi.start()
    }
    // 显示仅有一个显示按钮
    function one_button_true(){
        buttons.one_button_visible=true
    }
    // 消失仅有一个显示按钮
    function one_button_false(){
        buttons.one_button_visible=false
    }
    // 叫分显示
    function scores_button_true(){
        buttons.scores_button_visible=true
    }
    // 叫分消失
    function scores_button_false(){
        buttons.scores_button_visible=false
    }
    // 读取叫分
    function scores_button_score(){
        var num=0;
        num=arguments[0];
        client.setCallScore(num);
        client.sendScore();
        client.judgeLandLord();
    }
    //左侧玩家的叫分分数显示
    function one_score_left_player_true(){
        outcards_left.one_score_visible=true
    }

    function one_score_left_player_false(){
        outcards_left.one_score_visible=false
    }

    function two_score_left_player_true(){
        outcards_left.two_score_visible=true
    }

    function two_score_left_player_false(){
        outcards_left.two_score_visible=false
    }

    function three_score_left_player_true(){
        outcards_left.three_score_visible=true
    }

    function three_score_left_player_false(){
        outcards_left.three_score_visible=false
    }
    //右侧玩家的叫分分数显示
    function one_score_right_player_true(){
        outcards_right.one_score_visible=true
    }

    function one_score_right_player_false(){
        outcards_right.one_score_visible=false
    }

    function two_score_right_player_true(){
        outcards_right.two_score_visible=true
    }

    function two_score_right_player_false(){
        outcards_right.two_score_visible=false
    }

    function three_score_right_player_true(){
        outcards_right.three_score_visible=true
    }

    function three_score_right_player_false(){
        outcards_right.three_score_visible=false
    }
    //自己的叫分分数显示
    function one_score_me_player_true(){
        outcards_me.one_score_visible=true
    }

    function one_score_me_player_false(){
        outcards_me.one_score_visible=false
    }

    function two_score_me_player_true(){
        outcards_me.two_score_visible=true
    }

    function two_score_me_player_false(){
        outcards_me.two_score_visible=false
    }

    function three_score_me_player_true(){
        outcards_me.three_score_visible=true
    }

    function three_score_me_player_false(){
        outcards_me.three_score_visible=false
    }
    // 孙悟空头像
    function head_portrait_player_me_is_sun(){
        player_me.head_portrait_num=0
        player_left.head_portrait_num=1
        player_right.head_portrait_num=2
    }
    // 猪八戒头像
    function head_portrait_player_me_is_zhu(){
        player_me.head_portrait_num=1
        player_left.head_portrait_num=2
        player_right.head_portrait_num=0
    }
    // 沙僧头像
    function head_portrait_player_me_is_sha(){
        player_me.head_portrait_num=2
        player_left.head_portrait_num=0
        player_right.head_portrait_num=1
    }
    // 获胜框开启新游戏
    function game_win(){
        resultdialog.win_or_loss_num=0
        resultdialog.open()
    }
    // 失败框
    function game_loss(){
        resultdialog.win_or_loss_num=1
        resultdialog.open()
    }

    ListModel{
        id:clear_listmodel
    }
    ListModel{
        id:listmodel_clear_landlord
        ListElement{
            mark:"1"
        }
        ListElement{
            mark:"1"
        }
        ListElement{
            mark:"1"
        }
    }

    function game_clear(){
        //将牌全部清除
        //landlordarea_listmodel.clear()
        leftplayer_listmodel.clear()
        rightplayer_listmodel.clear()
        cards.melistmodel.clear()


        //将地主牌消失
        player_me.landlordbrand.visible=false
        player_left.landlordbrand.visible=false
        player_right.landlordbrand.visible=false

        //将头像初始化
        player_me.head_portrait_num=0
        player_left.head_portrait_num=0
        player_right.head_portrait_num=0

        //将出牌区域初始化
        outcards_me.one_score_visible=false
        outcards_left.one_score_visible=false
        outcards_right.one_score_visible=false

        outcards_me.two_score_visible=false
        outcards_left.two_score_visible=false
        outcards_right.two_score_visible=false

        outcards_me.three_score_visible=false
        outcards_left.three_score_visible=false
        outcards_right.three_score_visible=false

        outcards_me.listview_visible=false
        outcards_left.listview_visible=false
        outcards_right.listview_visible=false

        outcards_me.outcard_imgae_visible=false
        outcards_left.outcard_imgae_visible=false
        outcards_right.outcard_imgae_visible=false

        outcards_me.outmodel=clear_listmodel
        outcards_left.outmodel=clear_listmodel
        outcards_right.outmodel=clear_listmodel

        buttons.out_card_row_visivle=false
        buttons.one_button_visible=false
        buttons.scores_button_visible=false

        player_me.residustext=17
        player_left.residustext=17
        player_right.residustext=17

        landlorearea.landlordareamodel=listmodel_clear_landlord
        //landlorearea.changeCardstate()

    }
    // 游戏结束
    function game_over(){
        backButtonPressed()
        game_clear()
        sence.overGame()
        sence.newGame()
    }
    //中途有人退出
    function quit_midway(){
        game_over()
    }
    // 特效显示
    function function_special(){
        var num=arguments[0]
        special_effects.special_now=num
        special_effects.visible=true
        special_effects.function_special_effects()
        if(ismusic_effect){
            sound_effects.function_sound_effects(num)
        }
        special_effects_timer.start()
    }
    // 游戏结束显示
    function resultdialog_people(){
        var num=arguments[0]
        resultdialog.win_or_loss_people=num
        if(num%2===0){
            resultdialog.win_or_loss_num=0
        }else{
            resultdialog.win_or_loss_num=1
        }
        resultdialog.open()
    }

    Timer{
        id:special_effects_timer
        interval: 2000
        running: false
        repeat: false
        onTriggered: {
            special_effects.visible=false
        }
    }

    //特效
    Special_effects{
        id:special_effects
        z:10
    }

    Sound_effects{
        id:sound_effects
    }

    //下面是背景图片、退出按钮和设置按钮.........................................................

    Image {//背景图片
        id: gamebackground
        anchors.fill: parent.gameWindowAnchorItem
        source: "../../assets/img/Background/background_game.jpg"
    }

    Image {
        id: gamebackground_logo
        anchors.centerIn: parent
        width: gameScene.gameWindowAnchorItem.width*2/3
        height: gameScene.gameWindowAnchorItem.height*2/3
        source: "../../assets/img/Background/background_game_logo.png"
    }

    Image {//离开按钮
        id:back
        width: 50
        height: 50
        anchors.top: gameScene.gameWindowAnchorItem.top
        anchors.topMargin: 10
        anchors.right: player_right.left
        anchors.rightMargin: 10
        source: "../../assets/img/Game/button_exit.png"
        MouseAreaBase{
            onClicked: {
                client.sendLeaveGame()
                backButtonPressed()
                game_over_timer.start()
            }
        }
    }

    Timer{
        id:game_over_timer
        interval: 3000
        repeat: false
        running: false
        onTriggered:{
            game_clear()
            sence.overGame()
            sence.newGame()
        }
    }

    Image{//设置按钮
        id:set
        width: 50
        height: 50
        anchors.left: player_left.right
        anchors.leftMargin: 10
        anchors.top: gameScene.gameWindowAnchorItem.top
        anchors.topMargin: 10
        source: "../../assets/img/Game/button_setting.png"
        MouseAreaBase{
            onClicked: settingdialog.open()
        }
    }

    //下面是三个玩家（玩家头像、玩家剩余牌数、玩家是否是地主）..............................................
    Player {
        id: player_left
        anchors.left: gameScene.gameWindowAnchorItem.left
        anchors.leftMargin: 10
        anchors.top: gameScene.gameWindowAnchorItem.top
        anchors.topMargin: 10
        width: 200
        height: 80
    }
    Player {
        id: player_right
        anchors.right: gameScene.gameWindowAnchorItem.right
        anchors.rightMargin: 10
        anchors.top: gameScene.gameWindowAnchorItem.top
        anchors.topMargin: 10
        width: 200
        height: 80
    }
    Player {
        id: player_me
        anchors.left: gameScene.gameWindowAnchorItem.left
        anchors.leftMargin: 10
        anchors.bottom: gameScene.gameWindowAnchorItem.bottom
        anchors.bottomMargin: 260
        width: 200
        height: 80
    }
    //以下是主要的界面（包含全部显示牌的区域、按钮）...............................................................


    LandlordArea{//地主牌区域 上方的中间区域
        id:landlorearea
        anchors.horizontalCenter: gameScene.gameWindowAnchorItem.horizontalCenter
        anchors.top: gameScene.gameWindowAnchorItem.top
        anchors.topMargin: 10
        height: 90
        width: 200
    }

    OutCards{//自己出牌区域  正中间区域
        id:outcards_me
        anchors.horizontalCenter: gameScene.gameWindowAnchorItem.horizontalCenter
        anchors.bottom: playgame.top
        anchors.bottomMargin: 10
        width: 445
        height: 90
        outmodel:cards.outlistmodel
        listvieww: 65+cards.outlistmodel.count*20//使它居中
    }

    OutCards{//左侧玩家出牌区域
        id:outcards_left
        anchors.left: gameScene.gameWindowAnchorItem.left
        anchors.leftMargin: 10
        anchors.top: player_left.bottom
        anchors.topMargin: 10
        listvieww: 445
        width: 445
        height: 90
    }

    OutCards{//右侧玩家出牌区域
        id:outcards_right
        anchors.right: gameScene.gameWindowAnchorItem.right
        anchors.top: player_right.bottom
        anchors.topMargin: 10
        listvieww: 445
        width: 445
        height: 90
    }

    Item{//手牌区域和按钮区域
        id:playgame
        anchors.bottom: gameScene.gameWindowAnchorItem.bottom
        anchors.bottomMargin: 60
        anchors.horizontalCenter: gameScene.gameWindowAnchorItem.horizontalCenter
        width: 910
        height: 260
        Buttons{
            id:buttons
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 10
            width: 450
            height: 50
            onOutcardPressed: { // 出牌按钮
                check_out_cards() // 出牌的操作
                outcards_me.outcard_imgae_visible=false
            }
            onIncardPressed: { // 不出按钮
                cards.recycle() // 退回牌
                client.noOutCard() // 不出的操作
                player_self_show_buchu() // 自己区域显示不出
                change_button_out_card_false() // 出牌按钮消失
                if(ismusic_effect){
                    sound_effects.music_click.play()
                }
            }
            onOne_score: { // 一分按钮
                client.addCallScoreNum()
                scores_button_false()
                one_score_me_player_true()
                scores_button_score(1)
                if(ismusic_effect){
                    sound_effects.music_one_score.play()
                }
            }
            onTwo_score: { // 二分按钮
                client.addCallScoreNum()
                scores_button_false()
                two_score_me_player_true()
                scores_button_score(2)
                sound_effects.music_two_score
            }
            onThree_score: {// 三分按钮
                client.addCallScoreNum()
                scores_button_false()
                three_score_me_player_true()
                scores_button_score(3)
                if(ismusic_effect){
                    sound_effects.music_three_score.play()
                }
            }
            onTishiPressed: {
                outcards_me.image_tishi_visible=true
                outcards_me.timer_tishi.start()
            }
            onTime_overPressed: {
                outcards_me.image_time_over_visible=true
                outcards_me.timer_tishi.start()
            }
        }

        Cards{
            id:cards
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            width: 910
            height: 190
            listvieww: 123+melistmodel.count*41//使它居中
        }
    }
    // 对话框退出
    ResultDialog{
        id:resultdialog
        width: 450
        height: 250
        onQuit_game: {
            backButtonPressed()
            resultdialog.close()
            game_clear()

            sence.overGame() // 结束游戏
            sence.newGame() // 开启新游戏
        }
    }
    SettingDialog{
        id:settingdialog
        width: 400
        height: 250
        onMusic_backgroundPressed:{
            game_music_backgroundPressed()
        }
        onMusic_effectPressed: {
            game_music_effectPressed()
        }
    }

    //以下是出牌区域的listmodel................................................................
    //地主牌区域
    ListModel{
        id:landlordarea_listmodel
    }
    //左侧玩家出牌区域
    ListModel{
        id:leftplayer_listmodel
    }
    //右侧玩家出牌区域
    ListModel{
        id:rightplayer_listmodel
    }

    //下面都是测试按钮和区域.....................................................................

//    Rectangle{//对话框测试
//        id:dialog_test
//        x:837
//        y:546
//        width: 100
//        height: 40
//        Text {
//            anchors.fill: parent
//            text: qsTr("对话框测试")
//            anchors.rightMargin: 0
//            anchors.bottomMargin: 0
//            anchors.leftMargin: 0
//            anchors.topMargin: 0
//        }
//        MouseAreaBase{
//            onClicked: {
//                //function_special(3)
//                resultdialog.open()
//            }
//        }
//    }

}


