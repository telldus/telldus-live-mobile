#ifndef SENSORMODEL_H
#define SENSORMODEL_H

#include "tlistmodel.h"

class Sensor;

class SensorModel : public TListModel
{
	Q_OBJECT
public:

	Q_INVOKABLE void addSensors(const QVariantList &sensors);
	Q_INVOKABLE Sensor *findSensor(int id) const;

	static SensorModel *instance();

signals:
	void sensorsLoaded(const QVariantList &sensors);

private slots:
	void authorizationChanged();
	void onSensorsList(const QVariantMap &result);

private:
	explicit SensorModel(QObject *parent = 0);
	class PrivateData;
	PrivateData *d;
};

#endif // SENSORMODEL_H
