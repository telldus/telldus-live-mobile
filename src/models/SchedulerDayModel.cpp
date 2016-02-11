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
	QList<QString> activeSchedulerJobInstances;
	for(int a = 0; a < d->model->rowCount(); ++a) {
		SchedulerJob *schedulerJob = qvariant_cast<SchedulerJob*>(d->model->index(a, 0).data());
		if (!schedulerJob) {
			continue;
		}
		QStringList weekdays = schedulerJob->weekdays().split(",");
		for(int b = 0; b < weekdays.size(); ++b) {
			SchedulerJobInstance *schedulerJobInstance = this->findSchedulerJobInstance(schedulerJob->schedulerJobId(), weekdays.at(b).toInt() - 1);
			if (!schedulerJobInstance) {
				schedulerJobInstance = new SchedulerJobInstance(this);
				schedulerJobInstance->setSchedulerJobId(schedulerJob->schedulerJobId());
				schedulerJobInstance->setWeekday(weekdays.at(b).toInt() - 1);
				list << schedulerJobInstance;
			}
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
			schedulerJobInstance->setActive(schedulerJob->active());
			activeSchedulerJobInstances << QString::number(schedulerJobInstance->schedulerJobId()) + "_" + QString::number(schedulerJobInstance->weekday());
		}
	}
	if (list.size()) {
		//Appends all in one go
		this->append(list);
	}
	for(int j=0; j < activeSchedulerJobInstances.count(); ++j) {
		for(int i = 0; i < this->rowCount(); ++i) {
			SchedulerJobInstance *schedulerJobInstance = qobject_cast<SchedulerJobInstance *>(this->get(i).value<QObject *>());
			if (activeSchedulerJobInstances.indexOf(QString::number(schedulerJobInstance->schedulerJobId()) + "_" + QString::number(schedulerJobInstance->weekday())) == -1) {
				this->splice(i, 1);
			}
		}
	}
	emit modelDataChanged();

}

SchedulerJobInstance *SchedulerDayModel::findSchedulerJobInstance(int id, int weekday) const {
	for(int i = 0; i < this->rowCount(); ++i) {
		SchedulerJobInstance *schedulerJobInstance = qobject_cast<SchedulerJobInstance *>(this->get(i).value<QObject *>());
		if (!schedulerJobInstance) {
			continue;
		}
		if (schedulerJobInstance->schedulerJobId() == id && schedulerJobInstance->weekday() == weekday) {
			return schedulerJobInstance;
		}
	}
	return 0;
}


QHash<int, QByteArray> SchedulerDayModel::roleNames() const {
	QHash<int, QByteArray> roles;
	roles[Qt::UserRole + 1] = "job";
	return roles;
}
