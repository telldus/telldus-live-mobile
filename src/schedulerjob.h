#ifndef SCHEDULERJOB_H
#define SCHEDULERJOB_H

#include <QObject>
#include <QMetaType>
#include <QVariantMap>
#include <QDateTime>

class SchedulerJob : public QObject
{
	Q_OBJECT
	Q_ENUMS(Type)
	Q_PROPERTY(int deviceId READ deviceId WRITE setDeviceId NOTIFY deviceIdChanged)
	Q_PROPERTY(int id READ schedulerJobId WRITE setId NOTIFY idChanged)
	Q_PROPERTY(int method READ method WRITE setMethod NOTIFY methodChanged)
	Q_PROPERTY(QString methodValue READ methodValue WRITE setMethodValue NOTIFY methodValueChanged)
	Q_PROPERTY(QDateTime nextRunTime READ nextRunTime WRITE setNextRunTime NOTIFY nextRunTimeChanged)
	Q_PROPERTY(QTime runTimeToday READ runTimeToday NOTIFY runTimeTodayChanged)
	Q_PROPERTY(Type type READ type WRITE setType NOTIFY typeChanged)
	Q_PROPERTY(bool active READ active WRITE setActive NOTIFY activeChanged)
	Q_PROPERTY(int hour READ hour WRITE setHour NOTIFY hourChanged)
	Q_PROPERTY(int minute READ minute WRITE setMinute NOTIFY minuteChanged)
	Q_PROPERTY(int offset READ offset WRITE setOffset NOTIFY offsetChanged)
	Q_PROPERTY(int randomInterval READ randomInterval WRITE setRandomInterval NOTIFY randomIntervalChanged)
	Q_PROPERTY(int retries READ retries WRITE setRetries NOTIFY retriesChanged)
	Q_PROPERTY(int retryInterval READ retryInterval WRITE setRetryInterval NOTIFY retryIntervalChanged)
	Q_PROPERTY(QString weekdays READ weekdays WRITE setWeekdays NOTIFY weekdaysChanged)
public:
	explicit SchedulerJob(QObject *parent = 0);
	~SchedulerJob();

	enum Type {Time, Sunset, Sunrise};

	int deviceId() const;
	void setDeviceId(int deviceId);

	int schedulerJobId() const;
	void setId(int id);

	int method() const;
	void setMethod(int method);

	QString methodValue() const;
	void setMethodValue(const QString &methodValue );

	QDateTime nextRunTime() const;
	void setNextRunTime(const QDateTime &nextRunTime );

	QTime runTimeToday() const;

	Type type() const;
	void setType(Type type);
	void setType(const QString &type );
	Type getTypeFromString(const QString &type );

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

	QString weekdays() const;
	void setWeekdays(const QString &weekdays);

	void setFromVariantMap(const QVariantMap &dev);

signals:
	void deviceIdChanged();
	void idChanged();
	void methodChanged();
	void methodValueChanged();
	void nextRunTimeChanged();
	void runTimeTodayChanged();
	void typeChanged();
	void activeChanged();
	void hourChanged();
	void minuteChanged();
	void offsetChanged();
	void randomIntervalChanged();
	void retriesChanged();
	void retryIntervalChanged();
	void weekdaysChanged();

private slots:
	void saveToCache();

private:
	class PrivateData;
	PrivateData *d;
};

Q_DECLARE_METATYPE(SchedulerJob*)

#endif // SCHEDULERJOB_H
