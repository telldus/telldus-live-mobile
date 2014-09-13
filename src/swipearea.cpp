#include "swipearea.h"
#include <QEvent>
#include <QGraphicsSceneMouseEvent>

class SwipeArea::PrivateData {
public:
	QPointF pos;
	bool filterTouchEvent, filterMouseEvent;
};

SwipeArea::SwipeArea(QQuickItem *parent)
	:QQuickItem(parent)
{
	setAcceptedMouseButtons(Qt::LeftButton);
	d = new PrivateData;
	d->filterTouchEvent = false;
	d->filterMouseEvent = true;
}

SwipeArea::~SwipeArea()
{
	delete d;
}

bool SwipeArea::filterMouseEvent() const {
	return d->filterTouchEvent;
}

void SwipeArea::setFilterMouseEvent(bool arg) {
	if (d->filterMouseEvent != arg) {
		d->filterMouseEvent = arg;
		emit filterMouseEventChanged(arg);
	}
}

bool SwipeArea::filterTouchEvent() const {
	return d->filterTouchEvent;
}

void SwipeArea::setFilterTouchEvent(bool arg) {
	if (d->filterTouchEvent != arg) {
		d->filterTouchEvent = arg;
		emit filterTouchEventChanged(arg);
	}
}

void SwipeArea::touchEvent(QTouchEvent * event) {
	QList<QTouchEvent::TouchPoint> touchPoints = static_cast<QTouchEvent *>(event)->touchPoints();
	const QTouchEvent::TouchPoint &touchPoint = touchPoints.at(0);

	if (event->type() == QEvent::TouchBegin) {
		this->touchBegin(touchPoint.pos());
	} else if (event->type() == QEvent::TouchUpdate) {
		this->touchMove(touchPoint.pos());
	}
}

void SwipeArea::touchBegin(QPointF pos) {
	d->pos = pos;
}

bool SwipeArea::touchMove(QPointF pos) {
	if (d->pos.x() < 0 && d->pos.y() < 0) {
		return false;
	}
	QPointF p = pos - d->pos;
	if (qAbs(p.y()) > 60) {
		d->pos = QPointF(-1, -1);
		return false;
	}

	if (p.x() > 200) {
		d->pos = QPointF(-1, -1);
		emit swipeRight();
		return false;
	} else if (p.x() < -200) {
		d->pos = QPointF(-1, -1);
		emit swipeLeft();
		return false;
	}

	return true;
}
