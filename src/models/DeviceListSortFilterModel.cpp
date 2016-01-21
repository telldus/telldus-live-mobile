#include "DeviceListSortFilterModel.h"

#include <QDebug>

#include "device.h"
#include "FilteredDeviceModel.h"

DeviceListSortFilterModel::DeviceListSortFilterModel(FilteredDeviceModel *model, QObject *parent) : QSortFilterProxyModel(parent)
{
	this->setSourceModel(model);
	this->setDynamicSortFilter(true);
	this->sort(0);
	connect(model, SIGNAL(rowsInserted(QModelIndex,int,int)), this, SLOT(rowsAdded(QModelIndex,int,int)));
	connect(this, SIGNAL(rowsInserted(QModelIndex,int,int)), this, SIGNAL(countChanged()));
	connect(this, SIGNAL(rowsRemoved(QModelIndex,int,int)), this, SIGNAL(countChanged()));
}

DeviceListSortFilterModel::~DeviceListSortFilterModel() {
}

bool DeviceListSortFilterModel::lessThan(const QModelIndex &left, const QModelIndex &right) const {
	Device *leftObject = qobject_cast<Device *>(this->sourceModel()->data(left).value<QObject *>());
	Device *rightObject = qobject_cast<Device *>(this->sourceModel()->data(right).value<QObject *>());

	return leftObject->clientName() < rightObject->clientName();
}

void DeviceListSortFilterModel::rowsAdded(const QModelIndex &, int start, int end) {
}