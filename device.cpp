#include "device.h"

class Device::PrivateData {
public:
	bool isFavorite;
	int id, methods, state;
	QString name, stateValue;
};

Device::Device(QObject *parent) :
    QObject(parent)
{
	d = new PrivateData;
	d->isFavorite = false;
	d->id = 0;
	d->methods = 0;
	d->state = 2;
}

Device::~Device() {
	delete d;
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

