#include "changingcolor.hpp"

ChangingColor::ChangingColor(QObject *parent) :
    QObject(parent), iColor(Qt::darkGreen)
{
  startTimer(3000);
}

void ChangingColor::setRandomColor()
{
  QColor c(qrand() % 256, // r
	   qrand() % 256, // g
	   qrand() % 256, // b
	   qrand() % 256); // alpha
  setColor(c);
}

void ChangingColor::timerEvent(QTimerEvent *event)
{
  Q_UNUSED(event);
  setRandomColor();
}
