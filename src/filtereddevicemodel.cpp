#include "filtereddevicemodel.h"
#include "devicemodel.h"
#include "device.h"

#include <QDebug>

FilteredDeviceModel::FilteredDeviceModel(DeviceModel *model, Device::Type deviceType, QObject *parent) :
	AbstractFilteredDeviceModel(model, parent), type(deviceType)
{
}

bool FilteredDeviceModel::filterAcceptsDevice(Device *device) const {
	if (type == Device::AnyType) {
		return true;
	}
	return device->type() == type;
}

void FilteredDeviceModel::deviceAdded(Device *device) const {
	connect(device, SIGNAL(typeChanged()), this, SLOT(deviceChanged()));
}
