#include "devicemodel.h"
#include "device.h"
#include "tellduslive.h"

DeviceModel::DeviceModel(QObject *parent) :
    TListModel("device", parent)
{
	connect(TelldusLive::instance(), SIGNAL(authorizedChanged()), this, SLOT(authorizationChanged()));
	this->authorizationChanged();
}

void DeviceModel::addDevices(const QVariantList &deviceList) {
	QList<QObject *> list;
	foreach(QVariant v, deviceList) {
		QVariantMap dev = v.toMap();

		Device *device = this->findDevice(dev["id"].toInt());
		if (!device) {
			device = new Device(this);
			device->setId(dev["id"].toInt());
			list << device;
		}
		if (dev.contains("isfavorite")) {
			device->setIsFavorite(dev["isfavorite"].toBool());
		}
		device->setMethods(dev["methods"].toInt());
		device->setName(dev["name"].toString());
		device->setOnline(dev["online"].toBool());
		device->setState(dev["state"].toInt());
		device->setStateValue(dev["statevalue"].toString());
	}
	if (list.size()) {
		//Appends all in one go
		this->append(list);
	}
}

void DeviceModel::authorizationChanged() {
	TelldusLive *telldusLive = TelldusLive::instance();
	if (telldusLive->isAuthorized()) {
		TelldusLiveParams params;
		params["supportedMethods"] = 23; //TODO: Use constants
		telldusLive->call("devices/list", params, this, SLOT(onDevicesList(QVariantMap)));
	}
}

Device *DeviceModel::findDevice(int id) const {
	for(int i = 0; i < this->rowCount(); ++i) {
		Device *device = qobject_cast<Device *>(this->get(i).value<QObject *>());
		if (!device) {
			continue;
		}
		if (device->id() == id) {
			return device;
		}
	}
	return 0;
}

void DeviceModel::onDevicesList(const QVariantMap &result) {
	this->addDevices(result["device"].toList());
	emit devicesLoaded(result["device"].toList());
}
