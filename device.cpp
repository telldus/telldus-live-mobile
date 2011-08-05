#include "device.h"
#include "tellduslive.h"

class Device::PrivateData {
public:
	bool isFavorite, online;
	int id, methods, state;
	QString name, stateValue;
};

Device::Device(QObject *parent) :
    QObject(parent)
{
	d = new PrivateData;
	d->isFavorite = false;
	d->online = false;
	d->id = 0;
	d->methods = 0;
	d->state = 2;
}

Device::~Device() {
	delete d;
}

void Device::bell() {
	sendMethod(4);
}

void Device::dim(char level) {
	sendMethod(16, QString::number(level));
}

int Device::id() const {
	return d->id;
}

void Device::setId(int id) {
	d->id = id;
	emit idChanged();
}

bool Device::isFavorite() const {
	return d->isFavorite;
}

void Device::setIsFavorite(bool isFavorite) {
	d->isFavorite = isFavorite;
	emit isFavoriteChanged();
}

int Device::methods() const {
	return d->methods;
}

void Device::setMethods(int methods) {
	d->methods = methods;
	emit methodsChanged();
}

QString Device::name() const {
	return d->name;
}

void Device::setName(const QString &name) {
	d->name = name;
	emit nameChanged();
}

void Device::onActionResponse(const QVariantMap &result, const QVariantMap &data) {
	if (result["status"].toString() != "success") {
		return;
	}
	int method = data["method"].toInt();
	if (method == 16) {
		QString value = data["value"].toString();
		if (value == "255") {
			method = 1;
		} else if (value == "0") {
			method = 2;
		}
		setStateValue(value);
	} else if (method == 4) {
		return;
	}
	setState(method);
}

bool Device::online() const {
	return d->online;
}

void Device::setOnline(bool online) {
	d->online = online;
	emit onlineChanged();
}

void Device::sendMethod(int method, const QString &value) {
	TelldusLive *telldusLive = TelldusLive::instance();
	TelldusLiveParams params;
	params["id"] = this->id();
	params["method"] = method;
	params["value"] = value;
	telldusLive->call("device/command", params, this, SLOT(onActionResponse(QVariantMap,QVariantMap)), params);
}

int Device::state() const {
	return d->state;
}

void Device::setState(int state) {
	d->state = state;
	emit stateChanged();
}

QString Device::stateValue() const {
	return d->stateValue;
}

void Device::setStateValue(const QString &stateValue) {
	d->stateValue = stateValue;
	emit stateValueChanged();
}

void Device::turnOff() {
	sendMethod(2);
}

void Device::turnOn() {
	sendMethod(1);
}

