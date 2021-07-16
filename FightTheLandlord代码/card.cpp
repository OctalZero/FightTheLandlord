#include "card.h"

Card::Card()
    :m_point{-1}, m_color{-1}
{

}

void Card::setpoint(int point)
{
    m_point = point;
}


int Card::getpoint()
{
    return m_point;
}

void Card::setcolor(int color)
{
    m_color = color;
}

int Card::getcolor()
{
    return m_color;
}

int Card::compare(Card &card1, Card &card2)
{
    if (card1.getpoint() == card2.getpoint()) {
        return 1;
    }else if (card1.getpoint() < card2.getpoint()) {
        return 0;
    }else {
        return -1;
    }
}

int Card::operator==(Card card)
{
    if (this->getpoint() == card.getpoint()) {
        return 1;
    }else {
        return 0;
    }
}

//bool Card::operator ==(Card card)
//{
//    if(this->compare(*this, card)) {
//        return true;
//    }else {
//        return false;
//    }
//}

