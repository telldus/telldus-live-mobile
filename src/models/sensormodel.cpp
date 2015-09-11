#include "sensormodel.h"
#include "sensor.h"
#include "tellduslive.h"
#include <math.h>

#include <QSqlDatabase>
#include <QSqlRecord>
#include <QSqlQuery>
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
		PrivateData::instance->fetchDataFromCache();
	}
	return PrivateData::instance;
}

void SensorModel::fetchDataFromCache() {
	QSqlDatabase db = QSqlDatabase::database();
	if (db.isOpen()) {
		qDebug() << "[SQL] SELECT id, name, lastUpdated, temperature, humidity, rainRate, rainTotal, uv, watt, windAvg, windGust, windDir, luminance, favorite FROM Sensor ORDER BY name";
		QSqlQuery query("SELECT id, name, lastUpdated, temperature, humidity, rainRate, rainTotal, uv, watt, windAvg, windGust, windDir, luminance, favorite FROM Sensor ORDER BY name", db);
		QVariantList sensors;
		while (query.next()) {
			QSqlRecord record = query.record();
			QVariantMap sensor;
			sensor["id"] = record.value("id");
			sensor["name"] = record.value("name");
			sensor["lastUpdated"] = record.value("lastUpdated");
			if (record.isNull("temperature") == false) {
				sensor["temperature"] = record.value("temperature");
			}
			if (record.isNull("humidity") == false) {
				sensor["humidity"] = record.value("humidity");
			}
			if (record.isNull("rainRate") == false) {
				sensor["rainRate"] = record.value("rainRate");
			}
			if (record.isNull("rainTotal") == false) {
				sensor["rainTotal"] = record.value("rainTotal");
			}
			if (record.isNull("uv") == false) {
				sensor["uv"] = record.value("uv");
			}
			if (record.isNull("watt") == false) {
				sensor["watt"] = record.value("watt");
			}
			if (record.isNull("windAvg") == false) {
				sensor["windAvg"] = record.value("windAvg");
			}
			if (record.isNull("windGust") == false) {
				sensor["windGust"] = record.value("windGust");
			}
			if (record.isNull("windDir") == false) {
				sensor["windDir"] = record.value("windDir");
			}
			if (record.isNull("luminance") == false) {
				sensor["luminance"] = record.value("luminance");
			}
			sensor["isfavorite"] = record.value("isfavorite").toBool();
			sensor["fromCache"] = true;
			sensors << sensor;
		}
		if (sensors.size()) {
			this->addSensors(sensors);
		}
	}
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
		if (dev.contains("luminance") && !isnan(dev["luminance"].toDouble())) {
			sensor->setLuminance(dev["luminance"].toString());
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
		if (dev.contains("isfavorite")) {
			sensor->setIsFavorite(dev["isfavorite"].toBool());
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
		TelldusLiveParams params;
		params["includeValues"] = 1;
		telldusLive->call("sensors/list", params, this, SLOT(onSensorsList(QVariantMap)));
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
