#include "favoritemodel.h"
#include "devicemodel.h"
#include "device.h"

#include <QDebug>

FavoriteModel::FavoriteModel(DeviceModel *model, QObject *parent) :
	QSortFilterProxyModel(parent)
{
	this->setSourceModel(model);
	this->setDynamicSortFilter(true);
	this->sort(0);
	connect(model, SIGNAL(rowsInserted(QModelIndex,int,int)), this, SLOT(rowsAdded(QModelIndex,int,int)));
	connect(this, SIGNAL(rowsInserted(QModelIndex,int,int)), this, SIGNAL(countChanged()));
	connect(this, SIGNAL(rowsRemoved(QModelIndex,int,int)), this, SIGNAL(countChanged()));
}

bool FavoriteModel::filterAcceptsRow(int sourceRow, const QModelIndex &) const {
	DeviceModel *model = qobject_cast<DeviceModel *>(this->sourceModel());
	if (!model) {
		//Should not happen
		return false;
	}
	Device *device = qobject_cast<Device *>(model->get(sourceRow).value<QObject *>());
	return device->isFavorite();
}

bool FavoriteModel::lessThan(const QModelIndex &left, const QModelIndex &right) const {
	Device *leftDevice = qobject_cast<Device *>(this->sourceModel()->data(left).value<QObject *>());
	Device *rightDevice = qobject_cast<Device *>(this->sourceModel()->data(right).value<QObject *>());

	return QString::localeAwareCompare(leftDevice->name(), rightDevice->name()) < 0;
}

void FavoriteModel::rowsAdded(const QModelIndex &, int start, int end) {
	DeviceModel *model = qobject_cast<DeviceModel *>(this->sourceModel());
	if (!model) {
		return;
	}
	for (int i = start; i <= end; ++i ) {
		Device *device = qobject_cast<Device *>(model->get(i).value<QObject *>());
		connect(device, SIGNAL(isFavoriteChanged()), this, SLOT(deviceChanged()));
		connect(device, SIGNAL(nameChanged()), this, SLOT(invalidate()));
	}
}

void FavoriteModel::deviceChanged() {
	this->invalidateFilter();
}
