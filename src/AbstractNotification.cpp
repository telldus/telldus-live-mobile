#include "AbstractNotification.h"

class AbstractNotification::PrivateData {
public:
	QString message;
};

AbstractNotification::AbstractNotification(const QString &msg, QObject *parent)
	:QObject(parent)
{
	d = new PrivateData;
	d->message = msg;
}

AbstractNotification::~AbstractNotification() {
	delete d;
}

QString AbstractNotification::message() const {
	return d->message;
}

