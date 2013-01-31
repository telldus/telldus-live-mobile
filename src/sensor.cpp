#include "sensor.h"
#include <math.h>
#include "tellduslive.h"
#include <QTimer>

class Sensor::PrivateData {
public:
	bool hasTemperature, hasHumidity;
	int id;
	QString name, temperature, humidity;
	QDateTime lastUpdated, lastPolled;
};

Sensor::Sensor(QObject *parent) :
	QObject(parent)
{
	d = new PrivateData;
	d->hasTemperature = false;
	d->hasHumidity = false;
	d->id = 0;
	connect(TelldusLive::instance(), SIGNAL(authorizedChanged()), this, SLOT(fetchData()));
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
	emit humidityChanged();
	emit hasHumidityChanged();
}

bool Sensor::hasHumidity() const {
	return d->hasHumidity;
}

int Sensor::sensorId() const {
	return d->id;
}

void Sensor::setId(int id) {
	d->id = id;
	fetchData();
	emit idChanged();
}

QDateTime Sensor::lastUpdated() const {
	return d->lastUpdated;
}

void Sensor::setLastUpdated(const QDateTime &lastUpdated) {
	d->lastUpdated = lastUpdated;
	emit lastUpdatedChanged();
}

int Sensor::minutesAgo() const {
	return round(d->lastUpdated.secsTo(QDateTime::currentDateTime())/60.0);
}

QString Sensor::name() const {
	return d->name;
}

void Sensor::setName(const QString &name) {
	d->name = name;
	emit nameChanged();
}

void Sensor::onInfoReceived(const QVariantMap &info) {
	setLastUpdated(QDateTime::fromMSecsSinceEpoch(((qint64)info["lastUpdated"].toInt()*1000)));
	foreach(QVariant v, info["data"].toList()) {
		QVariantMap info = v.toMap();
		if (info["name"].toString() == "temp") {
			setTemperature(info["value"].toString());

		} else if (info["name"].toString() == "humidity") {
			setHumidity(info["value"].toString());
		}
	}
}

QString Sensor::temperature() const {
	if (d->lastPolled.secsTo(QDateTime::currentDateTime()) > 300) {
		// Five minutes
		QTimer::singleShot(0, const_cast<Sensor*>(this), SLOT(fetchData()));
	}
	return d->temperature;
}

void Sensor::setTemperature(const QString &temperature) {
	d->temperature = temperature;
	d->hasTemperature = true;
	emit temperatureChanged();
	emit hasTemperatureChanged();
}

bool Sensor::hasTemperature() const {
	return d->hasTemperature;
}
