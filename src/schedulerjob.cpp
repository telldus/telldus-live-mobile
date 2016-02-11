#include "schedulerjob.h"
#include "tellduslive.h"
#include "models/devicemodel.h"
#include "models/clientmodel.h"
#include "device.h"
#include "client.h"

#include <QDebug>
#include <QSqlDatabase>
#include <QSqlQuery>

class SchedulerJob::PrivateData {
public:
	bool hasChanged, active;
	int id, deviceId, method, hour, minute, offset, randomInterval;
	int retries, retryInterval;
	QString methodValue, weekdays;
	QDateTime nextRunTime;
	Type type;
};

SchedulerJob::SchedulerJob(QObject *parent) :
	QObject(parent)
{
	d = new PrivateData;
	d->id = 0;
	d->deviceId = 0;
	d->method = 1;
	d->hour = 0;
	d->minute = 0;
	d->offset = 0;
	d->randomInterval = 0;
	d->retries = 0;
	d->retryInterval = 0;
	d->active = false;
	d->type = Time;
	connect(this, SIGNAL(hourChanged), this, SIGNAL(runTimeTodayChanged));
	connect(this, SIGNAL(minuteChanged), this, SIGNAL(runTimeTodayChanged));
	connect(this, SIGNAL(typeChanged), this, SIGNAL(runTimeTodayChanged));
	connect(this, SIGNAL(offsetChanged), this, SIGNAL(runTimeTodayChanged));
}

SchedulerJob::~SchedulerJob() {
	delete d;
}

int SchedulerJob::deviceId() const {
	return d->deviceId;
}

void SchedulerJob::setDeviceId(int deviceId) {
	if (deviceId == d->deviceId) {
		return;
	}
	d->deviceId = deviceId;
	emit deviceIdChanged();
	d->hasChanged = true;
	emit saveToCache();
}

int SchedulerJob::schedulerJobId() const {
	return d->id;
}

void SchedulerJob::setId(int id) {
	if (id == d->id) {
		return;
	}
	d->id = id;
	emit idChanged();
	d->hasChanged = true;
	emit saveToCache();
}

int SchedulerJob::method() const {
	return d->method;
}

void SchedulerJob::setMethod(int method) {
	if (method == d->method) {
		return;
	}
	d->method = method;
	emit methodChanged();
	d->hasChanged = true;
	emit saveToCache();
}

QString SchedulerJob::methodValue() const {
	return d->methodValue;
}

void SchedulerJob::setMethodValue(const QString &methodValue) {
	if (methodValue == d->methodValue) {
		return;
	}
	d->methodValue = methodValue;
	emit methodValueChanged();
	d->hasChanged = true;
	emit saveToCache();
}

QDateTime SchedulerJob::nextRunTime() const {
	return d->nextRunTime;
}

QTime SchedulerJob::runTimeToday() const {
	int timezoneOffset = 0;
	int sunrise = 0;
	int sunset = 0;
	Device *device = DeviceModel::instance()->findDevice(d->deviceId);
	if (device) {
		Client *client = ClientModel::instance()->findClientByName(device->clientName());
		if (client) {
			timezoneOffset = client->timezoneOffset();
			sunrise = client->sunrise();
			sunset = client->sunset();
		}
	}
	if (d->type == Sunrise) {
		return QDateTime::fromTime_t(sunrise, Qt::OffsetFromUTC, 0).time().addSecs((d->offset * 60) + timezoneOffset);
	} else if (d->type == Sunset) {
		return QDateTime::fromTime_t(sunset, Qt::OffsetFromUTC, 0).time().addSecs((d->offset * 60) + timezoneOffset);
	} else {
		return QTime(d->hour, d->minute, 0);
	}
}

void SchedulerJob::setNextRunTime(const QDateTime &nextRunTime) {
	if (nextRunTime == d->nextRunTime) {
		return;
	}
	d->nextRunTime = nextRunTime;
	emit nextRunTimeChanged();
	d->hasChanged = true;
	emit saveToCache();
}

