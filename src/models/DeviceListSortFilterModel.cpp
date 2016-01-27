#include "DeviceListSortFilterModel.h"

#include <QDebug>

#include "device.h"
#include "devicemodel.h"

DeviceListSortFilterModel::DeviceListSortFilterModel(DeviceModel *model, QObject *parent) : QSortFilterProxyModel(parent)
{
	connect(model, SIGNAL(devicesLoaded(QVariantList)), this, SLOT(invalidate()));
	connect(this, SIGNAL(rowsInserted(QModelIndex,int,int)), this, SLOT(invalidate()));
	connect(this, SIGNAL(rowsRemoved(QModelIndex,int,int)), this, SLOT(invalidate()));

	this->setSourceModel(model);
	this->setDynamicSortFilter(true);
	this->sort(0);
}

DeviceListSortFilterModel::~DeviceListSortFilterModel() {
}

bool DeviceListSortFilterModel::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const
{
	QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);
	Device *object = qobject_cast<Device *>(this->sourceModel()->data(index).value<QObject *>());
	return !object->ignored();
}

bool DeviceListSortFilterModel::lessThan(const QModelIndex &left, const QModelIndex &right) const {
	Device *leftObject = qobject_cast<Device *>(this->sourceModel()->data(left).value<QObject *>());
	Device *rightObject = qobject_cast<Device *>(this->sourceModel()->data(right).value<QObject *>());

	return leftObject->clientName() < rightObject->clientName();
}
