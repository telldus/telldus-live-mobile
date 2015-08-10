#include "AndroidPushNotifications.h"
#include "config.h"

#include <QDebug>
#include <QUuid>
#include <QNetworkRequest>
#include <QUrlQuery>
#include <QDateTime>

#include <QAndroidJniObject>
#include <QAndroidJniEnvironment>

class AndroidPushNotifications::PrivateData {
public:
	static AndroidPushNotifications *instance;
};

AndroidPushNotifications *AndroidPushNotifications::PrivateData::instance = 0;

AndroidPushNotifications::AndroidPushNotifications(QObject *parent):QObject(parent) {
}

AndroidPushNotifications::~AndroidPushNotifications() {
}

AndroidPushNotifications * AndroidPushNotifications::instance() {
	if (PrivateData::instance == 0) {
		PrivateData::instance = new AndroidPushNotifications();
	}
	return PrivateData::instance;
}

void AndroidPushNotifications::receivePushData(QString token, QString name, QString manufacturer, QString model, QString os_version) {
	emit sendRegisterPushTokenWithApi(token, name, manufacturer, model, os_version);
}