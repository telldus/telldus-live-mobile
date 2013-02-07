#include "swipearea.h"
#include <QEvent>
#include <QTouchEvent>
#include <QGraphicsSceneMouseEvent>

class SwipeArea::PrivateData {
public:
	QPointF pos;
	bool filterTouchEvent, filterMouseEvent;
};

SwipeArea::SwipeArea(QDeclarativeItem *parent)
	:QDeclarativeItem(parent)
{
	setAcceptTouchEvents(false);
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
		setAcceptTouchEvents(arg);
		emit filterTouchEventChanged(arg);
	}
}

bool SwipeArea::event(QEvent *ev) {
	switch (ev->type()) {
		case QEvent::TouchBegin:
		case QEvent::TouchUpdate:
		break;
		default:
		return QDeclarativeItem::event(ev);
	}
	QList<QTouchEvent::TouchPoint> touchPoints = static_cast<QTouchEvent *>(ev)->touchPoints();
	const QTouchEvent::TouchPoint &touchPoint = touchPoints.at(0);

	if (ev->type() == QEvent::TouchBegin) {
		this->touchBegin(touchPoint.pos());
		return true;
	}

	return touchMove(touchPoint.pos());
}

void SwipeArea::mousePressEvent(QGraphicsSceneMouseEvent *event) {
	this->touchBegin(event->pos());
}

void SwipeArea::mouseMoveEvent(QGraphicsSceneMouseEvent *event) {
	touchMove(event->pos());
	QDeclarativeItem::mouseMoveEvent(event);
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
