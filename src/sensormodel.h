#ifndef SENSORMODEL_H
#define SENSORMODEL_H

#include "tlistmodel.h"

class Sensor;

class SensorModel : public TListModel
{
	Q_OBJECT
public:
	explicit SensorModel(QObject *parent = 0);

	Q_INVOKABLE void addSensors(const QVariantList &sensors);
	Q_INVOKABLE Sensor *findSensor(int id) const;

signals:
	void sensorsLoaded(const QVariantList &sensors);

private slots:
	void authorizationChanged();
	void onSensorsList(const QVariantMap &result);
};

#endif // SENSORMODEL_H
