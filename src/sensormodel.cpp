#include "sensormodel.h"
#include "sensor.h"
#include "tellduslive.h"
#include <QDebug>

SensorModel::SensorModel(QObject *parent) :
	TListModel("sensor", parent)
{
	connect(TelldusLive::instance(), SIGNAL(authorizedChanged()), this, SLOT(authorizationChanged()));
	this->authorizationChanged();
}

void SensorModel::addSensors(const QVariantList &sensorsList) {
	QList<QObject *> list;
	foreach(QVariant v, sensorsList) {
		QVariantMap dev = v.toMap();

		Sensor *sensor = this->findSensor(dev["id"].toInt());
		if (!sensor) {
			sensor = new Sensor(this);
			sensor->setId(dev["id"].toInt());
			list << sensor;
		}
		sensor->setName(dev["name"].toString());
		sensor->setLastUpdated(QDateTime::fromMSecsSinceEpoch(((qint64)dev["lastUpdated"].toInt())*1000));
	}
	if (list.size()) {
		//Appends all in one go
		this->append(list);
	}
}

void SensorModel::authorizationChanged() {
	TelldusLive *telldusLive = TelldusLive::instance();
	if (telldusLive->isAuthorized()) {
		telldusLive->call("sensors/list", TelldusLiveParams(), this, SLOT(onSensorsList(QVariantMap)));
	}
}

Sensor *SensorModel::findSensor(int id) const {
	for(int i = 0; i < this->rowCount(); ++i) {
		Sensor *sensor = qobject_cast<Sensor *>(this->get(i).value<QObject *>());
		if (!sensor) {
			continue;
		}
		if (sensor->sensorId() == id) {
			return sensor;
		}
	}
	return 0;
}

void SensorModel::onSensorsList(const QVariantMap &result) {
	this->addSensors(result["sensor"].toList());
	emit sensorsLoaded(result["sensor"].toList());
}
