#include "favoritesensormodel.h"

#include <QDebug>

#include "sensor.h"
#include "sensormodel.h"

FavoriteSensorModel::FavoriteSensorModel(SensorModel *model, QObject *parent) : QSortFilterProxyModel(parent)
{
	this->setSourceModel(model);
	this->setDynamicSortFilter(true);
	this->sort(0);
	connect(this, SIGNAL(rowsInserted(QModelIndex,int,int)), this, SIGNAL(countChanged()));
	connect(this, SIGNAL(rowsRemoved(QModelIndex,int,int)), this, SIGNAL(countChanged()));
}

FavoriteSensorModel::~FavoriteSensorModel() {
}

bool FavoriteSensorModel::filterAcceptsRow(int sourceRow, const QModelIndex &) const {
	SensorModel *model = qobject_cast<SensorModel *>(this->sourceModel());
	if (!model) {
		//Should not happen
		return false;
	}
	Sensor *sensor = qobject_cast<Sensor *>(model->get(sourceRow).value<QObject *>());
	connect(sensor, SIGNAL(isFavoriteChanged()), this, SLOT(sensorChanged()), Qt::UniqueConnection);
	connect(sensor, SIGNAL(nameChanged()), this, SLOT(invalidate()), Qt::UniqueConnection);
	return sensor->isFavorite();
}

bool FavoriteSensorModel::lessThan(const QModelIndex &left, const QModelIndex &right) const {
	Sensor *leftSensor = qobject_cast<Sensor *>(this->sourceModel()->data(left).value<QObject *>());
	Sensor *rightSensor = qobject_cast<Sensor *>(this->sourceModel()->data(right).value<QObject *>());

	return QString::localeAwareCompare(leftSensor->name(), rightSensor->name()) < 0;
}

void FavoriteSensorModel::sensorChanged() {
	this->invalidateFilter();
}
