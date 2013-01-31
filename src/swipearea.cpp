#include "swipearea.h"
#include <QEvent>
#include <QTouchEvent>

class SwipeArea::PrivateData {
public:
	QPointF pos;
};

SwipeArea::SwipeArea(QDeclarativeItem *parent)
	:QDeclarativeItem(parent)
{
	setAcceptTouchEvents(true);
	setAcceptedMouseButtons(Qt::LeftButton);
	d = new PrivateData;
}

SwipeArea::~SwipeArea()
{
	delete d;
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
		d->pos = touchPoint.pos();
		return true;
	}

	if (d->pos.x() < 0 && d->pos.y() < 0) {
		return false;
	}

	QPointF p = touchPoint.pos() - d->pos;
	if (qAbs(p.y()) > 60) {
		ev->ignore();
		d->pos = QPointF(-1, -1);
		return false;
	}

	if (p.x() > 200) {
		d->pos = QPointF(-1, -1);
		ev->ignore();
		emit swipeRight();
		return false;
	} else if (p.x() < -200) {
		d->pos = QPointF(-1, -1);
		ev->ignore();
		emit swipeLeft();
		return false;
	}

	return true;
}
