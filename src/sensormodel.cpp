#include "sensormodel.h"
#include "sensor.h"
#include "tellduslive.h"
#include <math.h>
#include <QDebug>

class SensorModel::PrivateData {
public:
	static SensorModel *instance;
};
SensorModel *SensorModel::PrivateData::instance = 0;

SensorModel::SensorModel(QObject *parent) :
	TListModel("sensor", parent)
{
	connect(TelldusLive::instance(), SIGNAL(authorizedChanged()), this, SLOT(authorizationChanged()));
	this->authorizationChanged();
}

SensorModel *SensorModel::instance() {
	if (PrivateData::instance == 0) {
		PrivateData::instance = new SensorModel;
	}
	return PrivateData::instance;
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
		if (dev.contains("temperature") && !isnan(dev["temperature"].toDouble())) {
			sensor->setTemperature(dev["temperature"].toString());
		}
		if (dev.contains("humidity") && !isnan(dev["humidity"].toDouble())) {
			sensor->setHumidity(dev["humidity"].toString());
		}
		if (dev.contains("rainRate") && !isnan(dev["rainRate"].toDouble())) {
			sensor->setRainRate(dev["rainRate"].toString());
		}
		if (dev.contains("rainTotal") && !isnan(dev["rainTotal"].toDouble())) {
			sensor->setRainTotal(dev["rainTotal"].toString());
		}
		if (dev.contains("uv") && !isnan(dev["uv"].toDouble())) {
			sensor->setUv(dev["uv"].toString());
		}
		if (dev.contains("watt") && !isnan(dev["watt"].toDouble())) {
			sensor->setWatt(dev["watt"].toString());
		}
		if (dev.contains("windAvg") && !isnan(dev["windAvg"].toDouble())) {
			sensor->setWindAvg(dev["windAvg"].toString());
		}
		if (dev.contains("windGust") && !isnan(dev["windGust"].toDouble())) {
			sensor->setWindGust(dev["windGust"].toString());
		}
		if (dev.contains("windDir") && !isnan(dev["windDir"].toDouble())) {
			sensor->setWindDir(dev["windDir"].toString());
		}
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
	} else {
		this->clear();
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
