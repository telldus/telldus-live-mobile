#ifndef SCHEDULERJOBINSTANCE_H
#define SCHEDULERJOBINSTANCE_H

#include <QObject>
#include <QMetaType>
#include <QVariantMap>
#include <QDateTime>
#include <QDate>
#include "schedulerjob.h"

class Device;

class SchedulerJobInstance : public QObject
{
	Q_OBJECT
	Q_ENUMS(Type)
	Q_PROPERTY(Device *device READ device NOTIFY deviceChanged)
	Q_PROPERTY(int deviceId READ deviceId WRITE setDeviceId NOTIFY deviceIdChanged)
	Q_PROPERTY(int schedulerJobId READ schedulerJobId WRITE setSchedulerJobId NOTIFY schedulerJobIdChanged)
	Q_PROPERTY(int method READ method WRITE setMethod NOTIFY methodChanged)
	Q_PROPERTY(QString methodValue READ methodValue WRITE setMethodValue NOTIFY methodValueChanged)
	Q_PROPERTY(QDateTime nextRunTime READ nextRunTime WRITE setNextRunTime NOTIFY nextRunTimeChanged)
	Q_PROPERTY(QDate nextRunDate READ nextRunDate WRITE setNextRunDate NOTIFY nextRunDateChanged)
	Q_PROPERTY(QTime runTimeToday READ runTimeToday WRITE setRunTimeToday NOTIFY runTimeTodayChanged)
	Q_PROPERTY(SchedulerJob::Type type READ type WRITE setType NOTIFY typeChanged)
	Q_PROPERTY(bool active READ active WRITE setActive NOTIFY activeChanged)
	Q_PROPERTY(int hour READ hour WRITE setHour NOTIFY hourChanged)
	Q_PROPERTY(int minute READ minute WRITE setMinute NOTIFY minuteChanged)
	Q_PROPERTY(int offset READ offset WRITE setOffset NOTIFY offsetChanged)
	Q_PROPERTY(int randomInterval READ randomInterval WRITE setRandomInterval NOTIFY randomIntervalChanged)
	Q_PROPERTY(int retries READ retries WRITE setRetries NOTIFY retriesChanged)
	Q_PROPERTY(int retryInterval READ retryInterval WRITE setRetryInterval NOTIFY retryIntervalChanged)
	Q_PROPERTY(int weekday READ weekday WRITE setWeekday NOTIFY weekdayChanged)
public:
	explicit SchedulerJobInstance(QObject *parent = 0);
	~SchedulerJobInstance();

	Device *device() const;

	int deviceId() const;
	void setDeviceId(int deviceId);

	int schedulerJobId() const;
	void setSchedulerJobId(int id);

	int method() const;
	void setMethod(int method);

	QString methodValue() const;
	void setMethodValue(const QString &methodValue );

	QDateTime nextRunTime() const;
	void calculateNextRunTime() const;
	void setNextRunTime(const QDateTime &nextRunTime );

	QDate nextRunDate() const;
	void setNextRunDate(const QDate &nextRunDate );

	QTime runTimeToday() const;
	void setRunTimeToday(const QTime &runTimeTodayrn );

	SchedulerJob::Type type() const;
	void setType(SchedulerJob::Type type);
	void setType(const QString &type );

	bool active() const;
	void setActive(bool active);

	int hour() const;
	void setHour(int hour);

	int minute() const;
	void setMinute(int minute);

	int offset() const;
	void setOffset(int offset);

	int randomInterval() const;
	void setRandomInterval(int randomInterval);

	int retries() const;
	void setRetries(int retries);

	int retryInterval() const;
	void setRetryInterval(int retryInterval);

	int weekday() const;
	void setWeekday(int weekday);

signals:
	void deviceChanged();
	void deviceIdChanged();
	void schedulerJobIdChanged();
	void methodChanged();
	void methodValueChanged();
	void nextRunTimeChanged();
	void nextRunDateChanged();
	void runTimeTodayChanged();
	void typeChanged();
	void activeChanged();
	void hourChanged();
	void minuteChanged();
	void offsetChanged();
	void randomIntervalChanged();
	void retriesChanged();
	void retryIntervalChanged();
	void weekdayChanged();

private:
	class PrivateData;
	PrivateData *d;
};

Q_DECLARE_METATYPE(SchedulerJobInstance*)

#endif // SCHEDULERJOBINSTANCE_H
