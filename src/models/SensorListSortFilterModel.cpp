#include "SensorListSortFilterModel.h"

#include <QDebug>

#include "sensor.h"
#include "sensormodel.h"

SensorListSortFilterModel::SensorListSortFilterModel(SensorModel *model, QObject *parent) : QSortFilterProxyModel(parent)
{
	connect(model, SIGNAL(sensorsLoaded(QVariantList)), this, SLOT(invalidate()));
	connect(this, SIGNAL(rowsInserted(QModelIndex,int,int)), this, SLOT(invalidate()));
	connect(this, SIGNAL(rowsRemoved(QModelIndex,int,int)), this, SLOT(invalidate()));

	this->setSourceModel(model);
	this->setDynamicSortFilter(true);
	this->sort(0);
}

SensorListSortFilterModel::~SensorListSortFilterModel() {
}

//bool SensorListSortFilterModel::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const
//{
//	QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);
//	Sensor *object = qobject_cast<Sensor *>(this->sourceModel()->data(index).value<QObject *>());
//	return !object->ignored();
//}

bool SensorListSortFilterModel::lessThan(const QModelIndex &left, const QModelIndex &right) const {
	Sensor *leftObject = qobject_cast<Sensor *>(this->sourceModel()->data(left).value<QObject *>());
	Sensor *rightObject = qobject_cast<Sensor *>(this->sourceModel()->data(right).value<QObject *>());

	return leftObject->clientName() < rightObject->clientName();
}
