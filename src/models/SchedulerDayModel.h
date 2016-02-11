#ifndef SCHEDULERDAYMODEL_H
#define SCHEDULERDAYMODEL_H

#include "schedulerjob.h"
#include "tlistmodel.h"

class SchedulerModel;
class SchedulerJobInstance;

class SchedulerDayModel : public TListModel
{
	Q_OBJECT
public:
	SchedulerDayModel(SchedulerModel *model, QObject *parent = 0);
	SchedulerJobInstance *findSchedulerJobInstance(int id, int weekday) const;
	virtual QHash<int, QByteArray> roleNames() const;

protected:

signals:
	void modelDataChanged();

private slots:
	void reloadData();

private:
	class PrivateData;
	PrivateData *d;
};

#endif // SCHEDULERDAYMODEL_H
