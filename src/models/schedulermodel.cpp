#include "schedulermodel.h"
#include "schedulerjob.h"
#include "tellduslive.h"
#include <QDebug>

class SchedulerModel::PrivateData {
public:
	static SchedulerModel *instance;
};
SchedulerModel *SchedulerModel::PrivateData::instance = 0;

SchedulerModel::SchedulerModel() : TListModel("job") {
	d = new PrivateData();
	connect(TelldusLive::instance(), SIGNAL(authorizedChanged()), this, SLOT(authorizationChanged()));
	this->authorizationChanged();
}

SchedulerModel::~SchedulerModel() {
	delete d;
}

void SchedulerModel::addJobs(const QVariantList &jobList) {
	QList<QObject *> list;
	foreach(QVariant v, jobList) {
		QVariantMap dev = v.toMap();

		SchedulerJob *job = this->findJob(dev["id"].toInt());
		if (!job) {
			job = new SchedulerJob(this);
			job->setId(dev["id"].toInt());
			list << job;
		}
		job->setDeviceId(dev["deviceId"].toInt());
		job->setMethod(dev["method"].toInt());
		job->setMethodValue(dev["methodValue"].toString());
		job->setNextRunTime(QDateTime::fromMSecsSinceEpoch(((qint64)dev["nextRunTime"].toInt())*1000));
		job->setType(dev["type"].toString());
		job->setHour(dev["hour"].toInt());
		job->setMinute(dev["minute"].toInt());
		job->setOffset(dev["offset"].toInt());
		job->setRandomInterval(dev["randomInterval"].toInt());
		job->setRetries(dev["retries"].toInt());
		job->setRetryInterval(dev["retryInterval"].toInt());
		job->setWeekdays(dev["weekdays"].toString());
	}
	if (list.size()) {
		//Appends all in one go
		this->append(list);
	}
}

void SchedulerModel::authorizationChanged() {
	TelldusLive *telldusLive = TelldusLive::instance();
	if (telldusLive->isAuthorized()) {
		telldusLive->call("scheduler/jobList", TelldusLiveParams(), this, SLOT(onJobList(QVariantMap)));
	} else {
		this->clear();
	}
}

SchedulerJob *SchedulerModel::findJob(int id) const {
	for(int i = 0; i < this->rowCount(); ++i) {
		SchedulerJob *job = qobject_cast<SchedulerJob *>(this->get(i).value<QObject *>());
		if (!job) {
			continue;
		}
		if (job->schedulerJobId() == id) {
			return job;
		}
	}
	return 0;
}

QDateTime SchedulerModel::nextRunTimeForDevice(int deviceId) const {
	QDateTime retval;
	for(int i = 0; i < this->rowCount(); ++i) {
		SchedulerJob *job = qobject_cast<SchedulerJob *>(this->get(i).value<QObject *>());
		if (!job || job->deviceId() != deviceId) {
			continue;
		}
		if (retval == QDateTime()) {
			retval = job->nextRunTime();
			continue;
		}
		if (retval > job->nextRunTime()) {
			retval = job->nextRunTime();
			continue;
		}
	}
	return retval;
}

SchedulerModel * SchedulerModel::instance() {
	if (PrivateData::instance == 0) {
		PrivateData::instance = new SchedulerModel();
	}
	return PrivateData::instance;
}

void SchedulerModel::onJobList(const QVariantMap &result) {
	this->addJobs(result["job"].toList());
	emit jobsLoaded(result["job"].toList());
}
