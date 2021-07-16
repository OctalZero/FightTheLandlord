#ifndef REQUEST_H
#define REQUEST_H

typedef enum {
    BeginGame,      // 开始游戏
    CallScore,      // 叫分
    OutCard,        // 出牌
    NoOutCard,      // 不出
    LeaveGame,      // 离开游戏
}RequestTypes;

//typedef enum{
//    GameStart,      // 游戏开始
//    GameOver        // 游戏结束
//}GameState;
#endif // REQUEST_H
