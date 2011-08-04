#include "device.h"

class Device::PrivateData {
public:
	bool isFavorite;
	QString name;
	int methods, state;
};

Device::Device(QObject *parent) :
    QObject(parent)
{
	d = new PrivateData;
	d->isFavorite = false;
	d->methods = 0;
	d->state = 2;
}

Device::~Device() {
	delete d;
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


