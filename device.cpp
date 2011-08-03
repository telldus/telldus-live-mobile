#include "device.h"

class Device::PrivateData {
public:
	bool isFavorite;
	QString name;
};

Device::Device(QObject *parent) :
    QObject(parent)
{
	d = new PrivateData;
	d->isFavorite = false;
}

Device::~Device() {
	delete d;
}

bool Device::isFavorite() const {
	return d->isFavorite;
}


QString Device::name() const {
	return d->name;
}

void Device::setName(const QString &name) {
	d->name = name;
	emit nameChanged();
}

QString Device::stateValue() const {
	return "";
}

int Device::state() const {
	return 1;
}

int Device::methods() const {
	return 3;
}


void Device::setIsFavorite(bool isFavorite) {
	d->isFavorite = isFavorite;
	emit isFavoriteChanged();
}

