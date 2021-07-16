#include <iterator>
#include <functional>
#include <utility>
#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include <map>
#include <vector>
#include "playercardpool.h"
#include <QJsonValue>
#include <QJsonValueRef>
#include <QJsonObject>
#include <QJsonArray>
#include <QList>
#include <QVariant>


int cmp_second(const PAIR& x, const PAIR& y)//针对PAIR的比较函数
{
    return x.second > y.second;  //从大到小
}

int cmp_first(const PAIR& x, const PAIR& y)//针对PAIR的比较函数
{
    return x.first > y.first;  //从大到小
}

Card transToCard(int card_num)
{
    int color = (card_num / 13) +1;
    int num = card_num % 13;
    Card card;
    card.setpoint(num);
    card.setcolor(color);
    if (card_num == 53){
        num = 16;
        color = 4;
        card.setpoint(num);
        card.setcolor(color);
    }else if (card_num == 54) {
        num = 17;
        color = 4;
        card.setpoint(num);
        card.setcolor(color);
    }
    return card;
}

std::vector<PAIR> sortCard(QVector<Card> vec)
{
    const int size = vec.count();
    int item[size], num[size];
    int count = 0, flag;
    for (int i = 0; i < size; i++) {
        item[i] = 0;
        num[i] = 0;
    }
    for(int i = 0; i < size; i++) {
        flag = 0;
        for(int j = 0; j < count; j++) {
            if (vec[i].getpoint() == item[j]) {
                num[j]++;
                flag = 1;
            }
        }
        if (flag == 0) {
            item[count] = vec[i].getpoint();
            num[count]++;
            count++;
        }
    }
    std::map<int, int> map;
    for (int i = 0; i < count; i++) {
        map[item[i]] = num[i];
    }
    std::vector<PAIR> name_score_vec(map.begin(), map.end());
    sort(name_score_vec.begin(), name_score_vec.end(), cmp_second);
    return name_score_vec;
}

