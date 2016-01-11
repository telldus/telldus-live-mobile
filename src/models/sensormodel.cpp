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
	QSqlDatabase db = QSqlDatabase::database();
	if (db.isOpen()) {
		qDebug() << "[SQL] CREATE TABLE IF NOT EXISTS Sensor (id INTEGER PRIMARY KEY, name TEXT, lastUpdated INTEGER, temperature REAL, humidity REAL, rainRate REAL, rainTotal REAL, uv REAL, watt REAL, windAvg REAL, windGust REAL, windDir REAL, luminance REAL, favorite INTEGER)";
		QSqlQuery query("CREATE TABLE IF NOT EXISTS Sensor (id INTEGER PRIMARY KEY, name TEXT, lastUpdated INTEGER, temperature REAL, humidity REAL, rainRate REAL, rainTotal REAL, uv REAL, watt REAL, windAvg REAL, windGust REAL, windDir REAL, luminance REAL, favorite INTEGER)", db);
	}
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
	qDebug() << "[METHOD] SensorModel::fetchDataFromCache";
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
			sensor->setFromVariantMap(dev);
			list << sensor;
		} else {
			sensor->setFromVariantMap(dev);
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
