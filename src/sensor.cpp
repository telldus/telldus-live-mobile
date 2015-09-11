#include "sensor.h"
#include <math.h>
#include "tellduslive.h"

#include <QTimer>
#include <QDebug>
#include <QSqlDatabase>
#include <QSqlQuery>

class Sensor::PrivateData {
public:
	bool hasHumidity, hasRainRate, hasRainTotal;
	bool hasTemperature, hasWindAvg, hasWindGust, hasWindDir;
	bool hasUv, hasWatt, hasLuminance, isFavorite;
	int id;
	QString name;
	QString humidity, rainRate, rainTotal;
	QString temperature, windAvg, windGust, windDir;
	QString uv, watt, luminance;
	QDateTime lastUpdated, lastPolled;
};

Sensor::Sensor(QObject *parent) :
	QObject(parent)
{
	d = new PrivateData;
	d->hasHumidity = false;
	d->hasRainRate = false;
	d->hasRainTotal = false;
	d->hasTemperature = false;
	d->hasWindAvg = false;
	d->hasWindGust = false;
	d->hasWindDir = false;
	d->hasUv = false;
	d->hasWatt = false;
	d->hasLuminance = false;
	d->isFavorite = false;
	d->id = 0;
}

Sensor::~Sensor() {
	delete d;
}

void Sensor::fetchData() {
	TelldusLive *telldusLive = TelldusLive::instance();
	if (telldusLive->isAuthorized() && d->id > 0) {
		TelldusLiveParams params;
		params["id"] = d->id;
		telldusLive->call("sensor/info", params, this, SLOT(onInfoReceived(QVariantMap)));
		d->lastPolled = QDateTime::currentDateTime();
	}
}

QString Sensor::humidity() const {
	return d->humidity;
}

void Sensor::setHumidity(const QString &humidity) {
	d->humidity = humidity;
	d->hasHumidity = true;
	emit humidityChanged(humidity);
	emit hasHumidityChanged();
	emit saveToCache();
}

bool Sensor::hasHumidity() const {
	return d->hasHumidity;
}

QString Sensor::rainRate() const {
	return d->rainRate;
}

void Sensor::setRainRate(const QString &rainRate) {
	d->rainRate = rainRate;
	d->hasRainRate = true;
	emit rainRateChanged(rainRate);
	emit hasRainRateChanged();
	emit saveToCache();
}

bool Sensor::hasRainRate() const {
	return d->hasRainRate;
}

QString Sensor::rainTotal() const {
	return d->rainTotal;
}

void Sensor::setRainTotal(const QString &rainTotal) {
	d->rainTotal = rainTotal;
	d->hasRainTotal = true;
	emit rainTotalChanged(rainTotal);
	emit hasRainTotalChanged();
	emit saveToCache();
}

bool Sensor::hasRainTotal() const {
	return d->hasRainTotal;
}

int Sensor::sensorId() const {
	return d->id;
}

void Sensor::setId(int id) {
	d->id = id;
	emit idChanged();
	emit saveToCache();
}

bool Sensor::isFavorite() const {
	return d->isFavorite;
}

void Sensor::setIsFavorite(bool isFavorite) {
	if (isFavorite == d->isFavorite) {
		return;
	}
	d->isFavorite = isFavorite;
	emit isFavoriteChanged(isFavorite);
	emit saveToCache();
}

QDateTime Sensor::lastUpdated() const {
	return d->lastUpdated;
}

void Sensor::setLastUpdated(const QDateTime &lastUpdated) {
	d->lastUpdated = lastUpdated;
	emit lastUpdatedChanged(lastUpdated);
	emit saveToCache();
}

int Sensor::minutesAgo() const {
	return round(d->lastUpdated.secsTo(QDateTime::currentDateTime())/60.0);
}

QString Sensor::name() const {
	return d->name;
}

void Sensor::setName(const QString &name) {
	d->name = name;
	emit nameChanged(name);
	emit saveToCache();
}

void Sensor::onInfoReceived(const QVariantMap &info) {
	setLastUpdated(QDateTime::fromMSecsSinceEpoch(((qint64)info["lastUpdated"].toInt()*1000)));
	foreach(QVariant v, info["data"].toList()) {
		QVariantMap info = v.toMap();
		if (info["name"].toString() == "temp") {
			setTemperature(info["value"].toString());
		} else if (info["name"].toString() == "humidity") {
			setHumidity(info["value"].toString());
		} else if (info["name"].toString() == "rrate") {
			setRainRate(info["value"].toString());
		} else if (info["name"].toString() == "rtot") {
			setRainTotal(info["value"].toString());
		} else if (info["name"].toString() == "wavg") {
			setWindAvg(info["value"].toString());
		} else if (info["name"].toString() == "wgust") {
			setWindGust(info["value"].toString());
		} else if (info["name"].toString() == "wdir") {
			setWindDir(info["value"].toString());
		} else if (info["name"].toString() == "uv") {
			setUv(info["value"].toString());
		} else if (info["name"].toString() == "watt" && info["scale"].toString() == "2") {
			setWatt(info["value"].toString());
		} else if (info["name"].toString() == "lum") {
			setLuminance(info["value"].toString());
		}
	}
}