CardShape PlayerCardPool::JudgeCard(QVector<Card> player)
{
    CardShape return_shape;
    std::vector<PAIR> card_vector = sortCard(player);
    // 添加main和add
    return_shape.main = card_vector[0].second;
    std::vector<PAIR>::iterator g = card_vector.end(); g--;
    if (!(return_shape.main == g->second)) {  // add大小不可能和main相同
        return_shape.add = g->second;
    }else {
        return_shape.add = 0;
    }
    // 分装main和add牌
    std::vector<PAIR> main_vec, add_vec;
    int series = 0;
    for(std::vector<PAIR>::iterator g = card_vector.begin(); g < card_vector.end(); g++) { // 算Series
        if (g->second == return_shape.main) {
            PAIR k{*g};
            series += 1;
            main_vec.push_back(k);
        }else if (g->second == return_shape.add){
            PAIR k{*g};
            add_vec.push_back(k);
        }else {
            return_shape.Type = ErrorCard;
            return return_shape;
        }
    }
    return_shape.series = series;
    return_shape.main_num = main_vec[0].first;
    auto sr{main_vec.begin()};
    for (;sr != main_vec.end();sr++) {
        if (sr->first == 2) {
            return_shape.main_num = 2;
            break;
        } else if (sr->first == 1) {
            return_shape.main_num = 1;
            break;
        } else if (sr->first == 0) {
            return_shape.main_num = 0;
            break;
        }
    }
    sort(main_vec.begin(), main_vec.end(), cmp_first);
//    return_shape.main_num = main_vec[0].first; // 写入main_num
    if ((return_shape.main == 1) && (return_shape.series == 1)) {
        return_shape.Type = SigleCard;
        return return_shape;
    }else if ((return_shape.main == 2) && (return_shape.series == 1) && (return_shape.add == 0)) {
        return_shape.Type = DoubleCard;
        return return_shape;
    }else if ((return_shape.main == 3) && (return_shape.add == 1) && (return_shape.series == 1) && (add_vec.size() == 1)) {
        return_shape.Type = ThreeWithOneCard;
        return return_shape;
    }else if ((return_shape.main == 3) && (return_shape.add == 2) && (return_shape.series == 1) && (add_vec.size() == 1)) {
        return_shape.Type = ThreeWithTwoCard;
        return return_shape;
    }else if ((return_shape.main == 3) && (return_shape.series == 1) && (add_vec.size() == 0)) {
        return_shape.Type = ThreeCard;
        return return_shape;
    }else if ((return_shape.main == 1) && (add_vec.size() == 0) && (return_shape.series >= 5)) {
        std::vector<PAIR>::iterator g = main_vec.end();
        g--;
        if (g->first == 0) { // 判断带A的顺子
            g--;
            main_vec.pop_back();
            if (g->first == 1) {
                main_vec.pop_back();
            }
        }
        for(std::vector<PAIR>::iterator p = main_vec.begin(); p < main_vec.end(); p++){
            if (p != main_vec.end()){
                PAIR g = *p;
                p++;
                if (p == main_vec.end()) {
                    return_shape.Type = LineCard;
                    return return_shape;
                }
                if ((g.first-1) != (p->first)){
                    return_shape.Type = ErrorCard;
                    return return_shape;
                }
                p--;
            }
        }
    }else if ((return_shape.main == 2) && (add_vec.size() == 0) && (return_shape.series >= 3)) {
        std::vector<PAIR>::iterator g = main_vec.end();
        g--;
        if (g->first == 1) { // 判断带A的连对
            main_vec.pop_back();
        }
        for(std::vector<PAIR>::iterator p = main_vec.begin(); p < main_vec.end(); p++){
            if (p != main_vec.end()){
                PAIR g = *p;
                p++;
                if (p == main_vec.end()) {
                    return_shape.Type = DoubleLineCard;
                    return return_shape;
                }
                if ((g.first-1) != (p->first)){
                    return_shape.Type = ErrorCard;
                    return return_shape;
                }
                p--;
            }
        }
    }else if ((return_shape.main == 3) && (add_vec.size() == 0) && (series >= 2)) {
        std::vector<PAIR>::iterator g = main_vec.end();
        g--;
        if (g->first == 1) { // 判断带A的飞机
            main_vec.pop_back();
        }
        for(std::vector<PAIR>::iterator p = main_vec.begin(); p < main_vec.end(); p++){
            if (p != main_vec.end()){
                PAIR g = *p;
                p++;
                if (p == main_vec.end()) {
                    return_shape.Type = PlaneCard;
                    return return_shape;
                }
                if ((g.first-1) != (p->first)){
                    return_shape.Type = ErrorCard;
                    return return_shape;
                }
                p--;
            }
        }
    }else if ((return_shape.main == 3) && (return_shape.add == 1) && (series >= 2)) {
        if (main_vec.size() != add_vec.size()){
            return_shape.Type = ErrorCard;
            return return_shape;
        }
        std::vector<PAIR>::iterator g = main_vec.end();
        g--;
        if (g->first == 1) { // 判断带A的飞机
            main_vec.pop_back();
        }
        for(std::vector<PAIR>::iterator p = main_vec.begin(); p < main_vec.end(); p++){
            if (p != main_vec.end()){
                PAIR g = *p;
                p++;
                if (p == main_vec.end()) {
                    return_shape.Type = PlaneWithOneCard;
                    return return_shape;
                }
                if ((g.first-1) != (p->first)){
                    return_shape.Type = ErrorCard;
                    return return_shape;
                }
                p--;
            }
        }
    }else if ((return_shape.main == 3) && (return_shape.add == 2) && (series >= 2)) {
        if (main_vec.size() != add_vec.size()){
            return_shape.Type = ErrorCard;
            return return_shape;
        }
        std::vector<PAIR>::iterator g = main_vec.end();
        g--;
        if (g->first == 1) { // 判断带A的飞机
            main_vec.pop_back();
        }
        for(std::vector<PAIR>::iterator p = main_vec.begin(); p < main_vec.end(); p++){
            if (p != main_vec.end()){
                PAIR g = *p;
                p++;
                if (p == main_vec.end()) {
                    return_shape.Type = PlaneWithTwoCard;
                    return return_shape;
                }
                if ((g.first-1) != (p->first)){
                    return_shape.Type = ErrorCard;
                    return return_shape;
                }
                p--;
            }
        }
    }else if ((return_shape.main == 4) && (return_shape.add == 0) && (return_shape.series == 1)) {
        return_shape.Type = BombCard;
        return return_shape;
    }else if ((return_shape.main == 4) && (return_shape.add == 1) && (return_shape.series == 1) && (add_vec.size() == 2)) {
        return_shape.Type = FourWithTwoSingleCard;
        return return_shape;
    }else if ((return_shape.main == 4) && (return_shape.add == 2) && (return_shape.series == 1) && (add_vec.size() == 1)) {
        return_shape.Type = FourWithTwoSingleCard;
        return return_shape;
    }else if ((return_shape.main == 4) && (return_shape.add == 2) && (return_shape.series == 1) && (add_vec.size() == 2)) {
        return_shape.Type = FourWithTwoDoubleCard;
        return return_shape;
    }else if ((return_shape.main == 1) && (return_shape.add == 0) && (return_shape.series == 2)) {
        if ((main_vec.begin()->first == 17) && (main_vec[1].first == 16)) {
            return_shape.Type = BombKingCard;
            return return_shape;
        }else {
            return_shape.Type = ErrorCard;
            return return_shape;
        }
        return_shape.Type = ErrorCard;
        return return_shape;
    }else if ((return_shape.main == 4) && (return_shape.add == 0) && (return_shape.series >= 2)) {
        std::vector<PAIR>::iterator g = main_vec.end();
        g--;
        if (g->first == 1) { // 判断带A的飞机
            main_vec.pop_back();
        }
        for(std::vector<PAIR>::iterator p = main_vec.begin(); p < main_vec.end(); p++){
            if (p != main_vec.end()){
                PAIR g = *p;
                p++;
                if (p == main_vec.end()) {
                    return_shape.Type = PlaneWithOneCard;
                    return return_shape;
                }
                if ((g.first-1) != (p->first)){
                    return_shape.Type = ErrorCard;
                    return return_shape;
                }
                p--;
            }
        }
    }
    return_shape.Type = ErrorCard;
    return return_shape;
}

