#ifndef SENSORLISTSORTFILTERMODEL_H
#define SENSORLISTSORTFILTERMODEL_H

#include <QSortFilterProxyModel>

class SensorModel;

class SensorListSortFilterModel : public QSortFilterProxyModel
{
	Q_OBJECT
	Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
public:
	explicit SensorListSortFilterModel(SensorModel *model, QObject *parent = 0);
	~SensorListSortFilterModel();

signals:
	void countChanged();

protected:
	bool lessThan(const QModelIndex &left, const QModelIndex &right) const;
//	bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const;


private:

};

#endif // SENSORLISTSORTFILTERMODEL_H
