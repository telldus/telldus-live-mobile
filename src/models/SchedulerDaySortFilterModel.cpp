#include "SchedulerDaySortFilterModel.h"

#include <QDebug>

#include "objects/SchedulerJobInstance.h"
#include "SchedulerDayModel.h"

SchedulerDaySortFilterModel::SchedulerDaySortFilterModel(SchedulerDayModel *model, QObject *parent) : QSortFilterProxyModel(parent)
{
	connect(model, SIGNAL(modelReset()), this, SLOT(invalidate()));
	connect(this, SIGNAL(rowsInserted(QModelIndex,int,int)), this, SLOT(invalidate()));
	connect(this, SIGNAL(rowsRemoved(QModelIndex,int,int)), this, SLOT(invalidate()));

	this->setSourceModel(model);
	this->setDynamicSortFilter(true);
	this->sort(0);
}

SchedulerDaySortFilterModel::~SchedulerDaySortFilterModel() {
}

bool SchedulerDaySortFilterModel::lessThan(const QModelIndex &left, const QModelIndex &right) const {
	SchedulerJobInstance *leftObject = qobject_cast<SchedulerJobInstance *>(this->sourceModel()->data(left).value<QObject *>());
	SchedulerJobInstance *rightObject = qobject_cast<SchedulerJobInstance *>(this->sourceModel()->data(right).value<QObject *>());

	return leftObject->nextRunTime() < rightObject->nextRunTime();
}