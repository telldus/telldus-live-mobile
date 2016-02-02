#ifndef SCHEDULERDAYSORTFILTERMODEL_H
#define SCHEDULERDAYSORTFILTERMODEL_H

#include <QSortFilterProxyModel>

class SchedulerDayModel;

class SchedulerDaySortFilterModel : public QSortFilterProxyModel
{
	Q_OBJECT
	Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
public:
	explicit SchedulerDaySortFilterModel(SchedulerDayModel *model, QObject *parent = 0);
	~SchedulerDaySortFilterModel();

signals:
	void countChanged();

protected:
	bool lessThan(const QModelIndex &left, const QModelIndex &right) const;
	bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const;

private:

};

#endif // SCHEDULERDAYSORTFILTERMODEL_H
