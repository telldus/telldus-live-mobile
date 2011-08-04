#include "devicemodel.h"
#include "device.h"

DeviceModel::DeviceModel(QObject *parent) :
    TListModel("device", parent)
{
}

void DeviceModel::addDevices(const QVariantList &deviceList) {
	QList<QObject *> list;
	foreach(QVariant v, deviceList) {
		QVariantMap dev = v.toMap();

		Device *device = new Device(this);
		device->setId(dev["id"].toInt());
		device->setIsFavorite(dev["isfavorite"].toBool());
		device->setMethods(dev["methods"].toInt());
		device->setName(dev["name"].toString());
		device->setOnline(dev["online"].toBool());
		device->setState(dev["state"].toInt());
		device->setStateValue(dev["statevalue"].toString());
		list << device;
	}
	//Appends all in one go
	this->append(list);
}
