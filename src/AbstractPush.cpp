#include "AbstractPush.h"
#include "config.h"
#include "Push.h"
#include "tellduslive.h"

#include <QDebug>
#include <QSettings>

class AbstractPush::PrivateData {
public:
	QString token, deviceName, manufacturer, model, osVersion, deviceId;
	bool pushEnabled;
	static Push *instance;
};
Push *AbstractPush::PrivateData::instance = 0;

AbstractPush::AbstractPush()
	:QObject()
{
	d = new PrivateData;

	QSettings s;
	d->pushEnabled = s.value("pushEnabled", false).toBool();

	connect(TelldusLive::instance(), SIGNAL(authorizedChanged()), this, SLOT(onAuthorizedChanged()));
}

AbstractPush::~AbstractPush() {
	delete d;
}

Push *AbstractPush::instance() {
	if (PrivateData::instance == 0) {
		PrivateData::instance = new Push();
	}
	return PrivateData::instance;
}

void AbstractPush::submitPushToken() {
	qDebug() << "[PUSH] Submitting push token to server";
	QSettings s;
	s.setValue("pushEnabled", false);
	s.setValue("pushName", "");
	s.setValue("pushOsVersion", "");
	this->onAuthorizedChanged();
}

void AbstractPush::registerToken(const QString &token, const QString &deviceName, const QString &manufacturer, const QString &model, const QString &osVersion, const QString &deviceId) {
	d->token = token;
	d->deviceName = deviceName;
	d->manufacturer = manufacturer;
	d->model = model;
	d->osVersion = osVersion;
	d->deviceId = deviceId;
	this->onAuthorizedChanged();
}

void AbstractPush::onAuthorizedChanged() {
	TelldusLive *telldusLive = TelldusLive::instance();
	QSettings s;
	if (!telldusLive->isAuthorized()) {
		s.setValue("pushEnabled", false);
		return;
	}
	if (d->token == "") {
		return;
	}

	//if (d->pushEnabled && d->deviceName == s.value("pushName", "").toString() && d->osVersion == s.value("pushOsVersion", "").toString()) {
	//	// No changed values, no need to reregister
	//	return;
	//}
	if (!d->pushEnabled) {
		return;
	}
	TelldusLiveParams params;
	params["token"] = d->token;
	params["name"] = d->deviceName;
	params["manufacturer"] = d->manufacturer;
	params["model"] = d->model;
	params["osVersion"] = d->osVersion;
	params["deviceId"] = d->deviceId;
	params["pushServiceId"] = PUSH_SERVICE_ID;
	telldusLive->call("user/registerPushToken", params, this, SLOT(registerPushTokenWithApiCallback(QVariantMap)));
}

void AbstractPush::registerPushTokenWithApiCallback(const QVariantMap &data) {
	if (data["status"] != "success") {
		qDebug() << "[PUSH] Could not register push token with API";
		qDebug().noquote().nospace() << "       Error: " << data.value("error").toString();
		return;
	}
	qDebug() << "[PUSH] Successfully registered push token with API";
	QSettings s;
	s.setValue("pushEnabled", true);
	s.setValue("pushName", d->deviceName);
	s.setValue("pushOsVersion", d->osVersion);
}
