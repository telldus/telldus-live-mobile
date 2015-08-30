#ifndef SCHEDULERDAYMODEL_H
#define SCHEDULERDAYMODEL_H

#include "schedulerjob.h"
#include <QAbstractListModel>

class SchedulerModel;

class SchedulerDayModel : public QAbstractListModel
{
	Q_OBJECT
public:
	SchedulerDayModel(SchedulerModel *model, QObject *parent = 0);
	virtual QVariant data(const QModelIndex &index, int role) const;
	virtual int rowCount(const QModelIndex &parent) const;
	virtual QHash<int, QByteArray> roleNames() const;

protected:

private:
	class PrivateData;
	PrivateData *d;
};

#endif // SCHEDULERDAYMODEL_H
