#ifndef SCHEDULERJOBINSTANCE_H
#define SCHEDULERJOBINSTANCE_H

#include <QObject>
#include <QMetaType>
#include <QVariantMap>
#include <QDateTime>
#include "Schedulerjob.h"

class SchedulerJobInstance : public QObject
{
	Q_OBJECT
	Q_ENUMS(Type)
	Q_PROPERTY(int deviceId READ deviceId WRITE setDeviceId NOTIFY deviceIdChanged)
	Q_PROPERTY(int schedulerJobId READ schedulerJobId WRITE setSchedulerJobId NOTIFY schedulerJobIdChanged)
	Q_PROPERTY(int method READ method WRITE setMethod NOTIFY methodChanged)
	Q_PROPERTY(QString methodValue READ methodValue WRITE setMethodValue NOTIFY methodValueChanged)
	Q_PROPERTY(QDateTime nextRunTime READ nextRunTime WRITE setNextRunTime NOTIFY nextRunTimeChanged)
	Q_PROPERTY(SchedulerJob::Type type READ type WRITE setType NOTIFY typeChanged)
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

	int deviceId() const;
	void setDeviceId(int deviceId);

	int schedulerJobId() const;
	void setSchedulerJobId(int id);

	int method() const;
	void setMethod(int method);

	QString methodValue() const;
	void setMethodValue(const QString &methodValue );

	QDateTime nextRunTime() const;
	void setNextRunTime(const QDateTime &nextRunTime );

	SchedulerJob::Type type() const;
	void setType(SchedulerJob::Type type);
	void setType(const QString &type );

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
	void deviceIdChanged();
	void schedulerJobIdChanged();
	void methodChanged();
	void methodValueChanged();
	void nextRunTimeChanged();
	void typeChanged();
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
