#ifndef NOTIFICATION_H
#define NOTIFICATION_H

#include "AbstractNotification.h"

class Notification : public AbstractNotification {
	Q_OBJECT
public:
	explicit Notification(const QString &message, QObject *parent = 0);
	virtual ~Notification();

	virtual void notify();

private:
	class PrivateData;
	PrivateData *d;
};

#endif // NOTIFICATION_H
