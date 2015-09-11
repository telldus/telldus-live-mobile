#include "schedulerjob.h"
#include "tellduslive.h"

#include <QDebug>
#include <QSqlDatabase>
#include <QSqlQuery>

class SchedulerJob::PrivateData {
public:
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
	d->type = Time;
}

SchedulerJob::~SchedulerJob() {
	delete d;
}

int SchedulerJob::deviceId() const {
	return d->deviceId;
}

void SchedulerJob::setDeviceId(int deviceId) {
	d->deviceId = deviceId;
	emit deviceIdChanged();
	emit saveToCache();
}

int SchedulerJob::schedulerJobId() const {
	return d->id;
}

void SchedulerJob::setId(int id) {
	d->id = id;
	emit idChanged();
	emit saveToCache();
}

int SchedulerJob::method() const {
	return d->method;
}

void SchedulerJob::setMethod(int method) {
	d->method = method;
	emit methodChanged();
	emit saveToCache();
}

QString SchedulerJob::methodValue() const {
	return d->methodValue;
}

void SchedulerJob::setMethodValue(const QString &methodValue) {
	d->methodValue = methodValue;
	emit methodValueChanged();
	emit saveToCache();
}

QDateTime SchedulerJob::nextRunTime() const {
	return d->nextRunTime;
}

void SchedulerJob::setNextRunTime(const QDateTime &nextRunTime) {
	d->nextRunTime = nextRunTime;
	emit nextRunTimeChanged();
	emit saveToCache();
}

SchedulerJob::Type SchedulerJob::type() const {
	return d->type;
}

void SchedulerJob::setType(SchedulerJob::Type type) {
	d->type = type;
	emit typeChanged();
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

int SchedulerJob::hour() const {
	return d->hour;
}

void SchedulerJob::setHour(int hour) {
	d->hour = hour;
	emit hourChanged();
	emit saveToCache();
}

int SchedulerJob::minute() const {
	return d->minute;
}

void SchedulerJob::setMinute(int minute) {
	d->minute = minute;
	emit minuteChanged();
	emit saveToCache();
}

int SchedulerJob::offset() const {
	return d->offset;
}

void SchedulerJob::setOffset(int offset) {
	d->offset = offset;
	emit offsetChanged();
	emit saveToCache();
}

int SchedulerJob::randomInterval() const {
	return d->randomInterval;
}

void SchedulerJob::setRandomInterval(int randomInterval) {
	d->randomInterval = randomInterval;
	emit randomIntervalChanged();
	emit saveToCache();
}

int SchedulerJob::retries() const {
	return d->retries;
}

void SchedulerJob::setRetries(int retries) {
	d->retries = retries;
	emit retriesChanged();
	emit saveToCache();
}

int SchedulerJob::retryInterval() const {
	return d->retryInterval;
}

void SchedulerJob::setRetryInterval(int retryInterval) {
	d->retryInterval = retryInterval;
	emit retryIntervalChanged();
	emit saveToCache();
}

QString SchedulerJob::weekdays() const {
	return d->weekdays;
}

void SchedulerJob::setWeekdays(const QString &weekdays) {
	d->weekdays = weekdays;
	emit weekdaysChanged();
	emit saveToCache();
}

void SchedulerJob::saveToCache() {
	QSqlDatabase db = QSqlDatabase::database();
	if (db.isOpen()) {
		QSqlQuery query(db);
		query.prepare("REPLACE INTO Scheduler (id, deviceId, method, methodValue, nextRunTime, type, hour, minute, offset, randomInterval, retries, retryInterval, weekdays) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
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
		query.exec();
	}
}
