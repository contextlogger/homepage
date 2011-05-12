#ifndef CHANGINGCOLOR_HPP
#define CHANGINGCOLOR_HPP

#include <QColor>
#include <QObject>
#include <QString>

class ChangingColor : public QObject
{
  Q_OBJECT
  Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged)
private:
  QColor iColor;
public:
  explicit ChangingColor(QObject *parent = 0);
  QColor color() const { return iColor; }
  void setColor(const QColor& c) {
    if (c != iColor)
    { iColor = c; emit colorChanged(); }
  }
  Q_INVOKABLE void setRandomColor();
protected:
  void timerEvent(QTimerEvent *event);
signals:
  void colorChanged();
};

#endif // CHANGINGCOLOR_HPP
