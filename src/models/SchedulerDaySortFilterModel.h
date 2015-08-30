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

protected slots:
	void rowsAdded( const QModelIndex & parent, int start, int end );
//	void sensorChanged();

protected:
//	bool filterAcceptsRow ( int sourceRow, const QModelIndex & ) const;
	bool lessThan(const QModelIndex &left, const QModelIndex &right) const;

private:

};

#endif // SCHEDULERDAYSORTFILTERMODEL_H
