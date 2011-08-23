#include "schedulerjob.h"
#include "tellduslive.h"

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
}

int SchedulerJob::id() const {
	return d->id;
}

void SchedulerJob::setId(int id) {
	d->id = id;
	emit idChanged();
}

int SchedulerJob::method() const {
	return d->method;
}

void SchedulerJob::setMethod(int method) {
	d->method = method;
	emit methodChanged();
}

QString SchedulerJob::methodValue() const {
	return d->methodValue;
}

void SchedulerJob::setMethodValue(const QString &methodValue) {
	d->methodValue = methodValue;
	emit methodValueChanged();
}

QDateTime SchedulerJob::nextRunTime() const {
	return d->nextRunTime;
}

void SchedulerJob::setNextRunTime(const QDateTime &nextRunTime) {
	d->nextRunTime = nextRunTime;
	emit nextRunTimeChanged();
}

SchedulerJob::Type SchedulerJob::type() const {
	return d->type;
}

void SchedulerJob::setType(SchedulerJob::Type type) {
	d->type = type;
	emit typeChanged();
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
}

int SchedulerJob::minute() const {
	return d->minute;
}

void SchedulerJob::setMinute(int minute) {
	d->minute = minute;
	emit minuteChanged();
}

int SchedulerJob::offset() const {
	return d->offset;
}

void SchedulerJob::setOffset(int offset) {
	d->offset = offset;
	emit offsetChanged();
}

int SchedulerJob::randomInterval() const {
	return d->randomInterval;
}

void SchedulerJob::setRandomInterval(int randomInterval) {
	d->randomInterval = randomInterval;
	emit randomIntervalChanged();
}

int SchedulerJob::retries() const {
	return d->retries;
}

void SchedulerJob::setRetries(int retries) {
	d->retries = retries;
}

int SchedulerJob::retryInterval() const {
	return d->retryInterval;
}

void SchedulerJob::setRetryInterval(int retryInterval) {
	d->retryInterval = retryInterval;
	emit retryIntervalChanged();
}

QString SchedulerJob::weekdays() const {
	return d->weekdays;
}

void SchedulerJob::setWeekdays(const QString &weekdays) {
	d->weekdays = weekdays;
	emit weekdaysChanged();
}