SchedulerJob::Type SchedulerJob::type() const {
	return d->type;
}

void SchedulerJob::setType(SchedulerJob::Type type) {
	if (type == d->type) {
		return;
	}
	d->type = type;
	emit typeChanged();
	emit runTimeTodayChanged();
	d->hasChanged = true;
	emit saveToCache();
}

void SchedulerJob::setType(const QString &type) {
	if (type == "sunrise") {
		setType(Sunrise);
	} else if (type == "sunset") {
		setType(Sunset);
	} else {
		setType(Time);
	}
}

SchedulerJob::Type SchedulerJob::getTypeFromString(const QString &type) {
	if (type == "sunrise") {
		return Sunrise;
	} else if (type == "sunset") {
		return Sunset;
	} else {
		return Time;
	}
}

bool SchedulerJob::active() const {
	return d->active;
}

void SchedulerJob::setActive(bool active) {
	if (active == d->active) {
		return;
	}
	d->active = active;
	emit activeChanged();
	d->hasChanged = true;
	emit saveToCache();
}

int SchedulerJob::hour() const {
	return d->hour;
}

void SchedulerJob::setHour(int hour) {
	if (hour == d->hour) {
		return;
	}
	d->hour = hour;
	emit hourChanged();
	emit runTimeTodayChanged();
	d->hasChanged = true;
	emit saveToCache();
}

int SchedulerJob::minute() const {
	return d->minute;
}

void SchedulerJob::setMinute(int minute) {
	if (minute == d->minute) {
		return;
	}
	d->minute = minute;
	emit minuteChanged();
	emit runTimeTodayChanged();
	d->hasChanged = true;
	emit saveToCache();
}

int SchedulerJob::offset() const {
	return d->offset;
}

void SchedulerJob::setOffset(int offset) {
	if (offset == d->offset) {
		return;
	}
	d->offset = offset;
	emit offsetChanged();
	emit runTimeTodayChanged();
	d->hasChanged = true;
	emit saveToCache();
}

int SchedulerJob::randomInterval() const {
	return d->randomInterval;
}

void SchedulerJob::setRandomInterval(int randomInterval) {
	if (randomInterval == d->randomInterval) {
		return;
	}
	d->randomInterval = randomInterval;
	emit randomIntervalChanged();
	emit runTimeTodayChanged();
	d->hasChanged = true;
	emit saveToCache();
}

int SchedulerJob::retries() const {
	return d->retries;
}

void SchedulerJob::setRetries(int retries) {
	if (retries == d->retries) {
		return;
	}
	d->retries = retries;
	emit retriesChanged();
	d->hasChanged = true;
	emit saveToCache();
}

int SchedulerJob::retryInterval() const {
	return d->retryInterval;
}

void SchedulerJob::setRetryInterval(int retryInterval) {
	if (retryInterval == d->retryInterval) {
		return;
	}
	d->retryInterval = retryInterval;
	emit retryIntervalChanged();
	d->hasChanged = true;
	emit saveToCache();
}

QString SchedulerJob::weekdays() const {
	return d->weekdays;
}

void SchedulerJob::setWeekdays(const QString &weekdays) {
	if (weekdays == d->weekdays) {
		return;
	}
	d->weekdays = weekdays;
	emit weekdaysChanged();
	d->hasChanged = true;
	emit saveToCache();
}

