#ifndef DEVICELISTSORTFILTERMODEL_H
#define DEVICELISTSORTFILTERMODEL_H

#include <QSortFilterProxyModel>

class DeviceModel;

class DeviceListSortFilterModel : public QSortFilterProxyModel
{
	Q_OBJECT
	Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
public:
	explicit DeviceListSortFilterModel(DeviceModel *model, QObject *parent = 0);
	~DeviceListSortFilterModel();

signals:
	void countChanged();

protected:
	bool lessThan(const QModelIndex &left, const QModelIndex &right) const;
	bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const;


private:

};

#endif // DEVICELISTSORTFILTERMODEL_H
