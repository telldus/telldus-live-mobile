#include "groupdevicemodel.h"
#include "devicemodel.h"
#include "device.h"

#include <QSet>
#include <QDebug>

class GroupDeviceModel::PrivateData {
public:
	QSet<int> devices;
};

GroupDeviceModel::GroupDeviceModel(QObject *parent) :
AbstractFilteredDeviceModel(DeviceModel::instance(), parent), d(new PrivateData)
{
}

GroupDeviceModel::~GroupDeviceModel() {
	delete d;
}

void GroupDeviceModel::addDevices(const QList<int> &devices) {
	foreach(int deviceId, devices) {
		qDebug() << "Adding" << deviceId;
		d->devices << deviceId;
	}
	invalidateFilter();
}

bool GroupDeviceModel::filterAcceptsDevice(Device *device) const {
	return hasDevice(device->id());
}

bool GroupDeviceModel::hasDevice(int deviceId) const {
	return d->devices.contains(deviceId);
}

void GroupDeviceModel::removeDevices(const QList<int> &devices) {
	foreach(int deviceId, devices) {
		qDebug() << "Removing" << deviceId;
		d->devices.remove(deviceId);
	}
	invalidateFilter();
}
