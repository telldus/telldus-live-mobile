#include "filtereddevicemodel.h"
#include "devicemodel.h"
#include "device.h"

#include <QDebug>

FilteredDeviceModel::FilteredDeviceModel(DeviceModel *model, Device::Type deviceType, QObject *parent) :
	QSortFilterProxyModel(parent), type(deviceType)
{
	this->setSourceModel(model);
	this->setDynamicSortFilter(true);
	connect(model, SIGNAL(rowsInserted(QModelIndex,int,int)), this, SLOT(rowsAdded(QModelIndex,int,int)));
	connect(this, SIGNAL(rowsInserted(QModelIndex,int,int)), this, SIGNAL(countChanged()));
	connect(this, SIGNAL(rowsRemoved(QModelIndex,int,int)), this, SIGNAL(countChanged()));
}

bool FilteredDeviceModel::filterAcceptsRow(int sourceRow, const QModelIndex &) const {
	DeviceModel *model = qobject_cast<DeviceModel *>(this->sourceModel());
	if (!model) {
		//Should not happen
		return false;
	}
	Device *device = qobject_cast<Device *>(model->get(sourceRow).value<QObject *>());
	return device->type() == type;
}

void FilteredDeviceModel::rowsAdded(const QModelIndex &, int start, int end) {
	DeviceModel *model = qobject_cast<DeviceModel *>(this->sourceModel());
	if (!model) {
		return;
	}
	for (int i = start; i <= end; ++i ) {
		Device *device = qobject_cast<Device *>(model->get(i).value<QObject *>());
		connect(device, SIGNAL(typeChanged()), this, SLOT(deviceChanged()));
	}
}

void FilteredDeviceModel::deviceChanged() {
	this->invalidateFilter();
}
