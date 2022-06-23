#ifndef CARD_H
#define CARD_H

class Card
{
public:
    Card();
    void setpoint(int point);
    int getpoint();
    void setcolor(int color);
    int getcolor();
    int compare(Card &card1, Card &card2);
    int operator==(Card card);

private:
    int m_point;
    int m_color;
};

#endif // CARD_H
