#include "SchedulerDayModel.h"
#include "schedulermodel.h"
#include "schedulerjob.h"
#include "objects/SchedulerJobInstance.h"

#include <QDebug>

class SchedulerDayModel::PrivateData {
public:
	SchedulerModel *model;
};

SchedulerDayModel::SchedulerDayModel(SchedulerModel *model, QObject *parent) : QAbstractListModel(parent) {
	connect(model, SIGNAL(jobsLoaded()), this, SIGNAL(modelReset()));
	connect(this, SIGNAL(rowsInserted(QModelIndex,int,int)), this, SIGNAL(modelReset()));
	connect(this, SIGNAL(rowsRemoved(QModelIndex,int,int)), this, SIGNAL(modelReset()));
	d = new PrivateData;
	d->model = model;
}

QVariant SchedulerDayModel::data(const QModelIndex &index, int role) const {
	Q_UNUSED(role);
	if (!index.isValid()) {
		return QVariant();
	}
	int newRowCount = 0;
	for(int a = 0; a < d->model->rowCount(); a = a + 1) {
		SchedulerJob *schedulerJob = qvariant_cast<SchedulerJob*>(d->model->index(a, 0).data());
		QStringList weekdays = schedulerJob->weekdays().split(",");
		for(int b = 0; b < weekdays.size(); b = b + 1) {
			if (newRowCount == index.row()) {
				SchedulerJobInstance *schedulerJobInstance = new SchedulerJobInstance();
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
				return QVariant::fromValue(schedulerJobInstance);
			}
			newRowCount++;
		}
	}

	return QVariant();
}

int SchedulerDayModel::rowCount(const QModelIndex &parent) const {
	Q_UNUSED(parent)
	int newRowCount = 0;
	for(int a = 0; a < d->model->rowCount(); a = a + 1) {
		SchedulerJob *schedulerJob = qvariant_cast<SchedulerJob*>(d->model->index(a, 0).data());
		QStringList weekdays = schedulerJob->weekdays().split(",");
		newRowCount = newRowCount + weekdays.size();
	}

	return newRowCount;
}

QHash<int, QByteArray> SchedulerDayModel::roleNames() const {
	QHash<int, QByteArray> roles;
	roles[Qt::UserRole + 1] = "job";
	return roles;
}
