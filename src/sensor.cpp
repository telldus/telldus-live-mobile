#include "sensor.h"
#include <math.h>
#include "tellduslive.h"

#include <QTimer>
#include <QDebug>
#include <QSqlDatabase>
#include <QSqlQuery>

class Sensor::PrivateData {
public:
	bool hasChanged;
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
	if (humidity == d->humidity) {
		return;
	}
	d->humidity = humidity;
	d->hasHumidity = true;
	emit humidityChanged(humidity);
	emit hasHumidityChanged();
	d->hasChanged = true;
	emit saveToCache();
}

bool Sensor::hasHumidity() const {
	return d->hasHumidity;
}

QString Sensor::rainRate() const {
	return d->rainRate;
}

void Sensor::setRainRate(const QString &rainRate) {
	if (rainRate == d->rainRate) {
		return;
	}
	d->rainRate = rainRate;
	d->hasRainRate = true;
	emit rainRateChanged(rainRate);
	emit hasRainRateChanged();
	d->hasChanged = true;
	emit saveToCache();
}

bool Sensor::hasRainRate() const {
	return d->hasRainRate;
}

QString Sensor::rainTotal() const {
	return d->rainTotal;
}

void Sensor::setRainTotal(const QString &rainTotal) {
	if (rainTotal == d->rainTotal) {
		return;
	}
	d->rainTotal = rainTotal;
	d->hasRainTotal = true;
	emit rainTotalChanged(rainTotal);
	emit hasRainTotalChanged();
	d->hasChanged = true;
	emit saveToCache();
}

bool Sensor::hasRainTotal() const {
	return d->hasRainTotal;
}

int Sensor::sensorId() const {
	return d->id;
}

void Sensor::setId(int id) {
	if (id == d->id) {
		return;
	}
	d->id = id;
	emit idChanged();
	d->hasChanged = true;
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
	d->hasChanged = true;
	emit saveToCache();
}

QDateTime Sensor::lastUpdated() const {
	return d->lastUpdated;
}

void Sensor::setLastUpdated(const QDateTime &lastUpdated) {
	if (lastUpdated == d->lastUpdated) {
		return;
	}
	d->lastUpdated = lastUpdated;
	emit lastUpdatedChanged(lastUpdated);
	d->hasChanged = true;
	emit saveToCache();
}

int Sensor::minutesAgo() const {
	return round(d->lastUpdated.secsTo(QDateTime::currentDateTime()) / 60.0);
}

QString Sensor::name() const {
	return d->name;
}

void Sensor::setName(const QString &name) {
	if (name == d->name) {
		return;
	}
	d->name = name;
	emit nameChanged(name);
	d->hasChanged = true;
	emit saveToCache();
}

void Sensor::onInfoReceived(const QVariantMap &info) {
	setLastUpdated(QDateTime::fromMSecsSinceEpoch(((qint64)info["lastUpdated"].toInt() * 1000)));
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
	if (temperature == d->temperature) {
		return;
	}
	d->temperature = temperature;
	d->hasTemperature = true;
	emit temperatureChanged(temperature);
	emit hasTemperatureChanged();
	d->hasChanged = true;
	emit saveToCache();
}

bool Sensor::hasTemperature() const {
	return d->hasTemperature;
}

void Sensor::update(const QVariantMap &info) {
	setLastUpdated(QDateTime::fromMSecsSinceEpoch(((qint64)info["time"].toInt() * 1000)));
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
	if (windAvg == d->windAvg) {
		return;
	}
	d->windAvg = windAvg;
	d->hasWindAvg = true;
	emit windAvgChanged(windAvg);
	emit hasWindAvgChanged();
	d->hasChanged = true;
	emit saveToCache();
}

bool Sensor::hasWindAvg() const {
	return d->hasWindAvg;
}

QString Sensor::windGust() const {
	return d->windGust;
}

void Sensor::setWindGust(const QString &windGust) {
	if (windGust == d->windGust) {
		return;
	}
	d->windGust = windGust;
	d->hasWindGust = true;
	emit windGustChanged(windGust);
	emit hasWindGustChanged();
	d->hasChanged = true;
	emit saveToCache();
}

bool Sensor::hasWindGust() const {
	return d->hasWindGust;
}

QString Sensor::windDir() const {
	return d->windDir;
}

void Sensor::setWindDir(const QString &windDir) {
	if (windDir == d->windDir) {
		return;
	}
	d->windDir = windDir;
	d->hasWindDir = true;
	emit windDirChanged(windDir);
	emit hasWindDirChanged();
	d->hasChanged = true;
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
	if (uv == d->uv) {
		return;
	}
	d->uv = uv;
	d->hasUv = true;
	emit uvChanged(uv);
	emit hasUvChanged();
	d->hasChanged = true;
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
	if (watt == d->watt) {
		return;
	}
	d->watt = watt;
	d->hasWatt = true;
	emit wattChanged(watt);
	emit hasWattChanged();
	d->hasChanged = true;
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
	if (luminance == d->luminance) {
		return;
	}
	d->luminance = luminance;
	d->hasLuminance = true;
	emit luminanceChanged(luminance);
	emit hasLuminanceChanged();
	d->hasChanged = true;
	emit saveToCache();
}

