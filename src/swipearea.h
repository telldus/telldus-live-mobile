#ifndef SWIPEAREA_H
#define SWIPEAREA_H

#include <QDeclarativeItem>

class SwipeArea : public QDeclarativeItem
{
	Q_OBJECT
public:
	explicit SwipeArea(QDeclarativeItem *parent = 0);
	~SwipeArea();

signals:
	void swipeLeft();
	void swipeRight();

protected:
	bool event(QEvent *);

private:
	class PrivateData;
	PrivateData *d;
};

#endif // SWIPEAREA_H
