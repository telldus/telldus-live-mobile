#include "favoritesensormodel.h"

#include <QDebug>

#include "sensor.h"
#include "sensormodel.h"

FavoriteSensorModel::FavoriteSensorModel(SensorModel *model, QObject *parent) : QSortFilterProxyModel(parent)
{
	this->setSourceModel(model);
	this->setDynamicSortFilter(true);
	this->sort(0);
	connect(model, SIGNAL(rowsInserted(QModelIndex,int,int)), this, SLOT(rowsAdded(QModelIndex,int,int)));
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
	return sensor->isFavorite();
}

bool FavoriteSensorModel::lessThan(const QModelIndex &left, const QModelIndex &right) const {
	Sensor *leftSensor = qobject_cast<Sensor *>(this->sourceModel()->data(left).value<QObject *>());
	Sensor *rightSensor = qobject_cast<Sensor *>(this->sourceModel()->data(right).value<QObject *>());

	return QString::localeAwareCompare(leftSensor->name(), rightSensor->name()) < 0;
}

void FavoriteSensorModel::rowsAdded(const QModelIndex &, int start, int end) {
	SensorModel *model = qobject_cast<SensorModel *>(this->sourceModel());
	if (!model) {
		return;
	}
	for (int i = start; i <= end; ++i ) {
		Sensor *sensor = qobject_cast<Sensor *>(model->get(i).value<QObject *>());
		connect(sensor, SIGNAL(isFavoriteChanged(const bool &)), this, SLOT(sensorChanged()));
		connect(sensor, SIGNAL(nameChanged(const QString &)), this, SLOT(invalidate()));
	}
}

void FavoriteSensorModel::sensorChanged() {
	this->invalidateFilter();
}
