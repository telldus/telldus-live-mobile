#include "SchedulerDayModel.h"
#include "schedulermodel.h"
#include "schedulerjob.h"
#include "objects/SchedulerJobInstance.h"

#include <QDebug>

class SchedulerDayModel::PrivateData {
public:
	SchedulerModel *model;
};

SchedulerDayModel::SchedulerDayModel(SchedulerModel *model, QObject *parent) : TListModel("SchedulerJobInstance", parent) {
	connect(model, SIGNAL(jobsLoaded()), this, SLOT(reloadData()));
	d = new PrivateData;
	d->model = model;
	this->reloadData();
}

void SchedulerDayModel::reloadData() {
	QList<QObject *> list;
	for(int a = 0; a < d->model->rowCount(); ++a) {
		SchedulerJob *schedulerJob = qvariant_cast<SchedulerJob*>(d->model->index(a, 0).data());
		if (!schedulerJob) {
			continue;
		}
		QStringList weekdays = schedulerJob->weekdays().split(",");
		for(int b = 0; b < weekdays.size(); ++b) {
			SchedulerJobInstance *schedulerJobInstance = new SchedulerJobInstance(this);
			schedulerJobInstance->setSchedulerJobId(schedulerJob->schedulerJobId());
			schedulerJobInstance->setDeviceId(schedulerJob->deviceId());
			schedulerJobInstance->setMethod(schedulerJob->method());
			schedulerJobInstance->setHour(schedulerJob->hour());
			schedulerJobInstance->setMinute(schedulerJob->minute());
			schedulerJobInstance->setOffset(schedulerJob->offset());
			schedulerJobInstance->setRandomInterval(schedulerJob->randomInterval());
			schedulerJobInstance->setRetries(schedulerJob->retries());
			schedulerJobInstance->setRetryInterval(schedulerJob->retryInterval());
			schedulerJobInstance->setType(schedulerJob->type());
			schedulerJobInstance->setRunTimeToday(schedulerJob->runTimeToday());
			schedulerJobInstance->setWeekday(weekdays[b].toInt() - 1);
			schedulerJobInstance->setActive(schedulerJob->active());
			list << schedulerJobInstance;
		}
	}
	if (list.size()) {
		this->clear();
		//Appends all in one go
		this->append(list);
	}

}

QHash<int, QByteArray> SchedulerDayModel::roleNames() const {
	QHash<int, QByteArray> roles;
	roles[Qt::UserRole + 1] = "job";
	return roles;
}
