#include "sensor.h"
#include <math.h>
#include "tellduslive.h"
#include <QTimer>

class Sensor::PrivateData {
public:
	bool hasHumidity, hasRainRate, hasRainTotal;
	bool hasTemperature;
	int id;
	QString name;
	QString humidity, rainRate, rainTotal;
	QString temperature;
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
}

QDateTime Sensor::lastUpdated() const {
	return d->lastUpdated;
}

void Sensor::setLastUpdated(const QDateTime &lastUpdated) {
	d->lastUpdated = lastUpdated;
	emit lastUpdatedChanged(lastUpdated);
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
		}
	}
}

QString Sensor::temperature() const {
	if (!d->lastPolled.isValid() || d->lastPolled.secsTo(QDateTime::currentDateTime()) > 300) {
		// Five minutes
		QTimer::singleShot(0, const_cast<Sensor*>(this), SLOT(fetchData()));
	}
	return d->temperature;
}

void Sensor::setTemperature(const QString &temperature) {
	d->temperature = temperature;
	d->hasTemperature = true;
	emit temperatureChanged(temperature);
	emit hasTemperatureChanged();
}

bool Sensor::hasTemperature() const {
	return d->hasTemperature;
}

void Sensor::update(const QVariantMap &info) {
	QVariantMap data = info["data"].toMap();
	if (data.contains("temp")) {
		setTemperature(data["temp"].toString());
	} else if (data.contains("humidity")) {
		setHumidity(data["humidity"].toString());
	}
	setLastUpdated(QDateTime::fromMSecsSinceEpoch(((qint64)info["time"].toInt()*1000)));
	d->lastPolled = QDateTime::currentDateTime();
}
