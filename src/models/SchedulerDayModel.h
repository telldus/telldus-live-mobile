#ifndef SCHEDULERDAYMODEL_H
#define SCHEDULERDAYMODEL_H

#include "schedulerjob.h"
#include "tlistmodel.h"

class SchedulerModel;

class SchedulerDayModel : public TListModel
{
	Q_OBJECT
public:
	SchedulerDayModel(SchedulerModel *model, QObject *parent = 0);
	virtual QHash<int, QByteArray> roleNames() const;

protected:

private slots:
	void reloadData();

private:
	class PrivateData;
	PrivateData *d;
};

#endif // SCHEDULERDAYMODEL_H
