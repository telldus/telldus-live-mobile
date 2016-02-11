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
		qDebug() << "[SQL] ALTER TABLE Sensor ADD COLUMN deactive INTEGER";
		QSqlQuery query2("ALTER TABLE Sensor ADD COLUMN deactive INTEGER", db);
		qDebug() << "[SQL] ALTER TABLE Sensor ADD COLUMN clientName TEXT";
		QSqlQuery query3("ALTER TABLE Sensor ADD COLUMN clientName TEXT", db);
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
		qDebug() << "[SQL] SELECT id, name, lastUpdated, temperature, humidity, rainRate, rainTotal, uv, watt, windAvg, windGust, windDir, luminance, favorite, deactive, clientName FROM Sensor ORDER BY name";
		QSqlQuery query("SELECT id, name, lastUpdated, temperature, humidity, rainRate, rainTotal, uv, watt, windAvg, windGust, windDir, luminance, favorite, deactive, clientName FROM Sensor ORDER BY name", db);
		QVariantList sensors;
		while (query.next()) {
			QSqlRecord record = query.record();
			QVariantMap sensor;
			sensor["id"] = record.value("id");
			sensor["name"] = record.value("name");
			sensor["clientName"] = record.value("clientName");
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
			sensor["isfavorite"] = record.value("favorite").toBool();
			sensor["deactive"] = record.value("deactive");
			sensor["fromCache"] = true;
			sensors << sensor;
		}
		if (sensors.size()) {
			this->addSensors(sensors);
		}
	}
}

void SensorModel::addSensors(const QVariantList &sensorsList) {
	QList<int> activeSensorIds;
	QList<QObject *> list;
	foreach(QVariant v, sensorsList) {
		QVariantMap dev = v.toMap();
		// API returns temp instead of temperature
		if(dev.contains("temp")) {
			dev.insert("temperature", dev["temp"]);
			dev.remove("temp");
		}
		// API returns rrate instead of rainRate
		if(dev.contains("rrate")) {
			dev.insert("rainRate", dev["rrate"]);
			dev.remove("rrate");
		}
		// API returns rtot instead of rainTotal
		if(dev.contains("rtot")) {
			dev.insert("rainTotal", dev["rtot"]);
			dev.remove("rtot");
		}
		// API returns lum instead of luminance
		if(dev.contains("lum")) {
			dev.insert("luminance", dev["lum"]);
			dev.remove("lum");
		}
		// API returns wavg instead of windAvg
		if(dev.contains("wavg")) {
			dev.insert("windAvg", dev["wavg"]);
			dev.remove("wavg");
		}
		// API returns wgust instead of windGust
		if(dev.contains("wgust")) {
			dev.insert("windGust", dev["wgust"]);
			dev.remove("wgust");
		}
		// API returns wdir instead of windDir
		if(dev.contains("wdir")) {
			dev.insert("windDir", dev["wdir"]);
			dev.remove("wdir");
		}
		if (dev["deactive"].toBool() == false) {
			if (dev["fromCache"].toBool() == false) {
				activeSensorIds << dev["id"].toInt();
			}
			Sensor *sensor = this->findSensor(dev["id"].toInt());
			if (!sensor) {
				sensor = new Sensor(this);
				sensor->setFromVariantMap(dev);
				list << sensor;
			} else {
				sensor->setFromVariantMap(dev);
			}
		}
	}
	this->deactivateSensors(activeSensorIds);
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
		QSqlDatabase db = QSqlDatabase::database();
		if (db.isOpen()) {
			qDebug() << "[SQL] DELETE FROM Sensor";
			QSqlQuery query("DELETE FROM Sensor", db);
		}
		qDebug().nospace().noquote() << "[SENSORMODEL] Cleared";
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

void SensorModel::deactivateSensors(QList<int> activeIds) {
	QSqlDatabase db = QSqlDatabase::database();
	for(int j=0; j < activeIds.count(); ++j) {
		for(int i = 0; i < this->rowCount(); ++i) {
			Sensor *sensor = qobject_cast<Sensor *>(this->get(i).value<QObject *>());
			if (activeIds.indexOf(sensor->sensorId()) == -1) {
				qDebug() << "[SENSORMODEL] Sensor Not Found, will deactivate!! Id: " << sensor->sensorId();
				if (db.isOpen()) {
					QSqlQuery query(db);
					query.prepare("UPDATE Sensor SET deactive = ? WHERE id = ?");
					query.bindValue(0, true);
					query.bindValue(1, sensor->sensorId());
					query.exec();
				}
				this->splice(i, 1);
			}
		}
	}
}

void SensorModel::onSensorsList(const QVariantMap &result) {
	if (result["sensor"].toList().size() == 0) {
		qDebug() << "[SENSORMODEl] No Sensors found, will deactivate all!!";
		QSqlDatabase db = QSqlDatabase::database();
		if (db.isOpen()) {
			QSqlQuery query(db);
			query.prepare("UPDATE Sensor SET deactive = ?");
			query.bindValue(0, true);
			query.exec();
		}
		this->clear();
	} else {
		this->addSensors(result["sensor"].toList());
	}
	emit sensorsLoaded(result["sensor"].toList());
}