void SchedulerJob::setFromVariantMap(const QVariantMap &dev) {
	if (d->id != dev["id"].toInt()) {
		d->id = dev["id"].toInt();
		emit idChanged();
		d->hasChanged = true;
	}
	if (d->deviceId != dev["deviceId"].toInt()) {
		d->deviceId = dev["deviceId"].toInt();
		emit deviceIdChanged();
		d->hasChanged = true;
	}
	if (d->method != dev["method"].toInt()) {
		d->method = dev["method"].toInt();
		emit methodChanged();
		d->hasChanged = true;
	}
	if (d->methodValue != dev["methodValue"].toString()) {
		d->methodValue = dev["methodValue"].toString();
		emit methodValueChanged();
		d->hasChanged = true;
	}
	if (d->nextRunTime != QDateTime::fromMSecsSinceEpoch(((qint64)dev["nextRunTime"].toInt()) * 1000)) {
		d->nextRunTime = QDateTime::fromMSecsSinceEpoch(((qint64)dev["nextRunTime"].toInt()) * 1000);
		emit nextRunTimeChanged();
		d->hasChanged = true;
	}
	if (d->type != (dev["type"].type() == QVariant::String ? getTypeFromString(dev["type"].toString()) : static_cast<SchedulerJob::Type>(dev["type"].toInt()))) {
		d->type = (dev["type"].type() == QVariant::String ? getTypeFromString(dev["type"].toString()) : static_cast<SchedulerJob::Type>(dev["type"].toInt()));
		emit typeChanged();
		d->hasChanged = true;
	}
	if (d->active != dev["active"].toBool()) {
		d->active = dev["active"].toBool();
		emit activeChanged();
		d->hasChanged = true;
	}
	if (d->hour != dev["hour"].toInt()) {
		d->hour = dev["hour"].toInt();
		emit hourChanged();
		d->hasChanged = true;
	}
	if (d->minute != dev["minute"].toInt()) {
		d->minute = dev["minute"].toInt();
		emit minuteChanged();
		d->hasChanged = true;
	}
	if (d->offset != dev["offset"].toInt()) {
		d->offset = dev["offset"].toInt();
		emit offsetChanged();
		d->hasChanged = true;
	}
	if (d->randomInterval != dev["randomInterval"].toInt()) {
		d->randomInterval = dev["randomInterval"].toInt();
		emit randomIntervalChanged();
		d->hasChanged = true;
	}
	if (d->retries != dev["retries"].toInt()) {
		d->retries = dev["retries"].toInt();
		emit retriesChanged();
		d->hasChanged = true;
	}
	if (d->retryInterval != dev["retryInterval"].toInt()) {
		d->retryInterval = dev["retryInterval"].toInt();
		emit retryIntervalChanged();
		d->hasChanged = true;
	}
	if (d->weekdays != dev["weekdays"].toString()) {
		d->weekdays = dev["weekdays"].toString();
		emit weekdaysChanged();
		d->hasChanged = true;
	}
	if (dev["fromCache"].toBool() == false) {
		emit saveToCache();
	} else {
		d->hasChanged = false;
	}
}

void SchedulerJob::saveToCache() {
	qDebug().noquote().nospace() << "[SCHEDULDERJOB:" << d->id << "] Saving to cache (hasChanged = " << d->hasChanged << ")";
	if (d->hasChanged) {
		QSqlDatabase db = QSqlDatabase::database();
		if (db.isOpen()) {
			QSqlQuery query(db);
			query.prepare("REPLACE INTO Scheduler (id, deviceId, method, methodValue, nextRunTime, type, hour, minute, offset, randomInterval, retries, retryInterval, weekdays, active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
			query.bindValue(0, d->id);
			query.bindValue(1, d->deviceId);
			query.bindValue(2, d->method);
			query.bindValue(3, d->methodValue);
			query.bindValue(4, d->nextRunTime.toTime_t());
			query.bindValue(5, d->type);
			query.bindValue(6, d->hour);
			query.bindValue(7, d->minute);
			query.bindValue(8, d->offset);
			query.bindValue(9, d->randomInterval);
			query.bindValue(10, d->retries);
			query.bindValue(11, d->retryInterval);
			query.bindValue(12, d->weekdays);
			query.bindValue(13, d->active);
			query.exec();
			qDebug().noquote().nospace() << "[SCHEDULDERJOB:" << d->id << "] Saved to cache";
			d->hasChanged = false;
		}
	}
}
