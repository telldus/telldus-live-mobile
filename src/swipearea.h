#ifndef SWIPEAREA_H
#define SWIPEAREA_H

#include <QQuickItem>

class SwipeArea : public QQuickItem
{
	Q_OBJECT
	Q_PROPERTY(bool filterMouseEvent READ filterMouseEvent WRITE setFilterMouseEvent NOTIFY filterMouseEventChanged)
	Q_PROPERTY(bool filterTouchEvent READ filterTouchEvent WRITE setFilterTouchEvent NOTIFY filterTouchEventChanged)
public:
	explicit SwipeArea(QQuickItem *parent = 0);
	~SwipeArea();

	bool filterMouseEvent() const;
	bool filterTouchEvent() const;

public slots:
	void setFilterMouseEvent(bool arg);
	void setFilterTouchEvent(bool arg);

signals:
	void swipeLeft();
	void swipeRight();

	void filterMouseEventChanged(bool arg);
	void filterTouchEventChanged(bool arg);

protected:
	virtual void touchEvent(QTouchEvent * event);

private:
	class PrivateData;
	PrivateData *d;
	void touchBegin(QPointF pos);
	bool touchMove(QPointF pos);
};

#endif // SWIPEAREA_H
