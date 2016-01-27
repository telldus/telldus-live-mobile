#include "SchedulerJobInstance.h"

#include <QDebug>
#include <QDate>

#include "models/devicemodel.h"

class SchedulerJobInstance::PrivateData {
public:
	int id, deviceId, method, hour, minute, offset, randomInterval;
	int retries, retryInterval, weekday;
	QString methodValue;
	QDateTime nextRunTime;
	QDate nextRunDate;
	QTime runTimeToday;
	SchedulerJob::Type type;
};

SchedulerJobInstance::SchedulerJobInstance(QObject *parent) :
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
	d->type = SchedulerJob::Time;
}

SchedulerJobInstance::~SchedulerJobInstance() {
	delete d;
}

Device *SchedulerJobInstance::device() const {
	return DeviceModel::instance()->findDevice(d->deviceId);
}

int SchedulerJobInstance::deviceId() const {
	return d->deviceId;
}

void SchedulerJobInstance::setDeviceId(int deviceId) {
	d->deviceId = deviceId;
	emit deviceIdChanged();
}

int SchedulerJobInstance::schedulerJobId() const {
	return d->id;
}

void SchedulerJobInstance::setSchedulerJobId(int id) {
	d->id = id;
	emit schedulerJobIdChanged();
}

int SchedulerJobInstance::method() const {
	return d->method;
}

void SchedulerJobInstance::setMethod(int method) {
	d->method = method;
	emit methodChanged();
}

QString SchedulerJobInstance::methodValue() const {
	return d->methodValue;
}

void SchedulerJobInstance::setMethodValue(const QString &methodValue) {
	d->methodValue = methodValue;
	emit methodValueChanged();
}

QDateTime SchedulerJobInstance::nextRunTime() const {
	QDateTime nextRun;
	QTime nextRunTime = runTimeToday();
	nextRun.setTime(nextRunTime);

	nextRun.setDate(QDate::currentDate().addDays( (weekday() + 1) - QDate::currentDate().dayOfWeek() ));

	if (nextRun < QDateTime::currentDateTime()) {
		nextRun = nextRun.addDays(7);
	}

	return nextRun;
}

void SchedulerJobInstance::setNextRunTime(const QDateTime &nextRunTime) {
	d->nextRunTime = nextRunTime;
	emit nextRunTimeChanged();
}

QDate SchedulerJobInstance::nextRunDate() const {
	QDateTime nextRun;
	QTime nextRunTime = QTime(hour(), minute(), 0);
	nextRun.setTime(nextRunTime);

	nextRun.setDate(QDate::currentDate().addDays( (weekday() + 1) - QDate::currentDate().dayOfWeek() ));

	if (nextRun < QDateTime::currentDateTime()) {
		nextRun = nextRun.addDays(7);
	}

	return nextRun.date();
}

void SchedulerJobInstance::setRunTimeToday(const QTime &runTimeToday) {
	d->runTimeToday = runTimeToday;
	emit runTimeTodayChanged();
}

QTime SchedulerJobInstance::runTimeToday() const {
	return d->runTimeToday;
}

void SchedulerJobInstance::setNextRunDate(const QDate &nextRunDate) {
	d->nextRunDate = nextRunDate;
	emit nextRunDateChanged();
}

SchedulerJob::Type SchedulerJobInstance::type() const {
	return d->type;
}

void SchedulerJobInstance::setType(SchedulerJob::Type type) {
	d->type = type;
	emit typeChanged();
}

void SchedulerJobInstance::setType(const QString &type) {
	if (type == "sunrise") {
		setType(SchedulerJob::Sunrise);
	} else if (type == "sunset") {
		setType(SchedulerJob::Sunset);
	} else {
		setType(SchedulerJob::Time);
	}
}

int SchedulerJobInstance::hour() const {
	return d->hour;
}

void SchedulerJobInstance::setHour(int hour) {
	d->hour = hour;
	emit hourChanged();
}

int SchedulerJobInstance::minute() const {
	return d->minute;
}

void SchedulerJobInstance::setMinute(int minute) {
	d->minute = minute;
	emit minuteChanged();
}

int SchedulerJobInstance::offset() const {
	return d->offset;
}

void SchedulerJobInstance::setOffset(int offset) {
	d->offset = offset;
	emit offsetChanged();
}

int SchedulerJobInstance::randomInterval() const {
	return d->randomInterval;
}

void SchedulerJobInstance::setRandomInterval(int randomInterval) {
	d->randomInterval = randomInterval;
	emit randomIntervalChanged();
}

int SchedulerJobInstance::retries() const {
	return d->retries;
}

void SchedulerJobInstance::setRetries(int retries) {
	d->retries = retries;
}

int SchedulerJobInstance::retryInterval() const {
	return d->retryInterval;
}

void SchedulerJobInstance::setRetryInterval(int retryInterval) {
	d->retryInterval = retryInterval;
	emit retryIntervalChanged();
}

int SchedulerJobInstance::weekday() const {
	return d->weekday;
}

void SchedulerJobInstance::setWeekday(int weekday) {
	d->weekday = weekday;
	emit weekdayChanged();
}