QString Sensor::temperature() const {
//	if (!d->lastPolled.isValid() || d->lastPolled.secsTo(QDateTime::currentDateTime()) > 300) {
		// Five minutes
//		QTimer::singleShot(0, const_cast<Sensor*>(this), SLOT(fetchData()));
//	}
	return d->temperature;
}

void Sensor::setTemperature(const QString &temperature) {
	d->temperature = temperature;
	d->hasTemperature = true;
	emit temperatureChanged(temperature);
	emit hasTemperatureChanged();
	emit saveToCache();
}

bool Sensor::hasTemperature() const {
	return d->hasTemperature;
}

void Sensor::update(const QVariantMap &info) {
	setLastUpdated(QDateTime::fromMSecsSinceEpoch(((qint64)info["time"].toInt()*1000)));
	foreach(QVariant v, info["data"].toList()) {
		QVariantMap info = v.toMap();
		if (info["type"] == 1) {
			setTemperature(info["value"].toString());
		} else if (info["type"] == 2) {
			setHumidity(info["value"].toString());
		} else if (info["type"] == 4) {
			setRainRate(info["value"].toString());
		} else if (info["type"] == 8) {
			setRainTotal(info["value"].toString());
		} else if (info["type"] == 32) {
			setWindAvg(info["value"].toString());
		} else if (info["type"] == 64) {
			setWindGust(info["value"].toString());
		} else if (info["type"] == 16) {
			setWindDir(info["value"].toString());
		} else if (info["type"] == 128) {
			setUv(info["value"].toString());
		} else if (info["type"] == 256 && info["scale"] == 2) {
			setWatt(info["value"].toString());
		} else if (info["type"] == 512) {
			setLuminance(info["value"].toString());
		}
	}
	d->lastPolled = QDateTime::currentDateTime();
}

QString Sensor::windAvg() const {
	return d->windAvg;
}

void Sensor::setWindAvg(const QString &windAvg) {
	d->windAvg = windAvg;
	d->hasWindAvg = true;
	emit windAvgChanged(windAvg);
	emit hasWindAvgChanged();
	emit saveToCache();
}

bool Sensor::hasWindAvg() const {
	return d->hasWindAvg;
}

QString Sensor::windGust() const {
	return d->windGust;
}

void Sensor::setWindGust(const QString &windGust) {
	d->windGust = windGust;
	d->hasWindGust = true;
	emit windGustChanged(windGust);
	emit hasWindGustChanged();
	emit saveToCache();
}

bool Sensor::hasWindGust() const {
	return d->hasWindGust;
}

QString Sensor::windDir() const {
	return d->windDir;
}

void Sensor::setWindDir(const QString &windDir) {
	d->windDir = windDir;
	d->hasWindDir = true;
	emit windDirChanged(windDir);
	emit hasWindDirChanged();
	emit saveToCache();
}

bool Sensor::hasWindDir() const {
	return d->hasWindDir;
}

// UV
QString Sensor::uv() const {
	return d->uv;
}

void Sensor::setUv(const QString &uv) {
	d->uv = uv;
	d->hasUv = true;
	emit uvChanged(uv);
	emit hasUvChanged();
	emit saveToCache();
}

bool Sensor::hasUv() const {
	return d->hasUv;
}

// Watt
QString Sensor::watt() const {
	return d->watt;
}

void Sensor::setWatt(const QString &watt) {
	d->watt = watt;
	d->hasWatt = true;
	emit wattChanged(watt);
	emit hasWattChanged();
	emit saveToCache();
}

bool Sensor::hasWatt() const {
	return d->hasWatt;
}

// UV
QString Sensor::luminance() const {
	return d->luminance;
}

void Sensor::setLuminance(const QString &luminance) {
	d->luminance = luminance;
	d->hasLuminance = true;
	emit luminanceChanged(luminance);
	emit hasLuminanceChanged();
	emit saveToCache();
}

bool Sensor::hasLuminance() const {
	return d->hasLuminance;
}

void Sensor::saveToCache() {
	QSqlDatabase db = QSqlDatabase::database();
	if (db.isOpen()) {
		QSqlQuery query(db);
		query.prepare("REPLACE INTO Sensor (id, name, lastUpdated, temperature, humidity, rainRate, rainTotal, uv, watt, windAvg, windGust, windDir, luminance, favorite) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
		query.bindValue(0, d->id);
		query.bindValue(1, d->name);
		query.bindValue(2, d->lastUpdated.toTime_t());
		query.bindValue(3, d->temperature);
		query.bindValue(4, d->humidity);
		query.bindValue(5, d->rainRate);
		query.bindValue(6, d->rainTotal);
		query.bindValue(7, d->uv);
		query.bindValue(8, d->watt);
		query.bindValue(9, d->windAvg);
		query.bindValue(10, d->windGust);
		query.bindValue(11, d->windDir);
		query.bindValue(12, d->luminance);
		query.bindValue(13, d->isFavorite);
		query.exec();
	}
}
