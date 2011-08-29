#include "groupdevicemodel.h"
#include "devicemodel.h"
#include "device.h"
#include "tellduslive.h"

#include <QSet>
#include <QStringList>
#include <QDebug>

class GroupDeviceModel::PrivateData {
public:
	QSet<int> devices;
	int id;
};

GroupDeviceModel::GroupDeviceModel(QObject *parent) :
AbstractFilteredDeviceModel(DeviceModel::instance(), parent), d(new PrivateData)
{
	d->id = 0;
}

GroupDeviceModel::~GroupDeviceModel() {
	delete d;
}

void GroupDeviceModel::addDevices(const QList<int> &devices, bool saveToAPI) {
	foreach(int deviceId, devices) {
		qDebug() << "Adding" << deviceId;
		d->devices << deviceId;
	}
	if (saveToAPI) {
		save();
	}
	invalidateFilter();
}

bool GroupDeviceModel::filterAcceptsDevice(Device *device) const {
	return hasDevice(device->id());
}

bool GroupDeviceModel::hasDevice(int deviceId) const {
	return d->devices.contains(deviceId);
}

void GroupDeviceModel::onSetParameter(const QVariantMap &result, const QVariantMap &) {
	if (result["status"] == "success") {
		emit changed();
	}
}

void GroupDeviceModel::removeDevices(const QList<int> &devices) {
	foreach(int deviceId, devices) {
		qDebug() << "Removing" << deviceId;
		d->devices.remove(deviceId);
	}
	save();
	invalidateFilter();
}

void GroupDeviceModel::save() {
	QStringList devices;
	foreach(int id, d->devices) {
		devices << QString::number(id);
	}

	TelldusLive *telldusLive = TelldusLive::instance();
	TelldusLiveParams params;
	params["id"] = d->id;
	params["parameter"] = "devices";
	params["value"] = devices.join(",");
	telldusLive->call("device/setParameter", params, this, SLOT(onSetParameter(QVariantMap,QVariantMap)), params);
}

void GroupDeviceModel::setId(int id) {
	d->id = id;
}