CardShape PlayerCardPool::JudgeSelfCard()
{
    return JudgeCard(_player_2_round);
}


bool PlayerCardPool::compareRightCards()
{
    if(_player_1_round.count() == 0) return false;
    QVector<Card> copy_vector1{_player_1_round};
    CardShape copy1{JudgeCard(copy_vector1)};
    _play_1_shape.add = copy1.add;
    _play_1_shape.Type = copy1.Type;
    _play_1_shape.main = copy1.main;
    _play_1_shape.series = copy1.series;
    _play_1_shape.main_num = copy1.main_num;

    QVector<Card> copy_vector2{_player_2_round};
    CardShape copy2{JudgeCard(copy_vector2)};
    _play_2_shape.add = copy2.add;
    _play_2_shape.Type = copy2.Type;
    _play_2_shape.main = copy2.main;
    _play_2_shape.series = copy2.series;
    _play_2_shape.main_num = copy2.main_num;

    if ((_play_2_shape.Type == BombCard) && (_play_2_shape.Type != _play_1_shape.Type)) {
        return true;
    }
    if (_play_2_shape.Type == BombKingCard)
        return true;
    if (_play_1_shape.main_num == 1 || _play_1_shape.main_num == 2 || _play_1_shape.main_num == 0) {
        _play_1_shape.main_num += 13;
    }
    if (_play_2_shape.main_num == 1 || _play_2_shape.main_num == 2 || _play_2_shape.main_num == 0) {
        _play_2_shape.main_num += 13;
    }
    if ((_play_2_shape.Type != _play_1_shape.Type) || (_play_2_shape.series != _play_1_shape.series)) {
        return false;
    }else {
        return (_play_2_shape.main_num > _play_1_shape.main_num);
    }
}

