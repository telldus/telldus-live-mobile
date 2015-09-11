#include "favoritedevicemodel.h"

#include <QDebug>

#include "device.h"
#include "devicemodel.h"

FavoriteDeviceModel::FavoriteDeviceModel(DeviceModel *model, QObject *parent) : QSortFilterProxyModel(parent)
{
	this->setSourceModel(model);
	this->setDynamicSortFilter(true);
	this->sort(0);
	connect(this, SIGNAL(rowsInserted(QModelIndex,int,int)), this, SIGNAL(countChanged()));
	connect(this, SIGNAL(rowsRemoved(QModelIndex,int,int)), this, SIGNAL(countChanged()));
}

FavoriteDeviceModel::~FavoriteDeviceModel() {
}

bool FavoriteDeviceModel::filterAcceptsRow(int sourceRow, const QModelIndex &) const {
	DeviceModel *model = qobject_cast<DeviceModel *>(this->sourceModel());
	if (!model) {
		//Should not happen
		return false;
	}
	Device *device = qobject_cast<Device *>(model->get(sourceRow).value<QObject *>());
	connect(device, SIGNAL(isFavoriteChanged()), this, SLOT(deviceChanged()), Qt::UniqueConnection);
	connect(device, SIGNAL(nameChanged()), this, SLOT(invalidate()), Qt::UniqueConnection);
	return device->isFavorite();
}

bool FavoriteDeviceModel::lessThan(const QModelIndex &left, const QModelIndex &right) const {
	Device *leftDevice = qobject_cast<Device *>(this->sourceModel()->data(left).value<QObject *>());
	Device *rightDevice = qobject_cast<Device *>(this->sourceModel()->data(right).value<QObject *>());

	return QString::localeAwareCompare(leftDevice->name(), rightDevice->name()) < 0;
}

void FavoriteDeviceModel::deviceChanged() {
	this->invalidateFilter();
}
