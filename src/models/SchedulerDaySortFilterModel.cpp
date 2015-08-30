#include "SchedulerDaySortFilterModel.h"

#include <QDebug>

#include "objects/SchedulerJobInstance.h"
#include "SchedulerDayModel.h"

SchedulerDaySortFilterModel::SchedulerDaySortFilterModel(SchedulerDayModel *model, QObject *parent) : QSortFilterProxyModel(parent)
{
	this->setSourceModel(model);
	this->setDynamicSortFilter(true);
	this->sort(0);
	connect(model, SIGNAL(rowsInserted(QModelIndex,int,int)), this, SLOT(rowsAdded(QModelIndex,int,int)));
	connect(this, SIGNAL(rowsInserted(QModelIndex,int,int)), this, SIGNAL(countChanged()));
	connect(this, SIGNAL(rowsRemoved(QModelIndex,int,int)), this, SIGNAL(countChanged()));
}

SchedulerDaySortFilterModel::~SchedulerDaySortFilterModel() {
}

/*bool SchedulerDaySortFilterModel::filterAcceptsRow(int sourceRow, const QModelIndex &) const {
	SchedulerDayModel *model = qobject_cast<SchedulerDayModel *>(this->sourceModel());
	if (!model) {
		//Should not happen
		return false;
	}
	SchedulerJobInstance *schedulerJobInstance = qobject_cast<SchedulerJobInstance *>(model->get(sourceRow).value<QObject *>());
	return schedulerJobInstance->isFavorite();
}*/

bool SchedulerDaySortFilterModel::lessThan(const QModelIndex &left, const QModelIndex &right) const {
	SchedulerJobInstance *leftObject = qobject_cast<SchedulerJobInstance *>(this->sourceModel()->data(left).value<QObject *>());
	SchedulerJobInstance *rightObject = qobject_cast<SchedulerJobInstance *>(this->sourceModel()->data(right).value<QObject *>());

	return leftObject->nextRunTime() < rightObject->nextRunTime();
}

void SchedulerDaySortFilterModel::rowsAdded(const QModelIndex &, int start, int end) {
	SchedulerDayModel *model = qobject_cast<SchedulerDayModel *>(this->sourceModel());
	if (!model) {
		return;
	}
	for (int i = start; i <= end; ++i ) {
//		SchedulerJobInstance *schedulerJobInstance = qobject_cast<SchedulerJobInstance *>(model->get(i).value<QObject *>());
//		connect(schedulerJobInstance, SIGNAL(isFavoriteChanged(const bool &)), this, SLOT(sensorChanged()));
//		connect(schedulerJobInstance, SIGNAL(nameChanged(const QString &)), this, SLOT(invalidate()));
	}
}

//void SchedulerDaySortFilterModel::sensorChanged() {
//	this->invalidateFilter();
//}