bool PlayerCardPool::compareLeftCards()
{
    if(_player_3_round.count() == 0) return false;
    QVector<Card> copy_vector3{_player_3_round};
    CardShape copy3{JudgeCard(copy_vector3)};
    _play_3_shape.add = copy3.add;
    _play_3_shape.Type = copy3.Type;
    _play_3_shape.main = copy3.main;
    _play_3_shape.series = copy3.series;
    _play_3_shape.main_num = copy3.main_num;

    QVector<Card> copy_vector2{_player_2_round};
    CardShape copy2{JudgeCard(copy_vector2)};
    _play_2_shape.add = copy2.add;
    _play_2_shape.Type = copy2.Type;
    _play_2_shape.main = copy2.main;
    _play_2_shape.series = copy2.series;
    _play_2_shape.main_num = copy2.main_num;

    if ((_play_2_shape.Type == BombCard) && (_play_2_shape.Type != _play_3_shape.Type)) {
        return true;
    }
    if (_play_2_shape.Type == BombKingCard)
        return true;
    if (_play_3_shape.main_num == 1 || _play_3_shape.main_num == 2 || _play_3_shape.main_num == 0) {
        _play_3_shape.main_num += 13;
    }
    if (_play_2_shape.main_num == 1 || _play_2_shape.main_num == 2 || _play_2_shape.main_num == 0) {
        _play_2_shape.main_num += 13;
    }
    if ((_play_2_shape.Type != _play_3_shape.Type) || (_play_2_shape.series != _play_3_shape.series)) {
        return false;
    }else {
        return (_play_2_shape.main_num > _play_3_shape.main_num);
    }
}

void PlayerCardPool::setSelfRound(QList<QVariant> nums)
{
    if(_player_2_round.count() != 0) _player_2_round.clear();
    for (QVariant g:nums){
        Card card{transToCard(g.toInt())};
        _player_2_round.append(card);
    }
}

void PlayerCardPool::setRightRound(QList<QVariant> nums)
{
    if(_player_1_round.count() != 0) _player_1_round.clear();
    for (QVariant g:nums){
        Card card = transToCard(g.toInt());
        _player_1_round.append(card);
    }
}

void PlayerCardPool::setLeftRound(QList<QVariant> nums)
{
    if(_player_3_round.count() != 0) _player_3_round.clear();
    for (QVariant g:nums){
        Card card = transToCard(g.toInt());
        _player_3_round.append(card);
    }
}

void PlayerCardPool::setPtrRound(QJsonObject &json)
{
    if (json.contains(QStringLiteral("card"))) {
        QJsonValueRef val = json["card"];
        QJsonArray arr{val.toArray()};
        for (QJsonArray::iterator g = arr.begin(); g < arr.end(); g++){
            Card card =  transToCard(g->toInt());
            _player_1_round.append(card);
        }
    }
    if (json.contains(QStringLiteral("main"))) {
        QJsonValueRef val =  json["main"];
        _play_1_shape.main = val.toInt();
    }
    if (json.contains(QStringLiteral("add"))) {
        QJsonValueRef val =  json["add"];
        _play_1_shape.add = val.toInt();
    }
    if (json.contains(QStringLiteral("main_num"))) {
        QJsonValueRef val =  json["main_num"];
        _play_1_shape.add = val.toInt();
    }
    if (json.contains(QStringLiteral("series"))) {
        QJsonValueRef val =  json["series"];
        _play_1_shape.add = val.toInt();
    }
}

void PlayerCardPool::setOutCard(QVector<int> outcard)
{
    if(m_outCard.count() != 0) m_outCard.clear();
    for (int g:outcard){
        m_outCard.append(g);
    }
}

void PlayerCardPool::clearSelfCard()
{
    if(m_outCard.count() != 0) m_outCard.clear();
    if(_player_2_round.count() != 0) _player_2_round.clear();
}

void PlayerCardPool::clearSelfCardShape()
{
    if(_player_2_round.count() != 0)
        _player_2_round.clear();
}

void PlayerCardPool::clearRightCardShape()
{
    if(_player_1_round.count() != 0)
        _player_1_round.clear();
}

void PlayerCardPool::clearLeftCardShape()
{
    if(_player_3_round.count() != 0)
        _player_3_round.clear();
}

CardShape PlayerCardPool::getPlay_2_Shape()
{
    return _play_2_shape;
}

QVector<Card> PlayerCardPool::player_2_round()
{
    return _player_2_round;
}

QVector<int> PlayerCardPool::getOutCard()
{

    return m_outCard;
}