bool Sensor::hasLuminance() const {
	return d->hasLuminance;
}

void Sensor::setFromVariantMap(const QVariantMap &dev) {
	if (d->id != dev["id"].toInt()) {
		d->id = dev["id"].toInt();
		emit idChanged();
		d->hasChanged = true;
	}
	if (d->name != dev["name"].toString()) {
		d->name = dev["name"].toString();
		emit nameChanged(dev["name"].toString());
		d->hasChanged = true;
	}
	if (d->lastUpdated != QDateTime::fromMSecsSinceEpoch(((qint64)dev["lastUpdated"].toInt()) * 1000)) {
		d->lastUpdated = QDateTime::fromMSecsSinceEpoch(((qint64)dev["lastUpdated"].toInt()) * 1000);
		emit lastUpdatedChanged(QDateTime::fromMSecsSinceEpoch(((qint64)dev["lastUpdated"].toInt()) * 1000));
		d->hasChanged = true;
	}
	if (dev.contains("temperature") && d->temperature != dev["temperature"].toString()) {
		d->temperature = dev["temperature"].toString();
		emit temperatureChanged(dev["temperature"].toString());
		d->hasTemperature = true;
		emit hasTemperatureChanged();
		d->hasChanged = true;
	}
	if (dev.contains("humidity") && d->humidity != dev["humidity"].toString()) {
		d->humidity = dev["humidity"].toString();
		emit humidityChanged(dev["humidity"].toString());
		d->hasHumidity = true;
		emit hasHumidityChanged();
		d->hasChanged = true;
	}
	if (dev.contains("rainRate") && d->rainRate != dev["rainRate"].toString()) {
		d->rainRate = dev["rainRate"].toString();
		emit rainRateChanged(dev["rainRate"].toString());
		d->hasRainRate = true;
		emit hasRainRateChanged();
		d->hasChanged = true;
	}
	if (dev.contains("rainTotal") && d->rainTotal != dev["rainTotal"].toString()) {
		d->rainTotal = dev["rainTotal"].toString();
		emit rainTotalChanged(dev["rainTotal"].toString());
		d->hasRainTotal = true;
		emit hasRainTotalChanged();
		d->hasChanged = true;
	}
	if (dev.contains("uv") && d->uv != dev["uv"].toString()) {
		d->uv = dev["uv"].toString();
		emit uvChanged(dev["uv"].toString());
		d->hasUv = true;
		emit hasUvChanged();
		d->hasChanged = true;
	}
	if (dev.contains("watt") && d->watt != dev["watt"].toString()) {
		d->watt = dev["watt"].toString();
		emit wattChanged(dev["watt"].toString());
		d->hasWatt = true;
		emit hasWattChanged();
		d->hasChanged = true;
	}
	if (dev.contains("luminance") && d->luminance != dev["luminance"].toString()) {
		d->luminance = dev["luminance"].toString();
		emit luminanceChanged(dev["luminance"].toString());
		d->hasLuminance = true;
		emit hasLuminanceChanged();
		d->hasChanged = true;
	}
	if (dev.contains("windAvg") && d->windAvg != dev["windAvg"].toString()) {
		d->windAvg = dev["windAvg"].toString();
		emit windAvgChanged(dev["windAvg"].toString());
		d->hasWindAvg = true;
		emit hasWindAvgChanged();
		d->hasChanged = true;
	}
	if (dev.contains("windGust") && d->windGust != dev["windGust"].toString()) {
		d->windGust = dev["windGust"].toString();
		emit windGustChanged(dev["windGust"].toString());
		d->hasWindGust = true;
		emit hasWindGustChanged();
		d->hasChanged = true;
	}
	if (dev.contains("windDir") && d->windDir != dev["windDir"].toString()) {
		d->windDir = dev["windDir"].toString();
		emit windDirChanged(dev["windDir"].toString());
		d->hasWindDir = true;
		emit hasWindDirChanged();
		d->hasChanged = true;
	}
	if (dev.contains("isfavorite") && d->isFavorite != dev["isfavorite"].toBool()) {
		d->isFavorite = dev["isfavorite"].toBool();
		emit isFavoriteChanged(dev["isfavorite"].toBool());
		d->hasChanged = true;
	}
	if (dev["fromCache"].toBool() == false) {
		emit saveToCache();
	} else {
		d->hasChanged = false;
	}
}

void Sensor::saveToCache() {
	qDebug().noquote().nospace() << "[SENSOR:" << d->id << "] Saving to cache (hasChanged = " << d->hasChanged << ")";
	if (d->hasChanged) {
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
			qDebug().noquote().nospace() << "[SENSOR:" << d->id << "] Saved to cache";
			d->hasChanged = false;
		}
	}
}
