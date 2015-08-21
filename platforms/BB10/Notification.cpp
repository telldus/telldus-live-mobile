#include "Notification.h"

#include <QDebug>
#include <QUuid>

#include <bps/notification.h>

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
	notification_message_t *notification;
	int rc = notification_message_create(&notification);
	if (rc != BPS_SUCCESS) {
		qDebug() << "Could not create message";
	}
	notification_message_set_item_id(notification, QUuid::createUuid().toString().mid(1, 36).toLocal8Bit());
	notification_message_set_title(notification, "Telldus Live! mobile");
	notification_message_set_subtitle(notification, message().toLocal8Bit());
	notification_notify(notification);
	notification_message_destroy(&notification);
}

