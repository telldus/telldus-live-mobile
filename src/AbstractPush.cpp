#include "AbstractPush.h"
#include "config.h"
#include "tellduslive.h"

#include <QDebug>
#include <QSettings>

class AbstractPush::PrivateData {
public:
	QString token, deviceName, manufacturer, model, osVersion;
	bool pushEnabled;
};


AbstractPush::AbstractPush(QObject *parent)
	:QObject(parent)
{
	d = new PrivateData;

	QSettings s;
	d->pushEnabled = s.value("pushEnabled", false).toBool();

	connect(TelldusLive::instance(), SIGNAL(authorizedChanged()), this, SLOT(onAuthorizedChanged()));
}

AbstractPush::~AbstractPush() {
	delete d;
}

void AbstractPush::registerToken(const QString &token, const QString &deviceName, const QString &manufacturer, const QString &model, const QString &osVersion) {
	d->token = token;
	d->deviceName = deviceName;
	d->manufacturer = manufacturer;
	d->model = model;
	d->osVersion = osVersion;
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

	if (d->pushEnabled && d->deviceName == s.value("pushName", "").toString() && d->osVersion == s.value("pushOsVersion", "").toString()) {
		// No changed values, no need to reregister
		return;
	}
	TelldusLiveParams params;
	params["token"] = d->token;
	params["name"] = d->deviceName;
	params["manufacturer"] = d->manufacturer;
	params["model"] = d->model;
	params["osVersion"] = d->osVersion;
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
