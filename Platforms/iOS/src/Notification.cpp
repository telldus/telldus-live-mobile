#include "Notification.h"

class Notification::PrivateData {
public:
};

Notification::Notification(const QString &msg, QObject *parent)
	:AbstractNotification(msg, parent)
{
	d = new PrivateData;
}

Notification::~Notification() {
	delete d;
}

void Notification::notify() {
}
